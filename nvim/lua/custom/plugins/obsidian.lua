local picker_name = 'telescope.nvim'
-- local picker_name = "mini.pick"
-- local picker_name = "fzf-lua"

return {
  {
    'lukas-reineke/headlines.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    lazy = true,
    config = function()
      local bg = '#2B2B2B'

      vim.api.nvim_set_hl(0, 'Headline1', { fg = '#33ccff', bg = bg })
      vim.api.nvim_set_hl(0, 'Headline2', { fg = '#00bfff', bg = bg })
      vim.api.nvim_set_hl(0, 'Headline3', { fg = '#0099cc', bg = bg })
      vim.api.nvim_set_hl(0, 'CodeBlock', { bg = bg })
      vim.api.nvim_set_hl(0, 'Dash', { fg = '#D19A66', bold = true })

      require('headlines').setup {
        markdown = {
          headline_highlights = { 'Headline1', 'Headline2', 'Headline3' },
          bullet_highlights = { 'Headline1', 'Headline2', 'Headline3' },
          bullets = { '❯', '❯', '❯', '❯' },
          dash_string = '⎯',
          fat_headlines = false,
          query = vim.treesitter.query.parse(
            'markdown',
            [[
                (atx_heading [
                    (atx_h1_marker)
                    (atx_h2_marker)
                    (atx_h3_marker)
                    (atx_h4_marker)
                    (atx_h5_marker)
                    (atx_h6_marker)
                ] @headline)

                (thematic_break) @dash

                (fenced_code_block) @codeblock
            ]]
          ),
        },
      }
    end,
  },
  {
    'epwalsh/obsidian.nvim',
    lazy = true,
    ft = 'markdown',
    -- event = {
    --   "BufReadPre " .. vim.fn.resolve(vim.fn.expand "~/Obsidian/notes") .. "/*",
    --   "BufNewFile " .. vim.fn.resolve(vim.fn.expand "~/Obsidian/notes") .. "/*",
    -- },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-cmp',
      'headlines.nvim',
      picker_name,
    },
    config = function(_, opts)
      -- Setup obsidian.nvim
      require('obsidian').setup(opts)

      -- Create which-key mappings for common commands.obsi
      local wk = require 'which-key'

      wk.add {
        { '<leader>o', group = 'Obsidian' },
        { '<leader>oo', '<cmd>ObsidianOpen<cr>', desc = 'Open note' },
        { '<leader>od', '<cmd>ObsidianDailies -10 0<cr>', desc = 'Daily notes' },
        { '<leader>op', '<cmd>ObsidianPasteImg<cr>', desc = 'Paste image' },
        { '<leader>oq', '<cmd>ObsidianQuickSwitch<cr>', desc = 'Quick switch' },
        { '<leader>os', '<cmd>ObsidianSearch<cr>', desc = 'Search' },
        { '<leader>ot', '<cmd>ObsidianTags<cr>', desc = 'Tags' },
        { '<leader>ol', '<cmd>ObsidianLinks<cr>', desc = 'Links' },
        { '<leader>ob', '<cmd>ObsidianBacklinks<cr>', desc = 'Backlinks' },
        { '<leader>om', '<cmd>ObsidianTemplate<cr>', desc = 'Template' },
        { '<leader>on', '<cmd>ObsidianQuickSwitch nav<cr>', desc = 'Nav' },
        { '<leader>or', '<cmd>ObsidianRename<cr>', desc = 'Rename' },
        { '<leader>oc', '<cmd>ObsidianTOC<cr>', desc = 'Contents (TOC)' },
        {
          mode = { 'v' },
          -- { "<leader>o", group = "Obsidian" },
          {
            '<leader>oe',
            function()
              local title = vim.fn.input { prompt = 'Enter title (optional): ' }
              vim.cmd('ObsidianExtractNote ' .. title)
            end,
            desc = 'Extract text into new note',
          },
          {
            '<leader>ol',
            function()
              vim.cmd 'ObsidianLink'
            end,
            desc = 'Link text to an existing note',
          },
          {
            '<leader>on',
            function()
              vim.cmd 'ObsidianLinkNew'
            end,
            desc = 'Link text to a new note',
          },
          {
            '<leader>ot',
            function()
              vim.cmd 'ObsidianTags'
            end,
            desc = 'Tags',
          },
        },
      }
    end,
    opts = {
      workspaces = {
        { name = 'personal', path = '~/vaults/personal' },
        { name = 'work', path = '~/vaults/work' },
      },
      daily_notes = {
        default_tags = { 'daily-notes', 'tv4' },
        template = 'dailies.md',
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      templates = {
        folder = 'templates',
        date_format = '%Y-%m-%d',
        time_format = '%H:%M',
      },
    },
  },
}
