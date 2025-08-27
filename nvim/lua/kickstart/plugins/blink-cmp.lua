---@module "lazy"
---@type LazySpec
return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '*',
  event = { 'InsertEnter', 'CmdlineEnter' },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = 'normal',
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 250,
        update_delay_ms = 50,
        treesitter_highlighting = true,
        window = { border = 'rounded' },
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
      menu = {
        border = 'rounded',
        draw = {
          columns = {
            { 'label', 'label_description', gap = 1 },
            { 'kind_icon', 'kind' },
          },
          treesitter = { 'lsp' },
        },
      },
    },

    -- My super-TAB configuration
    keymap = {
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      -- ['<Tab>'] = {
      --   function(cmp)
      --     return cmp.select_next()
      --   end,
      --   'snippet_forward',
      --   'fallback',
      -- },
      -- ['<S-Tab>'] = {
      --   function(cmp)
      --     return cmp.select_prev()
      --   end,
      --   'snippet_backward',
      --   'fallback',
      -- },
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-up>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-down>'] = { 'scroll_documentation_down', 'fallback' },
    },

    -- Experimental signature help support
    signature = {
      enabled = true,
      window = { border = 'rounded' },
    },

    sources = {
      default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          -- Make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
        lsp = {
          min_keyword_length = 2, -- Number of characters to trigger provider
          score_offset = 0, -- Boost/penalize the score of the items
        },
        path = {
          min_keyword_length = 0,
        },
        snippets = {
          min_keyword_length = 2,
        },
        buffer = {
          min_keyword_length = 4,
          max_items = 5,
        },
      },
    },
  },
}

-- return {
--   { -- Autocompletion
--     'saghen/blink.cmp',
--     event = 'VimEnter',
--     version = '1.*',
--     dependencies = {
--       -- Snippet Engine
--       {
--         'L3MON4D3/LuaSnip',
--         version = '2.*',
--         build = (function()
--           -- Build Step is needed for regex support in snippets.
--           -- This step is not supported in many windows environments.
--           -- Remove the below condition to re-enable on windows.
--           if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
--             return
--           end
--           return 'make install_jsregexp'
--         end)(),
--         dependencies = {
--           -- `friendly-snippets` contains a variety of premade snippets.
--           --    See the README about individual language/framework/plugin snippets:
--           --    https://github.com/rafamadriz/friendly-snippets
--           -- {
--           --   'rafamadriz/friendly-snippets',
--           --   config = function()
--           --     require('luasnip.loaders.from_vscode').lazy_load()
--           --   end,
--           -- },
--         },
--         opts = {},
--       },
--       'folke/lazydev.nvim',
--     },
--     --- @module 'blink.cmp'
--     --- @type blink.cmp.Config
--     opts = {
--       keymap = {
--         -- 'default' (recommended) for mappings similar to built-in completions
--         --   <c-y> to accept ([y]es) the completion.
--         --    This will auto-import if your LSP supports it.
--         --    This will expand snippets if the LSP sent a snippet.
--         -- 'super-tab' for tab to accept
--         -- 'enter' for enter to accept
--         -- 'none' for no mappings
--         --
--         -- For an understanding of why the 'default' preset is recommended,
--         -- you will need to read `:help ins-completion`
--         --
--         -- No, but seriously. Please read `:help ins-completion`, it is really good!
--         --
--         -- All presets have the following mappings:
--         -- <tab>/<s-tab>: move to right/left of your snippet expansion
--         -- <c-space>: Open menu or open docs if already open
--         -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
--         -- <c-e>: Hide menu
--         -- <c-k>: Toggle signature help
--         --
--         -- See :h blink-cmp-config-keymap for defining your own keymap
--         preset = 'default',
--
--         -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
--         --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
--       },
--
--       appearance = {
--         -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
--         -- Adjusts spacing to ensure icons are aligned
--         nerd_font_variant = 'mono',
--       },
--
--       completion = {
--         -- By default, you may press `<c-space>` to show the documentation.
--         -- Optionally, set `auto_show = true` to show the documentation after a delay.
--         documentation = { auto_show = false, auto_show_delay_ms = 500 },
--       },
--
--       sources = {
--         default = { 'lsp', 'path', 'snippets', 'lazydev' },
--         providers = {
--           lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
--         },
--       },
--
--       snippets = { preset = 'luasnip' },
--
--       -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
--       -- which automatically downloads a prebuilt binary when enabled.
--       --
--       -- By default, we use the Lua implementation instead, but you may enable
--       -- the rust implementation via `'prefer_rust_with_warning'`
--       --
--       -- See :h blink-cmp-config-fuzzy for more information
--       fuzzy = { implementation = 'lua' },
--
--       -- Shows a signature help window while you type arguments for a function
--       signature = { enabled = true },
--     },
--   },
-- }
-- -- vim: ts=2 sts=2 sw=2 et
