if vim.loop.os_uname().sysname == "Windows" then
  -- Do nothing
else
  latexgroup = vim.api.nvim_create_augroup("Latex", {})
  function trim(s)
    return s:match '^%s*(.*%S)' or ''
  end

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = latexgroup,
    pattern = { "*.tex" },
    callback = function()
      local fp = vim.fn.expand('%:p')
      local dir = vim.fn.system('dirname ' .. fp)
      local cmd = "pdflatex -output-directory " .. trim(dir) .. " " .. fp
      print(fp)
      print(dir)
      print(cmd)
      local res = vim.fn.system(cmd)
      print(res)
    end
  })
end
