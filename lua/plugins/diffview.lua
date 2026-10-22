return {
	{
		"dlyongemallo/diffview-plus.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview open" },
			{ "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Diffview close" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "File history" },
		},
		opts = {
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
