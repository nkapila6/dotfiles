-- colours follow the active tuios look inside tuios, monokai-nightasty everywhere else
return {
  {
    "nkapila6/tuios-look-sync.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "nvim-mini/mini.base16" },
    opts = { fallback = "monokai-nightasty" },
  },

  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tuios" },
  },
}
