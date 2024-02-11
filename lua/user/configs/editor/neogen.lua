return function()
	require("neogen").setup({
		languages = {
			python = {
				template = {
					annotation_convertion = "numpydoc",
				},
			},
		},
	})
end
