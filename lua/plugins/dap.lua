return {
	{
		"mfussenegger/nvim-dap",
		cmd = {
			"DapToggleBreakpoint",
			"DapContinue",
			"DapStepOver",
			"DapStepInto",
			"DapStepOut",
			"DapTerminate",
			"DapViewOpen",
			"DapViewClose",
			"DapViewHover",
			"DapViewToggle",
			"DapViewVirtualTextEnable",
			"DapViewVirtualTextDisable",
			"DapViewVirtualTextToggle",
			"DapViewWatch",
			"DapViewJump",
			"DapViewShow",
			"DapViewNavigate",
		},
		keys = {
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Condition: "))
				end,
				desc = "Conditional bp",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step into",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "Step over",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "Step out",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "REPL toggle",
			},
			{ "<leader>du", "<cmd>DapViewToggle<CR>", desc = "DAP view toggle" },
			{ "<leader>dC", "<cmd>DapViewClose!<CR>", desc = "DAP view close" },
			{ "<leader>dh", "<cmd>DapViewHover<CR>", desc = "DAP hover" },
			{
				"<leader>dh",
				function()
					local expr = require("dap-view.util.exprs").get_current_expr()
					require("dap-view").hover(expr)
				end,
				mode = "v",
				desc = "DAP hover selection",
			},
			{ "<leader>dw", "<cmd>DapViewWatch<CR>", desc = "DAP watch" },
			{ "<leader>dw", ":DapViewWatch<CR>", mode = "v", desc = "DAP watch selection" },
			{ "<leader>dv", "<cmd>DapViewVirtualTextToggle<CR>", desc = "DAP virtual text" },
			-- Legacy F-key bindings
			{
				"<F6>",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Continue",
			},
			{
				"<F7>",
				function()
					require("dap").terminate()
				end,
				desc = "Debug: Stop",
			},
			{
				"<F8>",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Debug: Toggle breakpoint",
			},
			{
				"<F9>",
				function()
					require("dap").step_into()
				end,
				desc = "Debug: Step into",
			},
			{
				"<F10>",
				function()
					require("dap").step_out()
				end,
				desc = "Debug: Step out",
			},
			{
				"<F11>",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: Step over",
			},
			-- Legacy leader bindings
			{
				"<leader>dx",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to cursor",
			},
			{
				"<leader>dL",
				function()
					require("dap").run_last()
				end,
				desc = "Run last",
			},
			{
				"<leader>dR",
				function()
					require("dap").repl.open()
				end,
				desc = "Open REPL",
			},
		},
		dependencies = {
			{
				"igorlfs/nvim-dap-view",
				version = "1.*",
				opts = {
					auto_toggle = true,
					winbar = { controls = { enabled = true } },
					virtual_text = { enabled = true, position = "inline" },
				},
			},
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = "mason-org/mason.nvim",
				opts = {
					ensure_installed = require("config.settings").mason_dap_adapters,
					automatic_installation = false,
					handlers = {
						codelldb = function(config)
							config.adapters.executable.command = vim.fn.stdpath("data") .. "/mason/bin/codelldb"
							require("mason-nvim-dap").default_setup(config)
						end,
					},
				},
			},
		},
		config = function()
			local dap = require("dap")
			local adapters = require("mason-nvim-dap.mappings.adapters")
			local configurations = require("mason-nvim-dap.mappings.configurations")

			dap.adapters.delve = adapters.delve
			dap.configurations.go = configurations.delve
			dap.adapters.python = adapters.python
			dap.configurations.python = configurations.python
		end,
	},
}
