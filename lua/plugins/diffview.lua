return {
	{
		"dlyongemallo/diffview-plus.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview open" },
			{ "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Diffview close" },
			{ "<leader>gf", "<cmd>DiffviewFileHistory<CR>", desc = "File history" },
			-- Branch review: what this branch changed since it left main (three dots), and per commit.
			{ "<leader>gm", "<cmd>DiffviewOpen main...HEAD<CR>", desc = "Diffview branch vs main" },
			{ "<leader>gM", "<cmd>DiffviewFileHistory --range=main..HEAD<CR>", desc = "Branch commits since main" },
		},
		opts = {
			-- q closes the whole view, not only the window it is pressed in.
			keymaps = {
				view = { { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" } } },
				file_panel = { { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" } } },
				file_history_panel = { { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" } } },
			},
			hooks = {
				diff_buf_win_enter = function(bufnr)
					-- Diffview loads git revisions outside the diff window, so the window-local
					-- options of the CJKWrap FileType autocmd land elsewhere. Re-apply them here.
					local ft = vim.bo[bufnr].filetype
					if ft == "markdown" or ft == "text" or ft == "tex" then
						vim.opt_local.wrap = true
						vim.opt_local.linebreak = true
						vim.opt_local.breakindent = true
					end
				end,
			},
		},
	},
}
