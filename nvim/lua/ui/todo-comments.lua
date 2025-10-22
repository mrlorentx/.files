-- Highlight todo, notes, etc in comments
return {
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VimEnter',
    opts = {},
    config = function()
      require('todo-comments').setup {
        signs = false,
      }
      local wk = require 'which-key'
      wk.add {
        { '<leader>tdl', '<cmd>TodoTelescope<cr>', desc = 'Todos' },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
