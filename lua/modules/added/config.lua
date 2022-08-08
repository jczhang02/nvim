local config = {}

function config.vimtex()
	vim.g.vimtex_indent_bib_enabled = 0
	vim.g.vimtex_indent_enabled = 0

	vim.g.vimtex_complete_enabled = 0
	-- Disable imaps (using Ultisnips)
	vim.g.vimtex_imaps_enabled = 0
	-- Do not open pdfviwer on compile
	vim.g.vimtex_view_automatic = 0
	-- Disable conceal
	vim.g.vimtex_syntax_conceal = {
		accents = 0,
		cites = 0,
		fancy = 0,
		greek = 0,
		math_bounds = 0,
		math_delimiters = 0,
		math_fracs = 0,
		math_super_sub = 0,
		math_symbols = 0,
		sections = 0,
		styles = 0,
	}
	-- Disable quickfix auto open
	vim.g.vimtex_quickfix_ignore_mode = 0
	vim.cmd([[let g:vimtex_compiler_progname = 'nvr']])
	vim.cmd([[let g:vimtex_view_method = 'zathura']])
	-- PDF viewer settings
	vim.g.vimtex_view_general_viewer = "zathura"
	-- Do not auto open quickfix on compile erros
	vim.g.vimtex_quickfix_mode = 0
	-- Latex warnings to ignore
	vim.g.vimtex_quickfix_ignore_filters = {
		"Command terminated with space",
		"LaTeX Font Warning: Font shape",
		"Package caption Warning: The option",
		[[Underfull \\hbox (badness [0-9]*) in]],
		"Package enumitem Warning: Negative labelwidth",
		[[Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in]],
		[[Package caption Warning: Unused \\captionsetup]],
		"Package typearea Warning: Bad type area settings!",
		[[Package fancyhdr Warning: \\headheight is too small]],
		[[Underfull \\hbox (badness [0-9]*) in paragraph at lines]],
		"Package hyperref Warning: Token not allowed in a PDF string",
		[[Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in paragraph at lines]],
	}
	vim.g.vimtex_fold_enabled = 0
	vim.g.vimtex_fold_manual = 0
	vim.g.vimtex_fold_types = {
		cmd_addplot = {
			cmds = { "addplot[+3]?" },
		},
		cmd_multi = {
			cmds = {
				"%(re)?new%(command|environment)",
				"providecommand",
				"presetkeys",
				"Declare%(Multi|Auto)?CiteCommand",
				"Declare%(Index)?%(Field|List|Name)%(Format|Alias)",
			},
		},
		cmd_single = {
			cmds = { "hypersetup", "tikzset", "pgfplotstableread", "lstset" },
		},
		cmd_single_opt = {
			cmds = { "usepackage", "includepdf" },
		},
		comments = {
			enabled = 0,
		},
		env_options = vim.empty_dict(),
		envs = {
			blacklist = {},
			whitelist = { "figure", "frame", "table", "example", "answer" },
		},
		items = {
			enabled = 0,
		},
		markers = vim.empty_dict(),
		preamble = {
			enabled = 0,
		},
		sections = {
			parse_levels = 0,
			parts = { "appendix", "frontmatter", "mainmatter", "backmatter" },
			sections = {
				"%(add)?part",
				"%(chapter|addchap)",
				"%(section|section\\*)",
				"%(subsection|subsection\\*)",
				"%(subsubsection|subsubsection\\*)",
				"paragraph",
			},
		},
	}
end

function config.magma()
	vim.cmd([[nnoremap <silent><expr> <Leader>r  :MagmaEvaluateOperator<CR>]])
	vim.cmd([[nnoremap <silent>       <Leader>rr :MagmaEvaluateLine<CR>]])
	vim.cmd([[xnoremap <silent>       <Leader>r  :<C-u>MagmaEvaluateVisual<CR>]])
	vim.cmd([[nnoremap <silent>       <Leader>rc :MagmaReevaluateCell<CR>]])
	vim.cmd([[nnoremap <silent>       <Leader>rd :MagmaDelete<CR>]])
	vim.cmd([[nnoremap <silent>       <Leader>ro :MagmaShowOutput<CR>]])

	vim.g.magma_automatically_open_output = false
	vim.g.magma_show_mimetype_debug = true
	vim.g.magma_image_provider = "ueberzug"
