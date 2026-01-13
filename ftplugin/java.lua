local home = os.getenv 'HOME'
local workspace_path = home .. '/.local/share/nvim/jdtls-workspace/'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = workspace_path .. project_name

local status, jdtls = pcall(require, 'jdtls')
if not status then
  return
end
local extendedClientCapabilities = jdtls.extendedClientCapabilities

-- This part is for running the debugger
local bundles = {
  vim.fn.glob '~/.config/nvim/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar',
}

-- Extend the debuuger bundles with the test bundles
-- vim.list_extend(bundles, vim.split(vim.fn.glob '~/.config/nvim/vscode-java-test/server/*.jar', '\n'))
local java_test_bundles = vim.split(vim.fn.glob('~/.config/nvim/vscode-java-test/server/*.jar', 1), '\n')
local excluded = {
  'com.microsoft.java.test.runner-jar-with-dependencies.jar',
  'jacocoagent.jar',
}
for _, java_test_jar in ipairs(java_test_bundles) do
  local fname = vim.fn.fnamemodify(java_test_jar, ':t')
  if not vim.tbl_contains(excluded, fname) then
    table.insert(bundles, java_test_jar)
  end
end

-- Extend jars for spring boot lsp configuration
vim.list_extend(bundles, require('spring_boot').java_extensions())

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. home .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar',
    '-jar',
    vim.fn.glob(home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration',
    home .. '/.local/share/nvim/mason/packages/jdtls/config_mac',
    '-data',
    workspace_dir,
  },
  --  on_attach = require('user.lsp.handlers').on_attach,
  --  capabilities = require('user.lsp.handlers').capabilities,
  root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },

  settings = {
    java = {
      signatureHelp = { enabled = true },
      extendedClientCapabilities = extendedClientCapabilities,
      maven = {
        downloadSources = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = 'all', -- literals, all, none
        },
      },
      format = {
        enabled = false,
      },
    },
  },
  init_options = {
    bundles = bundles,
  },
}
require('jdtls').start_or_attach(config)

vim.keymap.set('n', '<leader>co', "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = 'Organize Imports' })
vim.keymap.set('n', '<leader>crv', "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = 'Extract Variable' })
vim.keymap.set('n', '<leader>ct', "<Cmd>lua require('jdtls').test_class()<CR>", { desc = 'Test class' })
vim.keymap.set('n', '<leader>cn', "<Cmd>lua require('jdtls').test_nearest_method()<CR>", { desc = 'Test nearest method' })
vim.keymap.set('v', '<leader>crv', "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", { desc = 'Extract Variable' })
vim.keymap.set('n', '<leader>crc', "<Cmd>lua require('jdtls').extract_constant()<CR>", { desc = 'Extract Constant' })
vim.keymap.set('v', '<leader>crc', "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", { desc = 'Extract Constant' })
vim.keymap.set('v', '<leader>crm', "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", { desc = 'Extract Method' })
