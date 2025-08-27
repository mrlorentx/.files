return {
  'mistricky/codesnap.nvim',
  build = 'make',
  opts = {
    mac_window_bar = true,
    title = '',
    code_font_family = 'FiraCode Nerd Font',
    watermark_font_family = 'Pacifico',
    watermark = '',
    bg_theme = 'default',
    breadcrumbs_separator = '/',
    has_breadcrumbs = true,
    has_line_number = true,
    show_workspace = false,
    min_width = 0,
    bg_x_padding = 122,
    bg_y_padding = 82,
    save_path = os.getenv 'XDG_PICTURES_DIR' or (os.getenv 'HOME' .. '/Pictures'),
  },
  keys = {
    { '<leader>cc', '<cmd>CodeSnap<cr>', mode = 'x', desc = 'Save selected code snapshot into clipboard' },
    { '<leader>cs', '<cmd>CodeSnapHighlight<cr>', mode = 'x', desc = 'Save selected code into clipboard with highlight' },
  },
}
