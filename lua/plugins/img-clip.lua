return {
	{
		"HakonHarnes/img-clip.nvim",
		cmd = { "PasteImage", "ImgClipDebug", "ImgClipConfig" },
		keys = {
			{ "<leader>pi", "<cmd>PasteImage<CR>", desc = "Paste clipboard image" },
		},
		opts = {
			default = {
				dir_path = "figures",
				relative_to_current_file = false,
			},
			filetypes = {
				html = { template = '<img src="$FILE_PATH" alt="">' },
				markdown = {
					template = "![]($FILE_PATH)",
					url_encode_path = true,
					download_images = false,
				},
				tex = {
					relative_template_path = true,
					template = [[\includegraphics[width=\linewidth]{$FILE_PATH}]],
					formats = { "jpeg", "jpg", "png", "pdf" },
				},
			},
		},
	},
}
