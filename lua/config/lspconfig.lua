vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luacheckrc', '.git' },
})
vim.lsp.config('marksman', {
  cmd = { 'marksman', 'server' },
  filetypes = { 'markdown' },
  root_markers = { '.marksman.toml', '.git' },
})
vim.lsp.config('clangd', {
  cmd = { 'clangd', '--query-driver=**/xtensa-esp*-elf-gcc' },
  filetypes = { 'c', 'cpp' },
  root_markers = { 'compile_commands.json', '.clangd', '.git' },
})
vim.lsp.enable('lua_ls')
vim.lsp.enable('marksman')
vim.lsp.enable('clangd')
