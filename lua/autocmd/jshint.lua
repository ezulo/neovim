local group = vim.api.nvim_create_augroup("JSHint", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = group,
  pattern = { "*.js" },
  callback = function()
    local fp = vim.fn.expand('%:p')
    local output = vim.fn.systemlist("jshint --reporter=unix " .. vim.fn.shellescape(fp))

    local qflist = {}
    for _, line in ipairs(output) do
      local file, lnum, col, msg = line:match("^(.+):(%d+):(%d+): (.+)$")
      if file then
        table.insert(qflist, {
          filename = file,
          lnum = tonumber(lnum),
          col = tonumber(col),
          text = msg,
          type = "W",
        })
      end
    end

    vim.fn.setqflist(qflist, 'r')
    if #qflist > 0 then
      vim.cmd('copen')
    else
      vim.cmd('cclose')
    end
  end
})
