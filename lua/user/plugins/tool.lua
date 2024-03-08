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

tool["lilydjwg/fcitx.vim"] = {
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

tool["noearc/jieba.nvim"] = {
	lazy = true,
	ft = { "markdown", "tex" },
	dependencies = { "noearc/jieba-lua" },
}
return tool
