return {
    {
        "glepnir/template.nvim",
        cmd = { "Template", "TemProject" },
        config = function()
            require("template").setup({
                temp_dir = "~/.config/nvim/templates",
            })

            require("template").register("{{_namespace_}}", function()
                local path = vim.fn.expand('%:p:h')
                local cwd = vim.fn.getcwd()

                local rel_path = path:gsub("^" .. cwd:gsub("([^%w])", "%%%1") .. "/", "")
                local namespace = rel_path:gsub('/', '.')

                namespace = namespace:gsub('^src%.', ''):gsub('^source%.', '')

                if namespace == '' or namespace == '.' then
                    return ''
                end
                return namespace
            end)

            vim.keymap.set("n", "<leader>tem", "<cmd>Telescope find_template type=insert<cr>")
        end,
    },
}
