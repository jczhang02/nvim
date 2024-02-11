local tool = {}

tool["numToStr/Navigator.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	config = require("configs.tool.navigator"),
}

tool["skywind3000/asyncrun.vim"] = {
	lazy = true,
	cmd = { "AsyncRun", "Rungnome" },
	config = require("configs.tool.asyncrun"),
	dependencies = {
		"preservim/vimux",
		config = require("configs.tool.vimux"),
	},
}

tool["skywind3000/asynctasks.vim"] = {
	lazy = true,
	cmd = { "AsyncTask", "AsyncTaskList", "AsyncTaskEdit" },
	config = require("configs.tool.asynctask"),
}

tool["alohaia/fcitx.nvim"] = {
	lazy = true,
	event = "InsertEnter",
	config = require("configs.tool.fcitx"),
}

tool["anuvyklack/windows.nvim"] = {
	lazy = true,
	event = "WinNew",
	dependencies = {
		"anuvyklack/middleclass",
		"anuvyklack/animation.nvim",
	},
	config = require("configs.tool.windows"),
}

tool["amitds1997/remote-nvim.nvim"] = {
	lazy = true,
	cmd = { "RemoteStart", "RemoteStop", "RemoteInfo", "RemoteCleanup", "RemoteConfigDel", "RemoteLog" },
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim", -- For standard functions
		"MunifTanjim/nui.nvim", -- To build the plugin UI
		"nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
	},
	-- config = true,
	config = require("configs.tool.remote-nvim"),
}

tool["cathaysia/jieba_nvim"] = {
	lazy = true,
	ft = { "markdown", "tex" },
	config = function()
		local jieba = require("libjiebamove")

		function _G.move_chs(isRight)
			local row = vim.api.nvim_win_get_cursor(0)[1]
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local content = vim.api.nvim_buf_get_lines(0, row - 1, row, 0)[1]
			local new_pos = jieba.getPos(content, col, isRight)
			print(new_pos)
			vim.api.nvim_win_set_cursor(0, { row, new_pos })
		end

		vim.api.nvim_set_keymap("n", "e", ":lua move_chs(1)<CR>", {})
		vim.api.nvim_set_keymap("n", "b", ":lua move_chs(0)<CR>", {})
	end,
}

return tool
