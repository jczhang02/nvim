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

tool["nvim-neo-tree/neo-tree.nvim"] = {
	lazy = true,
	cmd = {
		"Neotree",
	},
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	config = require("configs.tool.neo-tree"),
}

tool["alohaia/fcitx.nvim"] = {
	lazy = true,
	event = "InsertEnter",
	config = require("configs.tool.fcitx"),
}

tool["robitx/gp.nvim"] = {
	lazy = true,
	cmd = {
		"GpChatNew",
		"GpChatPaste",
		"GpChatToggle",
		"GpChatRespond",
		"GpChatRespond",
		"GpChatDelete",
	},
	config = require("configs.tool.gp"),
}

tool["wintermute-cell/gitignore.nvim"] = {
	lazy = true,
	requires = {
		"nvim-telescope/telescope.nvim", -- optional: for multi-select
	},
	cmd = {
		"Gitignore",
	},
}

tool["askfiy/nvim-picgo"] = {
	lazy = true,
	ft = { "markdown" },
	config = require("configs.tool.picgo"),
}

tool["epwalsh/obsidian.nvim"] =  {
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {

      {
        name = "knowledge_system",
        path = "~/Documents/collection/ob_knowledge_system",
      },
    },

    -- see below for full list of options 👇
  },
}
return tool
