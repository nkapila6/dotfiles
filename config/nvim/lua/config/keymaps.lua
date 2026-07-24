-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- restart
vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>", { desc = "Restart nvim (:restart)" })

-- terminal as buffer
vim.keymap.set("n", "<leader>tb", "<cmd>terminal<cr>", { desc = "Terminal (buffer)" })

-- esc terminal buffer
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
