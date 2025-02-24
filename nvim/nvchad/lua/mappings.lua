require("nvchad.mappings")

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>cx", function()
	require("nvchad.tabufline").closeAllBufs()
end, { desc = "Close All Buffers" })

map("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find Todo" })

-- Trouble

map("n", "<leader>qx", "<cmd>TroubleToggle<CR>", { desc = "Open Trouble" })
map("n", "<leader>qw", "<cmd>TroubleToggle workspace_diagnostics<CR>", { desc = "Open Workspace Trouble" })
map("n", "<leader>qd", "<cmd>TroubleToggle document_diagnostics<CR>", { desc = "Open Document Trouble" })
map("n", "<leader>qq", "<cmd>TroubleToggle quickfix<CR>", { desc = "Open Quickfix" })
map("n", "<leader>ql", "<cmd>TroubleToggle loclist<CR>", { desc = "Open Location List" })
map("n", "<leader>qt", "<cmd>TodoTrouble<CR>", { desc = "Open Todo Trouble" })

-- Git
map("n", "<leader>gl", ":Flog<CR>", { desc = "Git Log" })
map("n", "<leader>gf", ":DiffviewFileHistory<CR>", { desc = "Git File History" })
map("n", "<leader>gc", ":DiffviewOpen HEAD~1<CR>", { desc = "Git Last Commit" })
map("n", "<leader>gt", ":DiffviewToggleFile<CR>", { desc = "Git File History" })

-- Terminal
map("n", "<C-]>", function()
	require("nvchad.term").toggle({ pos = "vsp", size = 0.4 })
end, { desc = "Toogle Terminal Vertical" })
map("n", "<C-\\>", function()
	require("nvchad.term").toggle({ pos = "sp", size = 0.4 })
end, { desc = "Toogle Terminal Horizontal" })
map("n", "<C-f>", function()
	require("nvchad.term").toggle({ pos = "float" })
end, { desc = "Toogle Terminal Float" })
map("t", "<C-]>", function()
	require("nvchad.term").toggle({ pos = "vsp" })
end, { desc = "Toogle Terminal Vertical" })
map("t", "<C-\\>", function()
	require("nvchad.term").toggle({ pos = "sp" })
end, { desc = "Toogle Terminal Horizontal" })
map("t", "<C-f>", function()
	require("nvchad.term").toggle({ pos = "float" })
end, { desc = "Toogle Terminal Float" })

-- Basic

map("i", "jj", "<ESC>")
map("n", "<C-q>", ":q<CR>", { desc = "Quit current file" })
map("i", "<C-q>", "<ESC>:q<CR>", { desc = "Quit current file from insert mode" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
