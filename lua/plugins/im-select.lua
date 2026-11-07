return {
	{
		"keaising/im-select.nvim",
		event = { "InsertEnter", "CmdlineEnter" },
		opts = {
			default_im_select = "keyboard-us",
			default_command = vim.fn.executable("fcitx5-remote") == 1 and "fcitx5-remote" or nil,
			-- Every default event also records the current input method for the next
			-- InsertEnter. FocusGained and CmdlineLeave recorded English over the Chinese
			-- saved by InsertLeave, so `:w` or a pane switch made the next insert English.
			-- Focus changes are handled by fcitx5 (per window) and tmux ime.sh (per pane).
			set_default_events = { "InsertLeave" },
			set_previous_events = { "InsertEnter" },
		},
		config = function(_, opts)
			require("im_select").setup(opts)
			if vim.fn.executable("fcitx5-remote") == 0 then
				return
			end
			-- Back to English after a : command or a / search typed in Chinese, without
			-- touching the state saved for the next insert. Skips input() and <C-r>=.
			vim.api.nvim_create_autocmd("CmdlineLeave", {
				group = vim.api.nvim_create_augroup("ImeCmdlineLeave", { clear = true }),
				callback = function()
					if not vim.list_contains({ ":", "/", "?" }, vim.fn.getcmdtype()) then
						return
					end
					-- 2 = active (Rime); switch only then, as every switch flashes the indicator.
					vim.system({ "fcitx5-remote" }, { text = true }, function(out)
						if vim.trim(out.stdout or "") == "2" then
							vim.system({ "fcitx5-remote", "-c" })
						end
					end)
				end,
			})
		end,
	},
}
