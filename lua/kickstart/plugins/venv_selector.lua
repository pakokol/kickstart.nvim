return {
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
    },
    ft = 'python', -- Load when opening Python files
    keys = { { ',v', '<cmd>VenvSelect<cr>' } }, -- Open picker on keymap
    opts = {
      options = {
        on_venv_activate_callback = function()
          local venv_python = require('venv-selector').get_active_venv()
          if venv_python then
            require('dap-python').resolve_python = function()
              return venv_python .. (vim.fn.has 'win32' == 1 and '/Scripts/python.exe' or '/bin/python')
            end
          end
        end,
      },
      search = {}, -- custom search definitions
    },
  },
}
