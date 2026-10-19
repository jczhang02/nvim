return {
	{
		"hotoo/pangu.vim",
		ft = { "markdown", "text", "tex" },
		init = function()
			-- Keep ASCII punctuation; this rule would also turn `[...]` holding CJK text into 【...】,
			-- which breaks Markdown links and `:::theorem[标题]` lines.
			vim.g.pangu_rule_fullwidth_punctuation = 0
		end,
	},
}
