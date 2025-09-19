return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    require("telescope").setup({})
    -- vim.keymap.set("n", "<space>fr", require("telescope.builtin").live_grep)
    -- vim.keymap.set("n", "<space>ff", require("telescope.builtin").find_files)
    -- vim.keymap.set("n", "<space>fc", function()
    --   require("telescope.builtin").find_files({
    --     cmd = vim.fn.stdpath("config"),
    --   })
    -- end)
  end,
}
