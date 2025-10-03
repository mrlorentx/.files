return {
  vim.keymap.set('n', '<leader>tt', function()
    require('telescope.builtin').grep_string {
      prompt_title = 'Incomplete Tasks',
      search = '^\\s*- \\[ \\]', -- also match blank spaces at the beginning
      search_dirs = { '~/vaults/' }, -- Restrict search to the current working directory
      use_regex = true, -- Enable regex for the search term
      initial_mode = 'normal', -- Start in normal mode
      layout_config = {
        preview_width = 0.5, -- Adjust preview width
      },
      additional_args = function()
        return { '--no-ignore' } -- Include files ignored by .gitignore
      end,
    }
  end, { desc = 'Search for incomplete [t]asks' }),
  vim.keymap.set('n', '<leader>tf', function()
    require('telescope.builtin').grep_string {
      prompt_title = 'Followup Tasks',
      search = '^\\s*- \\[>\\]', -- also match blank spaces at the beginning
      search_dirs = { '~/vaults/' }, -- Restrict search to the current working directory
      use_regex = true, -- Enable regex for the search term
      initial_mode = 'normal', -- Start in normal mode
      layout_config = {
        preview_width = 0.5, -- Adjust preview width
      },
      additional_args = function()
        return { '--no-ignore' } -- Include files ignored by .gitignore
      end,
    }
  end, { desc = 'Search for [f]ollowup tasks' }),
}
