return {
  {
    dir = vim.fn.expand '~/Work/done-md.nvim', -- your local path
    name = 'done-md.nvim',
    main = 'donemd', -- => require("donemd")
    dev = true, -- local dev mode
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim', -- optional but recommended
    },
    cmd = { 'DoneMdAdd', 'DoneMdList', 'DoneMdDone', 'DoneMdEdit', 'DoneMdMove', 'DoneMdSearch' },
    keys = {
      {
        '<leader>ta',
        function()
          require('donemd').add()
        end,
        desc = 'TODO: Add',
      },
      {
        '<leader>ts',
        function()
          require('donemd').list()
        end,
        desc = 'TODO: List',
      },
    },
    opts = {
      global_path = vim.fn.stdpath 'data' .. '/todo/TODO.md',
      repo_path = '.nvim/TODO.md',
      hide_done_after_days = 7,
      use_telescope = true,
    },
  },
}
