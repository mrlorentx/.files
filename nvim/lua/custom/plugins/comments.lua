return {
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        lazy = true,
        opts = {
          enable_autocmd = false,
        },
      },
    },
    opts = {
      ---Add a space b/w comment and the line
      padding = true,
      ---Whether the cursor should stay at its position
      sticky = true,

      ---Line which should be ignored while comment/uncomment
      ---Example: Use '^$' to ignore empty lines
      ignore = nil,
      toggler = {
        -- line-comment keymap
        line = 'gcc',

        --  Make sense to be related to your opleader.block
        block = 'gbc',
      },
      -- LHS of operator-pending mapping in NORMAL + VISUAL mode
      opleader = {
        -- line-comment keymap
        line = 'gc',
        -- block-comment keymap
        block = 'gb',
      },
      -- extra mapping
      -- Includes `gco`, `gcO`, `gcA`
      extra = {
        ---Add comment on the line above
        above = 'gcO',
        ---Add comment on the line below
        below = 'gco',
        ---Add comment at the end of line
        eol = 'gcA',
      },

      -- Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
      mappings = {

        -- operator-pending mapping
        -- Includes:
        --  `gcc`               -> line-comment  the current line
        --  `gcb`               -> block-comment the current line
        --  `gc[count]{motion}` -> line-comment  the region contained in {motion}
        --  `gb[count]{motion}` -> block-comment the region contained in {motion}
        basic = true,

        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
      },
    },
    config = function(_, opts)
      -- to skip backwards compatibility routines and speed up loading
      opts.pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
      vim.g.skip_ts_context_commentstring_module = true
      require('Comment').setup(opts)
    end,
  },
}
