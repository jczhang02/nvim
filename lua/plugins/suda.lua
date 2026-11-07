return {
	{
		"lambdalisue/suda.vim",
		-- smart_edit registers its autocmds when plugin/suda.vim loads, so load at startup.
		lazy = false,
		init = function()
			vim.g.suda_smart_edit = 1
		end,
	},
}
