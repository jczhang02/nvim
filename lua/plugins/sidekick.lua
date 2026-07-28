return {
	{
		"folke/sidekick.nvim",
		cmd = { "Sidekick" },
		keys = {
			{
				"<leader>ii",
				function()
					require("sidekick.cli").toggle({ name = "pi" })
				end,
				desc = "Start/attach Pi",
			},
			{
				"<leader>is",
				function()
					require("sidekick.cli").select({ filter = { installed = true } })
				end,
				desc = "Select AI CLI/session",
			},
			{
				"<leader>if",
				function()
					require("sidekick.cli").send({ msg = "{file}" })
				end,
				desc = "Send file",
			},
			{
				"<leader>iv",
				function()
					require("sidekick.cli").send({ msg = "{selection}" })
				end,
				mode = "x",
				desc = "Send selection",
			},
			{
				"<leader>it",
				function()
					require("sidekick.cli").send({ msg = "{this}" })
				end,
				mode = { "n", "x" },
				desc = "Send current context",
			},
			{
				"<leader>ip",
				function()
					require("sidekick.cli").prompt()
				end,
				mode = { "n", "x" },
				desc = "Select prompt",
			},
			{
				"<leader>id",
				function()
					require("sidekick.cli").close()
				end,
				desc = "Detach AI CLI",
			},
		},
		opts = {
			nes = { enabled = false },
			cli = {
				watch = true,
				picker = "snacks",
				mux = {
					enabled = true,
					backend = "tmux",
					create = "split",
					split = {
						vertical = true,
						size = 0.5,
					},
				},
			},
			copilot = {
				status = { enabled = false },
			},
		},
	},
}
