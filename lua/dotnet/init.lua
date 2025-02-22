local M = {}
local utils = require("utils")
local picker = require("pickers.telescope")

-- Generates a relative path from cwd to the project.csproj file
local function generate_relative_path_for_project(path, slnpath)
	local dir = vim.fs.dirname(slnpath)
	local res = utils.fs.joinpath(dir, path):gsub("\\", "/")
	return res
end

local function extract_from_project(project_file_path, pattern)
	if project_file_path == nil then
		return false
	end

	local file = io.open(project_file_path, "r")
	if not file then
		return false
	end
	local contains_pattern = utils.iter(file:lines()):find(function(line)
		local value = line:match(pattern)
		if value then
			return true
		end
		return false
	end)

	local result = (type(contains_pattern) == "string" and contains_pattern:match(pattern)) or false

	file:close()
	return result
end

---Extracts the project name from a path
---@param path string
---@return string
local function extractProjectName(path)
	local filename = path:match("[^/\\]+%.%a+proj")
	if filename == nil then
		return "Unknown"
	end
	return filename:gsub("%.csproj$", ""):gsub("%.fsproj$", "")
end

---@type table<string, DotnetProject>
local project_cache = {}

M.get_debug_dll = function()
	local sln_file = M.find_solution_file()
	local result = sln_file ~= nil and M.get_dll_for_solution_project(sln_file) or M.get_dll_for_project()
	local relative_dll_path = utils.fs.joinpath(vim.fn.getcwd(), result.dll)
	local relative_project_path = utils.fs.joinpath(vim.fn.getcwd(), result.project)
	return {
		dll_path = result.dll,
		project_path = result.project,
		project_name = result.projectName,
		relative_dll_path = relative_dll_path,
		relative_project_path = relative_project_path,
	}
end

M.find_solution_file = function(no_cache)
	local files = M.get_solutions()
	local opts = {}
	for _, value in ipairs(files) do
		-- local file = require("easy-dotnet.default-manager").try_get_cache_file(value)
		-- if file and not no_cache then
		--   ---@type string
		--   return value
		-- end
		table.insert(opts, { display = value, ordinal = value, value = value })
	end
	if #opts == 0 then
		return nil
	end
	local selection = require("pickers.telescope").pick_sync(nil, opts, "Pick solution file")
	return selection and selection.value or nil
	-- return nil
end

M.get_dll_for_project = function()
	local project_file_path = M.find_project_file()
	if project_file_path == nil then
		error("No project or solution file found")
	end
	local project = M.get_project_from_project_file(project_file_path)
	local path = vim.fs.dirname(project.path)
	return {
		projectName = project.name,
		dll = project.get_dll_path(),
		project = path,
	}
end

M.get_dll_for_solution_project = function(sln_file)
	local projects = M.get_projects_from_sln(sln_file)
	---@type DotnetProject[]
	local runnable_projects = utils.tbl_filter(function(i)
		return i.runnable == true
	end, projects)

	---@type DotnetProject
	local project
	if #runnable_projects == 0 then
		error("No runnable projects found")
	elseif #runnable_projects > 1 then
		project = picker.pick_sync(nil, runnable_projects, "Select project to debug")
	end

	project = project or runnable_projects[1]

	if project == nil then
		error("No project selected")
	end

	local path = vim.fs.dirname(project.path)
	return {
		dll = project.get_dll_path(),
		project = path,
		projectName = project.name,
	}
end

-- TODO: Investigate using dotnet sln list command
---@param solution_file_path string
---@return DotnetProject[]
M.get_projects_from_sln = function(solution_file_path)
	local extension = vim.fn.fnamemodify(solution_file_path, ":e")
	if extension == "slnx" then
		return nil
	end

	local file_contents = vim.fn.readfile(solution_file_path)
	local regexp = 'Project%("{(.-)}"%).*= "(.-)", "(.-)", "{.-}"'

	local projectLines = utils.tbl_filter(function(line)
		local id, name, path = line:match(regexp)
		if id and name and path and (path:match("%.csproj$") or path:match("%.fsproj$")) then
			return true
		end
		return false
	end, file_contents)

	local projects = utils.tbl_map(function(line)
		local _, _, path = line:match(regexp)
		local project_file_path = generate_relative_path_for_project(path, solution_file_path)
		local project = M.get_project_from_project_file(project_file_path)
		return project
	end, projectLines)

	return projects
end

function M.get_solutions()
	local sln_files = require("plenary.scandir").scan_dir({ "." }, { search_pattern = "%.sln$", depth = 5 })
	local slnx_files = require("plenary.scandir").scan_dir({ "." }, { search_pattern = "%.slnx$", depth = 5 })

	local normalized = {}
	for _, value in ipairs(sln_files) do
		table.insert(normalized, value)
	end
	for _, value in ipairs(slnx_files) do
		table.insert(normalized, value)
	end
	return normalized
end

