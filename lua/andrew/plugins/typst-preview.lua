return {
  'chomosuke/typst-preview.nvim',
  lazy = false, -- or ft = 'typst'
  version = '1.*',
  build = function() require('typst-preview').update() end,
  opts = {
    -- Following code is optional and only needed if you want to configure the plugin
    -- debug = true,
    open_cmd = nil, -- custom command to open the output link provided with %s
    -- This will be passed to `vim.system`:
    -- https://neovim.io/doc/user/lua.html#vim.system()
    invert_colors = 'never',
    follow_cursor = true,
    dependencies_bin = {
      ['typst-preview'] = nil,
      ['websocat'] = nil,
    },
    -- This function will be called to determine the root of the typst project
    get_root = function(path_of_main_file)
      return vim.fn.fnamemodify(path_of_main_file, ':p:h')
    end,
    -- This function will be called to determine the main file of the typst
    -- project.
    get_main_file = function(path_of_buffer)
      return path_of_buffer
    end,
  },
}
