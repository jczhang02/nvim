local function format()
	require("conform").format({ async = true, lsp_format = "fallback" })
end

return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{ "<leader>cf", format, mode = { "n", "v" }, desc = "Format buffer/range" },
			{ "<A-S-f>", format, mode = { "n", "v" }, desc = "Format buffer/range" },
			{
				"<A-f>",
				function()
					vim.b.disable_autoformat = not vim.b.disable_autoformat
					vim.notify("Buffer format on save: " .. tostring(not vim.b.disable_autoformat))
				end,
				desc = "Toggle format on save (buffer)",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_fix", "ruff_format" },
				go = { "goimports", "gofumpt" },
				rust = { "rustfmt" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				vue = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				tex = { "latexindent" },
				bib = { "bibtex-tidy" },
				xml = { "xmlformatter" },
			},
			format_on_save = function(bufnr)
				local settings = require("config.settings")
				if not settings.format_on_save or vim.b[bufnr].disable_autoformat then
					return
				end
				if settings.formatter_block_list[vim.bo[bufnr].filetype] then
					return
				end

				local filename = vim.api.nvim_buf_get_name(bufnr)
				for _, dir in ipairs(settings.format_disabled_dirs) do
					local disabled_dir = vim.fs.normalize(vim.fn.expand(dir))
					if vim.fs.relpath(disabled_dir, filename) then
						return
					end
				end

				return { timeout_ms = settings.format_timeout_ms, lsp_format = "fallback" }
			end,
			formatters = {
				latexindent = { prepend_args = { "-l", "-m" } },
				["bibtex-tidy"] = {
					command = "bibtex-tidy",
					args = {
						"$FILENAME",
						"--modify",
						"--curly",
						"--numeric",
						"--align=13",
						"--blank-lines",
						"--sort",
						"--duplicates",
						"--no-escape",
						"--sort-fields",
						"--remove-empty-fields",
						"--quiet",
					},
					stdin = false,
				},
			},
		},
	},
}
