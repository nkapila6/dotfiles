-- init.lua
-- 13.04.2026 08:13 PM GMT+4.00
-- Nikhil Kapila

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- vim ui2
require("vim._core.ui2").enable({
  enable = true,
})

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

local function insert_header()
  local filename = vim.fn.expand("%:t")
  if filename == "" then
    filename = "Untitled"
  end

  local datetime = os.date("%d.%m.%Y %I:%M %p GMT+4.00")
  local name = "Nikhil Kapila"

  -- Get comment string, ensuring we handle the empty case
  local cs = vim.bo.commentstring
  local comment = (cs and cs:find("%%s")) and cs:gsub("%%s", ""):gsub("%s+", "") or "#"

  local lines = {
    comment .. " " .. filename,
    comment .. " " .. datetime,
    comment .. " " .. name,
    "",
  }

  -- Insert at the very top of the file
  vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
  -- Move cursor to line 5 (after the 4 header lines)
  pcall(vim.api.nvim_win_set_cursor, 0, { 5, 0 })
end

-- Create the Manual Command: :Header
vim.api.nvim_create_user_command("Header", insert_header, { desc = "Insert custom file header" })
