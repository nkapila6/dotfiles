-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- vim.cmd([[colorscheme monokai-pro]])
vim.opt.wrap = true
vim.cmd("colorscheme gruvbox")

-- snacks scroll
vim.g.snacks_scroll = false

vim.diagnostic.config({
  virtual_text = {
    severity = {
      max = vim.diagnostic.severity.WARN,
    },
    current_line = true,
  },
  virtual_lines = {
    severity = {
      min = vim.diagnostic.severity.ERROR,
    },
    current_line = true,
  },
})
