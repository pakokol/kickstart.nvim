return {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  ft = { 'org' },
  config = function()
    -- Setup orgmode
    require('orgmode').setup {
      org_agenda_files = '~/orgfiles/**/*',
      org_default_notes_file = '~/orgfiles/refile.org',
      org_log_done = 'note', -- prompt for a note when a task is marked DONE
      org_capture_templates = {
        j = 'Journal',
        jd = {
          description = 'Dewesoft',
          template = '* %U\n%?',
          target = '~/orgfiles/journal/dewesoft.org',
          datetree = true,
        },
        j3 = {
          description = '3Qit',
          template = '* %U\n%?',
          target = '~/orgfiles/journal/3qit.org',
          datetree = true,
        },
        jp = {
          description = 'Side projects',
          template = '* %U\n%?',
          target = '~/orgfiles/journal/side-projects.org',
          datetree = true,
        },
        t = 'Task',
        td = {
          description = 'Dewesoft',
          template = '* TODO %?\n  SCHEDULED: %t',
          target = '~/orgfiles/tasks/dewesoft.org',
        },
        t3 = {
          description = '3Qit',
          template = '* TODO %?\n  SCHEDULED: %t',
          target = '~/orgfiles/tasks/3qit.org',
        },
        tp = {
          description = 'Side projects',
          template = '* TODO %?\n  SCHEDULED: %t',
          target = '~/orgfiles/tasks/side-projects.org',
        },
      },
    }

    -- Experimental LSP support
    vim.lsp.enable 'org'
  end,
}
