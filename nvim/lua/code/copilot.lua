return {
  'zbirenbaum/copilot.lua',
  config = function()
    local copilot = require 'copilot'
    copilot.setup {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = false, -- disable copilot for markdown files
      },
    }
  end,
}
