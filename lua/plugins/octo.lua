return {
	{
		"pwntester/octo.nvim",
		cmd = "Octo",
		dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim", "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>GG", "<cmd>Octo<CR>", desc = "Octo commands" },
			{ "<leader>Gp", "<cmd>Octo pr list<CR>", desc = "PR list" },
			{ "<leader>Gi", "<cmd>Octo issue list<CR>", desc = "Issue list" },
			{ "<leader>Gn", "<cmd>Octo notification list<CR>", desc = "Notifications" },
			{ "<leader>Gr", "<cmd>Octo review<CR>", desc = "Review PR of current branch" },
			{ "<leader>Gc", "<cmd>Octo pr create<CR>", desc = "Create PR from current branch" },
			{
				"<leader>Gs",
				function()
					require("octo.utils").create_base_search_command({ include_current_repo = true })
				end,
				desc = "Search GitHub",
			},
		},
		init = function()
			-- Octo buffers are markdown; this makes the generic FileType autocmd start treesitter on them.
			vim.treesitter.language.register("markdown", "octo")
		end,
		opts = {
			picker = "snacks",
			enable_builtin = true, -- bare :Octo opens a picker of all commands
			default_remote = { "upstream", "origin" },
			-- Right side of a review diff is the working tree when the PR branch is checked out,
			-- so LSP works there. Octo asks before checking out if the branch is not current.
			use_local_fs = true,
			timeout = 10000,
			ui = {
				use_signcolumn = false,
				use_statuscolumn = true,
				fold_checks = true,
			},
			reviews = {
				auto_show_threads = true,
				focus = "right",
				show_virtual_text = true,
			},
			file_panel = { size = 12, icons = true },
			issues = { order_by = { field = "UPDATED_AT", direction = "DESC" } },
			pull_requests = { order_by = { field = "UPDATED_AT", direction = "DESC" } },
		},
		config = function(_, opts)
			require("octo").setup(opts)
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("OctoBuffer", { clear = true }),
				pattern = "octo",
				callback = function(args)
					vim.opt_local.wrap = true
					vim.opt_local.linebreak = true
					-- Built-in omnifunc completion for @user and #issue
					vim.keymap.set("i", "@", "@<C-x><C-o>", { buffer = args.buf, silent = true })
					vim.keymap.set("i", "#", "#<C-x><C-o>", { buffer = args.buf, silent = true })
				end,
			})
		end,
	},
}
