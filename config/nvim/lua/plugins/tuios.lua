-- colours follow the active tuios look inside tuios, rose-pine everywhere else
return {
  {
    "nkapila6/tuios-look-sync.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "nvim-mini/mini.base16" },
    opts = { fallback = "rose-pine" },
  },

  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tuios" },
  },
}
