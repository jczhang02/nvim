local aug = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd
local border_style = require("config.settings").border_style

local function border_char(segment)
	return type(segment) == "table" and segment[1] or segment
end

local function has_rounded_corners(border)
	return type(border) == "table"
		and border_char(border[1]) == "╭"
		and border_char(border[3]) == "╮"
		and border_char(border[5]) == "╯"
		and border_char(border[7]) == "╰"
end

local function preferred_border(border)
	if border_style ~= "single" then
		return border_style
	end

	local square = vim.deepcopy(border)
	for index, corner in pairs({ [1] = "┌", [3] = "┐", [5] = "┘", [7] = "└" }) do
		if type(square[index]) == "table" then
			square[index][1] = corner
		else
			square[index] = corner
		end
	end
	return square
end

au("WinNew", {
	group = aug("SquareFloatBorders", { clear = true }),
	callback = function()
		-- Best-effort fallback for plugin-internal windows that hard-code rounded borders.
		vim.schedule(function()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local config = vim.api.nvim_win_get_config(win)
				if config.relative ~= "" and has_rounded_corners(config.border) then
					pcall(vim.api.nvim_win_set_config, win, { border = preferred_border(config.border) })
				end
			end
		end)
	end,
})

au("TextYankPost", {
	group = aug("HighlightYank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
	end,
})

au({ "BufReadPost" }, {
	group = aug("LastPosition", { clear = true }),
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local lcount = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

au({ "FocusGained", "BufEnter" }, {
	group = aug("CheckExternalChanges", { clear = true }),
	callback = function()
		vim.schedule(function()
			vim.cmd.checktime()
		end)
	end,
})

au("BufWritePre", {
	group = aug("AutoMkdir", { clear = true }),
	callback = function(args)
		local dir = vim.fn.fnamemodify(args.file, ":p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})

au("FileType", {
	group = aug("CloseWithQ", { clear = true }),
	pattern = { "qf", "help", "man", "lspinfo", "checkhealth", "notify", "trouble", "DiffviewFiles" },
	callback = function(args)
		vim.bo[args.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf, silent = true })
	end,
})

au("FileType", {
	group = aug("CJKWrap", { clear = true }),
	pattern = { "markdown", "text", "tex" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
		vim.opt_local.textwidth = 0
		vim.opt_local.formatoptions:remove("t")
		vim.opt_local.joinspaces = false
		vim.opt_local.spell = false
	end,
})

au("FileType", {
	group = aug("TSStart", { clear = true }),
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		-- vimtex owns highlight for LaTeX (math zones, conceals, package-aware)
		if ft == "tex" or ft == "latex" or ft == "plaintex" then
			return
		end
		local ok, lang = pcall(vim.treesitter.language.get_lang, ft)
		if ok and lang then
			pcall(vim.treesitter.language.add, lang)
			pcall(vim.treesitter.start, args.buf, lang)
		end
	end,
})
