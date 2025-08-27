local picker_name = 'telescope.nvim'

return {
  {
    'lukas-reineke/headlines.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
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
    'obsidian-nvim/obsidian.nvim',
    ft = 'markdown',
    event = {
      'BufReadPre ' .. vim.fn.resolve(vim.fn.expand '~/Obsidian/notes') .. '/*',
      'BufNewFile ' .. vim.fn.resolve(vim.fn.expand '~/Obsidian/notes') .. '/*',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
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
          '<leader>ow',
          function()
            local Note = require 'obsidian.note'
            ---@type obsidian.Client
            local client = require('obsidian').get_client()
            assert(client)

            local picker = client:picker()
            if not picker then
              client.log.err 'No picker configured'
              return
            end

            ---@param dt number
            ---@return obsidian.Path
            local function weekly_note_path(dt)
              return client.dir / os.date('notes/weekly/week-of-%Y-%m-%d.md', dt)
            end

            ---@param dt number
            ---@return string
            local function weekly_alias(dt)
              local alias = os.date('Week of %A %B %d, %Y', dt)
              assert(type(alias) == 'string')
              return alias
            end

            local day_of_week = os.date '%A'
            assert(type(day_of_week) == 'string')

            ---@type integer
            local offset_start
            if day_of_week == 'Sunday' then
              offset_start = 1
            elseif day_of_week == 'Monday' then
              offset_start = 0
            elseif day_of_week == 'Tuesday' then
              offset_start = -1
            elseif day_of_week == 'Wednesday' then
              offset_start = -2
            elseif day_of_week == 'Thursday' then
              offset_start = -3
            elseif day_of_week == 'Friday' then
              offset_start = -4
            elseif day_of_week == 'Saturday' then
              offset_start = 2
            end
            assert(offset_start)

            local current_week_dt = os.time() + (offset_start * 3600 * 24)
            ---@type obsidian.PickerEntry
            local weeklies = {}
            for week_offset = 1, -2, -1 do
              local week_dt = current_week_dt + (week_offset * 3600 * 24 * 7)
              local week_alias = weekly_alias(week_dt)
              local week_display = week_alias
              local path = weekly_note_path(week_dt)

              if week_offset == 0 then
                week_display = week_display .. ' @current'
              elseif week_offset == 1 then
                week_display = week_display .. ' @next'
              elseif week_offset == -1 then
                week_display = week_display .. ' @last'
              end

              if not path:is_file() then
                week_display = week_display .. ' ➡️ create'
              end

              weeklies[#weeklies + 1] = {
                value = week_dt,
                display = week_display,
                ordinal = week_display,
                filename = tostring(path),
              }
            end

            picker:pick(weeklies, {
              prompt_title = 'Weeklies',
              callback = function(dt)
                local path = weekly_note_path(dt)
                ---@type obsidian.Note
                local note
                if path:is_file() then
                  note = Note.from_file(path)
                else
                  note = client:create_note {
                    template = 'weekly.md',
                    id = path.name,
                    dir = path:parent(),
                    title = weekly_alias(dt),
                    tags = { 'weekly-notes' },
                  }
                end
                client:open_note(note)
              end,
            })
          end,
          desc = 'Weeklies',
        },
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
      ui = { enable = false },
      workspaces = {
        { name = 'work', path = '~/vaults/work' },
      },
      daily_notes = {
        default_tags = { 'daily-notes' },
        workays_only = true,
        template = 'dailies.md',
      },
      notes_subdir = 'notes',
      templates = {
        folder = '~/vaults/templates',
        date_format = '%Y-%m-%d',
        time_format = '%H:%M',
      },
      ---@param url string
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart { 'open', url }
      end,
    },
  },
}
