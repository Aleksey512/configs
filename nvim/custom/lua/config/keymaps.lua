-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local map = vim.keymap.set
map("n", ";", ":", { desc = "CMD enter command mode" })
-- Закрыть Neovim
map("n", "<C-Q>", ":qa<CR>", { desc = "Quit Neovim" })
map("i", "jj", "<ESC>")
