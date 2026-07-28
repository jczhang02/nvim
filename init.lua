vim.loader.enable()

-- Keep CLI tooling consistent when Neovim is launched outside an interactive shell.
local mise = "/usr/bin/mise"
if vim.fn.executable(mise) == 1 then
	local mise_env_json = vim.fn.system({ mise, "env", "--json" })
	if vim.v.shell_error == 0 then
		local ok, mise_env = pcall(vim.json.decode, mise_env_json)
		if ok and type(mise_env) == "table" then
			for name, value in pairs(mise_env) do
				vim.env[name] = value
			end
		end
	end
end

vim.g.mapleader = " "
vim.g.maplocalleader = ","
require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
