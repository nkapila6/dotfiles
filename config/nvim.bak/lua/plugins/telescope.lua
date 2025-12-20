-- return {
--   "nvim-telescope/telescope.nvim",
--   tag = "0.1.8",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
--   },
--   config = function()
--     require("telescope").setup({
--       defaults = {
--         layout_stategy = "vertical",
--         layout_config = {
--           -- center = { width = 0.5 },
--         },
--       },
--     })
--   end,
-- }

return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      layout_strategy = "vertical",
      layout_config = {
        center = {
          height = 0.80, -- Adjust the height of the prompt/results window
          width = 0.90, -- Adjust the width of the prompt/results window
          -- preview_cutoff = 120, -- The preview window is disabled if the terminal width is less than 120
          -- mirror = true, -- Flips the location of the results and preview
        },
      },
      borderchars = { "█", " ", "▀", "█", "█", " ", " ", "▀" },
      theme = "monokai-pro",
    },
  },
}
