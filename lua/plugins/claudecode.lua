return {
	{
		"coder/claudecode.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>ia", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add file to Claude" },
			{ "<leader>ic", "<cmd>ClaudeCodeSend<cr>", mode = "x", desc = "Send selection to Claude" },
			{ "<leader>iy", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
			{ "<leader>in", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny Claude diff" },
		},
		opts = {
			-- Sidekick starts Claude in a tmux split; this plugin only serves the IDE connection.
			terminal = { provider = "none" },
		},
	},
}
