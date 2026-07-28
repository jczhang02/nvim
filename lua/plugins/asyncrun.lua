return {
	{
		"skywind3000/asyncrun.vim",
		cmd = { "AsyncRun", "AsyncStop" },
		init = function()
			vim.g.asyncrun_open = 8
			vim.g.asyncrun_bell = 1
		end,
		keys = {
			{ "<leader>ar", ":AsyncRun ", desc = "AsyncRun (prompt)" },
		},
	},
}