-- Get the project definition from a csproj/fsproj file
---@param project_file_path string
---@return DotnetProject
M.get_project_from_project_file = function(project_file_path)
	local maybeCacheObject = project_cache[project_file_path]
	if maybeCacheObject then
		return maybeCacheObject
	end
	local display = extractProjectName(project_file_path)
	local name = display
	local language = project_file_path:match("%.csproj$") and "csharp"
		or project_file_path:match("%.fsproj$") and "fsharp"
		or "unknown"
	local isWebProject = M.is_web_project(project_file_path)
	local isConsoleProject = M.is_console_project(project_file_path)
	local isTestProject = M.is_test_project(project_file_path)
	local maybeSecretGuid = M.try_get_secret_id(project_file_path)
	local version = M.extract_version(project_file_path)

	if version then
		display = display .. "@" .. version
	end

	if language == "csharp" then
		display = display .. " 󰙱"
	elseif language == "fsharp" then
		display = display .. " 󰫳"
	end

	if isTestProject then
		display = display .. " 󰙨"
	end
	if maybeSecretGuid then
		display = display .. " "
	end
	if isWebProject then
		display = display .. " 󱂛"
	end
	if isConsoleProject then
		display = display .. " 󰆍"
	end

	local project = {
		display = display,
		path = project_file_path,
		language = language,
		name = name,
		version = version,
		runnable = isWebProject or isConsoleProject,
		secrets = maybeSecretGuid,
		get_dll_path = function()
			local c = project_cache[project_file_path]
			if c and c.dll_path then
				return c.dll_path
			end
			local value = vim.fn.json_decode(
				vim.fn.system(
					string.format(
						"dotnet msbuild %s -getProperty:OutputPath -getProperty:TargetExt -getProperty:AssemblyName -getProperty:TargetFramework",
						project_file_path
					)
				)
			).Properties
			local target = string.format("%s%s", value.AssemblyName, value.TargetExt)
			local path = utils.fs.joinpath(vim.fs.dirname(project_file_path), value.OutputPath:gsub("\\", "/"), target)
			local msbuild_target_framework = value.TargetFramework:gsub("%net", "")

			c["version"] = msbuild_target_framework
			c["dll_path"] = path
			return path
		end,
		isTestProject = isTestProject,
		isConsoleProject = isConsoleProject,
		isWebProject = isWebProject,
	}

	project_cache[project_file_path] = project
	if version then
		project_cache[project_file_path].dll_path =
			utils.fs.joinpath(vim.fs.dirname(project_file_path), "bin", "Debug", "net" .. version, name .. ".dll")
	end

	return project
end

M.is_console_project = function(project_file_path)
	return type(extract_from_project(project_file_path, "<OutputType>%s*Exe%s*</OutputType>")) == "string"
end

M.is_test_project = function(project_file_path)
	if
		type(extract_from_project(project_file_path, "<%s*IsTestProject%s*>%s*true%s*</%s*IsTestProject%s*>"))
		== "string"
	then
		return true
	end

	-- Check for test-related package references
	local test_packages = {
		"Microsoft%.NET%.Test%.Sdk",
		"MSTest%.TestFramework",
		"NUnit",
		"xunit",
	}

	for _, package in ipairs(test_packages) do
		local pattern = string.format('<PackageReference Include="%s"%%s*', package)
		if type(extract_from_project(project_file_path, pattern)) == "string" then
			return true
		end
	end

	return false
end

M.is_web_project = function(project_file_path)
	return type(extract_from_project(project_file_path, '<Project%s+Sdk="Microsoft.NET.Sdk.Web"')) == "string"
end

M.extract_version = function(project_file_path)
	local version = extract_from_project(project_file_path, "<TargetFramework>net(.-)</TargetFramework>")
	if version == false then
		return nil
	end
	return version
end

M.try_get_secret_id = function(project_file_path)
	local secret = extract_from_project(project_file_path, "<UserSecretsId>([a-fA-F0-9%-]+)</UserSecretsId>")
	if secret == false then
		return nil
	end
	return secret
end

M.find_csproj_file = function()
	local file = require("plenary.scandir").scan_dir({ "." }, { search_pattern = "%.csproj$", depth = 3 })
	return file[1]
end

M.find_fsproj_file = function()
	local file = require("plenary.scandir").scan_dir({ "." }, { search_pattern = "%.fsproj$", depth = 3 })
	return file[1]
end

---Tries to find a csproj or fsproj file
M.find_project_file = function()
	return M.find_csproj_file() or M.find_fsproj_file()
end

M.get_environment_variables = function(project_name, relative_project_path)
	local launchSettings = utils.fs.joinpath(relative_project_path, "Properties", "launchSettings.json")

	local stat = vim.loop.fs_stat(launchSettings)
	if stat == nil then
		return nil
	end

	local success, result = pcall(vim.fn.json_decode, vim.fn.readfile(launchSettings, ""))
	if not success then
		return nil, "Error parsing JSON: " .. result
	end

	local launchProfile = result.profiles[project_name]

	if launchProfile == nil then
		return nil
	end

	--TODO: Is there more env vars in launchsetttings.json?
	launchProfile.environmentVariables["ASPNETCORE_URLS"] = launchProfile.applicationUrl
	return launchProfile.environmentVariables
end

return M
