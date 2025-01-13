-- add this to your lua/plugins.lua, lua/plugins/init.lua,  or the file you keep your other plugins:
return {
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup({
                ignore = "^$",
                toggler = {
                    line = "<C-_>",
                },
                opleader = {
                    line = "<C-_>",
                },
            })
        end,
    },
}
