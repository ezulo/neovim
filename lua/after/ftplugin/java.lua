local jdtls = require('jdtls')

-- Mason paths
local mason_path = vim.fn.stdpath('data') .. '/mason/packages'
local jdtls_path = mason_path .. '/jdtls'
local java_debug_path = mason_path .. '/java-debug-adapter'

-- Find project root
local root_markers = { 'pom.xml', 'build.gradle', 'gradlew', '.git' }
local root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1])

-- Workspace directory for jdtls (stores project-specific data)
local project_name = vim.fn.fnamemodify(root_dir or vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name

-- Build jdtls command using Mason installation
local function get_jdtls_cmd()
  local launcher = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
  local config_dir
  if vim.fn.has('win32') == 1 then
    config_dir = jdtls_path .. '/config_win'
  elseif vim.fn.has('mac') == 1 then
    config_dir = jdtls_path .. '/config_mac'
  else
    config_dir = jdtls_path .. '/config_linux'
  end
  return {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', launcher,
    '-configuration', config_dir,
    '-data', workspace_dir,
  }
end

-- Java-debug extension bundles
local bundles = {}
local java_debug_jar = vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar', false, true)[1]
if java_debug_jar and java_debug_jar ~= '' then
  table.insert(bundles, java_debug_jar)
end

local config = {
  cmd = get_jdtls_cmd(),
  root_dir = root_dir,
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
    },
  },
  init_options = {
    bundles = bundles,
  },
  on_attach = function(client, bufnr)
    -- Enable debugging support
    if #bundles > 0 then
      jdtls.setup_dap({ hotcodereplace = 'auto' })
    end

    -- Java-specific keymaps
    local opts = { buffer = bufnr }
    vim.keymap.set('n', '<leader>jo', jdtls.organize_imports, opts)
    vim.keymap.set('n', '<leader>jv', jdtls.extract_variable, opts)
    vim.keymap.set('v', '<leader>jv', function() jdtls.extract_variable(true) end, opts)
    vim.keymap.set('v', '<leader>jm', function() jdtls.extract_method(true) end, opts)
  end,
}

-- DAP configurations for remote debugging
local dap = require('dap')
dap.configurations.java = dap.configurations.java or {}
table.insert(dap.configurations.java, {
  type = 'java',
  request = 'attach',
  name = 'Attach to remote (5005)',
  hostName = '127.0.0.1',
  port = 5005,
})

jdtls.start_or_attach(config)
