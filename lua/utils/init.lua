local M = {
	fs = {},
}

function M.fs.joinpath(...)
	return (table.concat({ ... }, "/"):gsub("//+", "/"))
end

function M.tbl_filter(func, t)
	vim.validate({ func = { func, "c" }, t = { t, "t" } })
	--- @cast t table<any,any>

	local rettab = {} --- @type table<any,any>
	for _, entry in pairs(t) do
		if func(entry) then
			rettab[#rettab + 1] = entry
		end
	end
	return rettab
end

--- Apply a function to all values of a table.
---
---@generic T
---@param func fun(value: T): any Function
---@param t table<any, T> Table
---@return table : Table of transformed values
function M.tbl_map(func, t)
	vim.validate({ func = { func, "c" }, t = { t, "t" } })
	--- @cast t table<any,any>

	local rettab = {} --- @type table<any,any>
	for k, v in pairs(t) do
		rettab[k] = func(v)
	end
	return rettab
end

M.iter = require("utils.iter")

return M
