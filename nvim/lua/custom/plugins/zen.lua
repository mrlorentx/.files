return {
  'folke/zen-mode.nvim',
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  config = function()
    -- Create which-key mappings for common commands.obsi
    local wk = require 'which-key'

    wk.add {
      {
        '<leader>zt',
        function()
          require('zen-mode').toggle {
            window = {
              width = 0.65, -- width will be 85% of the editor width
            },
            tmux = { enabled = true },
          }
        end,
        desc = 'Toggle Zen mode',
      },
    }
  end,
}