end

function config.nvimr()
	vim.cmd([[ let R_path = '/opt/R/4.1.3/bin' ]])
end

function config.rosepine()
	require("rose-pine").setup({
		-- @usage 'main'|'moon'
		dark_variant = "moon",
		bold_vert_split = false,
		dim_nc_background = true,
		disable_background = false,
		disable_float_background = false,
		disable_italics = false,
		---@usage string hex value or named color from rosepinetheme.com/palette
		groups = {
			background = "base",
			panel = "surface",
			border = "highlight_med",
			comment = "muted",
			link = "iris",
			punctuation = "subtle",

			error = "love",
			hint = "iris",
			info = "foam",
			warn = "gold",

			headings = {
				h1 = "iris",
				h2 = "foam",
				h3 = "rose",
				h4 = "gold",
				h5 = "pine",
				h6 = "foam",
			},
		},
		-- Change specific vim highlight groups
		highlight_groups = {
			ColorColumn = { bg = "rose" },
		},
	})
end

function config.tasks()
	require("toggletasks").setup({
		debug = false,
		silent = false, -- don't show "info" messages
		short_paths = true, -- display relative paths when possible
		-- Paths (without extension) to task configuration files (relative to scanned directory)
		-- All supported extensions will be tested, e.g. '.toggletasks.json', '.toggletasks.yaml'
		search_paths = {
			"toggletasks",
			".toggletasks",
			".nvim/toggletasks",
		},
		-- Directories to consider when searching for available tasks for current window
		scan = {
			global_cwd = true, -- vim.fn.getcwd(-1, -1)
			tab_cwd = true, -- vim.fn.getcwd(-1, tab)
			win_cwd = true, -- vim.fn.getcwd(win)
			lsp_root = true, -- root_dir for first LSP available for the buffer
			dirs = {}, -- explicit list of directories to search
		},
		-- Language server priorities when selecting lsp_root (default is 0)
		lsp_priorities = {
			["null-ls"] = -10,
		},
		-- Default values for task configuration options (available options described later)
		defaults = {
			close_on_exit = false,
			hidden = true,
		},
		-- Configuration of telescope pickers
		telescope = {
			spawn = {
				open_single = true, -- auto-open terminal window when spawning a single task
				show_running = false, -- include already running tasks in picker candidates
				-- Replaces default select_* actions to spawn task (and change toggleterm
				-- direction for select horiz/vert/tab)
				mappings = {
					select_float = "<C-f>",
					spawn_smart = "<C-a>", -- all if no entries selected, else use multi-select
					spawn_all = "<M-a>", -- all visible entries
					spawn_selected = nil, -- entries selected via multi-select (default <tab>)
				},
			},
			-- Replaces default select_* actions to open task terminal (and change toggleterm
			-- direction for select horiz/vert/tab)
			select = {
				mappings = {
					select_float = "<C-f>",
					open_smart = "<C-a>",
					open_all = "<M-a>",
					open_selected = nil,
					kill_smart = "<C-q>",
					kill_all = "<M-q>",
					kill_selected = nil,
					respawn_smart = "<C-s>",
					respawn_all = "<M-s>",
					respawn_selected = nil,
				},
			},
		},
	})
end

-- function config.grammar()
-- 	require("grammar-guard").init()
-- 	require("lspconfig").grammar_guard.setup({
-- 		cmd = { "/home/jczhang/.local/share/nvim/mason/bin/ltex-ls" }, -- add this if you install ltex-ls yourself
-- 		settings = {
-- 			ltex = {
-- 				enabled = { "latex", "tex", "bib", "markdown" },
-- 				language = "en",
-- 				diagnosticSeverity = "information",
-- 				setenceCacheSize = 2000,
-- 				additionalRules = {
-- 					enablePickyRules = true,
-- 					motherTongue = "en",
-- 				},
-- 				trace = { server = "verbose" },
-- 				dictionary = {},
-- 				disabledRules = {},
-- 				hiddenFalsePositives = {},
-- 			},
-- 		},
-- 	})
-- end
--
return config
