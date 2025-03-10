-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local map = vim.keymap.set
map("n", ";", ":", { desc = "CMD enter command mode" })
-- Закрыть Neovim
map("n", "<C-Q>", ":qa<CR>", { desc = "Quit Neovim" })
map("i", "jj", "<ESC>")
map("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", { desc = "Toggle comment for current line" })
map("v", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Toggle comment for selected lines" })
