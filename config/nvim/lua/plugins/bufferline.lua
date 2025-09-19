return {
  -- This is your plugin spec
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          -- This is where you add your options
          always_show_bufferline = true,
        },
      })
    end,
  },
}
