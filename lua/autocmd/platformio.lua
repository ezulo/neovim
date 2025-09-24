piogroup = vim.api.nvim_create_augroup("PlatformIO", {})

-- Build
vim.api.nvim_create_autocmd("BufWritePost", {
    group = piogroup,
    pattern = { "**/platformio/**/src/*.c", "**/platformio/**/src/*.cpp" },
    callback = function()
        local fp = vim.fn.expand('%:p')
        local res = vim.fn.system("cpplint "..fp)
        print(res)
    end
})

