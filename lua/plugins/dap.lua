-- ~/.config/nvim-new/lua/plugins/dap.lua
return {
  {
    "mfussenegger/nvim-dap",
    cmd = { "DapToggleBreakpoint", "DapContinue", "DapStepOver", "DapStepInto", "DapStepOut", "DapTerminate" },
    keys = {
      { "<leader>dc", function() require("dap").continue() end,            desc = "Continue" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end,   desc = "Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional bp" },
      { "<leader>di", function() require("dap").step_into() end,           desc = "Step into" },
      { "<leader>do", function() require("dap").step_over() end,           desc = "Step over" },
      { "<leader>dO", function() require("dap").step_out() end,            desc = "Step out" },
      { "<leader>dt", function() require("dap").terminate() end,           desc = "Terminate" },
      { "<leader>dr", function() require("dap").repl.toggle() end,         desc = "REPL toggle" },
      { "<leader>du", function() require("dapui").toggle() end,            desc = "DAP UI toggle" },
      { "<leader>dC", function() require("dapui").close() end,             desc = "DAP UI close" },
    },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = "nvim-neotest/nvim-nio",
        config = function()
          local dapui = require("dapui")
          dapui.setup()
          local dap = require("dap")
          dap.listeners.before.attach.dapui_config            = function() dapui.open() end
          dap.listeners.before.launch.dapui_config            = function() dapui.open() end
          dap.listeners.before.event_terminated.dapui_config  = function() dapui.close() end
          dap.listeners.before.event_exited.dapui_config      = function() dapui.close() end
        end,
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason-org/mason.nvim",
        opts = {
          ensure_installed = require("config.settings").dap_deps,
          automatic_installation = true,
          handlers = {},
        },
      },
    },
  },
}
