-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Built-in markdown rendering: conceal markup + fold by heading depth.
-- Avoids vim.treesitter.foldexpr() which crashes on 0.12.x via _fold.lua.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "n"
    vim.opt_local.foldmethod = "expr"
    -- Fold by heading: line starting with '#' starts a new fold one level deep.
    vim.opt_local.foldexpr =
      "getline(v:lnum)=~'^#'?'>'..len(matchstr(getline(v:lnum),'^#*')):getline(v:lnum-1)=~'^#'?'<1':1"
    vim.opt_local.foldtext = "getline(v:foldstart)"
  end,
})
