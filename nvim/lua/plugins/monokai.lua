return {
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false, -- Colorschemes should be loaded on startup, so they are not lazy
    priority = 1000, -- Ensures the colorscheme is loaded before other plugins that depend on it
    config = function()
      require("monokai-pro").setup({
        filter = "pro", -- Choose your preferred Monokai Pro filter
        transparent_background = false,
        terminal_colors = true,
        devicons = true,
        styles = {
          comment = { italic = true },
          keyword = { italic = true },
        },
      })
    end,
  },
}
