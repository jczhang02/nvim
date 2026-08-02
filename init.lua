vim.loader.enable()

-- mise recommends shims for editors launched outside an interactive shell.
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

vim.g.mapleader = " "
vim.g.maplocalleader = ","
require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
