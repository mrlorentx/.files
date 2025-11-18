return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false, -- Never set this value to "*"! Never!
  build = 'make',
  opts = {
    provider = 'copilot',
    providers = {
      llmproxy = {
        __inherited_from = 'openai',
        endpoint = 'https://llmproxy.a2d.tv/v1',
        api_key_name = 'LLM_PROXY_API_KEY',
        model = 'gpt-4.1',
      },

      morph = {
        model = 'auto',
      },

      copilot = {
        endpoint = 'https://api.githubcopilot.com',
        model = 'claude-4.5-sonnet-preview',
        proxy = nil, -- [protocol://]host[:port] Use this proxy
        allow_insecure = false, -- Allow insecure server connections
        timeout = 30000, -- Timeout in milliseconds
      },
    },
    behaviour = {
      auto_suggestions = false,
      enable_fastapply = true,
      enable_cursor_planning_mode = true,
      auto_suggestions_respect_ignore = true,
      enable_claude_text_editor_tool_mode = true,
      use_cwd_as_project_root = true,
    },
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'echasnovski/mini.pick', -- for file_selector provider mini.pick
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'ibhagwan/fzf-lua', -- for file_selector provider fzf
    -- 'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
  },
}
