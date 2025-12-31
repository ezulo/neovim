vim.cmd("set termguicolors")

return {
    "norcalli/nvim-colorizer.lua",
    version = "*",
    lazy = false,
    config = function()
        require 'colorizer'.setup {
            '*',
            css = { rgb_fn = true; },
            html = { names = true; },
            conf = { rgb_fn = true; }
        }
    end,
}
