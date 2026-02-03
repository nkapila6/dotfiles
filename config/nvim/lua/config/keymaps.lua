-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--- Search notes by filename

--- obsidian
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Search Obsidian Notes" })

-- Search text inside notes
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<cr>", { desc = "Search Inside Obsidian" })

-- Jump to your "Today" note
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToday<cr>", { desc = "Obsidian Today" })
