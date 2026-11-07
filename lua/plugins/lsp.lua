local border_style = require("config.settings").border_style

return {
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
		build = ":MasonUpdate",
		opts = { PATH = "skip" },
		keys = {
			{ "<leader>cm", "<cmd>Mason<CR>", desc = "Mason UI" },
			{ "<leader>cM", "<cmd>MasonUpdate<CR>", desc = "Mason update all" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", priority = 100 },
			{
				"ray-x/lsp_signature.nvim",
				opts = {
					bind = true,
					hint_enable = false,
					handler_opts = { border = border_style },
				},
			},
		},
		config = function()
			require("neoconf").setup()

			local has_blink, blink = pcall(require, "blink.cmp")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			if has_blink then
				capabilities = blink.get_lsp_capabilities(capabilities)
			end

			vim.lsp.config("*", { capabilities = capabilities })

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						workspace = { checkThirdParty = false }, -- lazydev.nvim fills in the library
						telemetry = { enable = false },
						diagnostics = { globals = { "vim", "Snacks" } },
						completion = { callSnippet = "Replace" },
						hint = { enable = true },
					},
				},
			})

			vim.lsp.config("ruff", {
				init_options = { settings = { logLevel = "error" } },
			})

			vim.lsp.config("clangd", {
				cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
			})

			vim.lsp.config("gopls", {
				settings = {
					gopls = {
						gofumpt = true,
						usePlaceholders = true,
						staticcheck = true,
						analyses = { unusedparams = true },
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			})

			vim.lsp.config("pyright", {
				cmd = { "delance-langserver", "--stdio" },
				settings = {
					pyright = {
						disableOrganizeImports = true, -- ruff handles imports
						disableTaggedHints = false,
					},
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							typeCheckingMode = "standard",
							useLibraryCodeForTypes = true,
							diagnosticSeverityOverrides = {
								deprecateTypingAliases = false,
							},
							inlayHints = {
								callArgumentNames = "partial",
								functionReturnTypes = true,
								pytestParameters = true,
								variableTypes = true,
							},
						},
					},
				},
				capabilities = vim.tbl_deep_extend("force", capabilities, {
					textDocument = {
						publishDiagnostics = { tagSupport = { valueSet = { 2 } } },
						hover = { contentFormat = { "plaintext" }, dynamicRegistration = true },
					},
				}),
			})

			-- vimtex compiles; texlab only needs to find the latexmk output (aux_dir/out_dir = build).
			vim.lsp.config("texlab", {
				settings = {
					texlab = {
						build = { auxDirectory = "build", logDirectory = "build", pdfDirectory = "build" },
					},
				},
			})

			vim.lsp.enable(require("config.settings").lsp_servers)

			vim.diagnostic.config({
				virtual_lines = false,
				virtual_text = false,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = { border = border_style, source = "if_many" },
			})

			-- LspAttach: keymaps + inlay hints
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local buf = ev.buf
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					local map = function(lhs, rhs, desc, mode)
						vim.keymap.set(mode or "n", lhs, rhs, { buffer = buf, silent = true, desc = desc })
					end
					-- ltex only checks prose. It needs code actions (dictionary, rules) and nothing else,
					-- and must not replace buffer maps such as the Lemma `gd` in markdown posts.
					if client and client.name == "ltex_plus" then
						map("ga", vim.lsp.buf.code_action, "Code action", { "n", "v" })
						map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "v" })
						return
					end
					-- vimtex owns <leader>li, <leader>lr and <leader>lv in TeX buffers.
					local vimtex_buf = vim.tbl_contains({ "tex", "plaintex", "bib" }, vim.bo[buf].filetype)
					map("gd", vim.lsp.buf.definition, "Go to definition")
					map("gD", function()
						Snacks.picker.lsp_definitions()
					end, "Pick definitions")
					map("gi", function()
						Snacks.picker.lsp_implementations()
					end, "Pick implementations")
					map("gm", vim.lsp.buf.implementation, "Go to implementation")
					map("gy", function()
						Snacks.picker.lsp_type_definitions()
					end, "Pick type definitions")
					map("gh", function()
						Snacks.picker.lsp_references()
					end, "Pick references")
					map("ga", vim.lsp.buf.code_action, "Code action", { "n", "v" })
					map("gs", vim.lsp.buf.signature_help, "Signature help")
					map("go", "<cmd>Trouble symbols toggle win.position=right<CR>", "Toggle outline")
					map("gto", function()
						Snacks.picker.lsp_symbols()
					end, "Toggle outline (picker)")
					map("gci", vim.lsp.buf.incoming_calls, "Incoming calls")
					map("gco", vim.lsp.buf.outgoing_calls, "Outgoing calls")
					map("<C-k>", vim.lsp.buf.signature_help, "Signature help", "i")
					map("<leader>rn", vim.lsp.buf.rename, "Rename")
					map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "v" })
					if not vimtex_buf then
						map("<leader>li", "<cmd>LspInfo<CR>", "LSP info")
						map("<leader>lr", "<cmd>LspRestart<CR>", "LSP restart")
						map("<leader>lv", function()
							local ok, tid = pcall(require, "tiny-inline-diagnostic")
							if ok then
								tid.toggle()
							end
						end, "Toggle inline diagnostics")
					end
					map("<leader>lx", function()
						vim.diagnostic.open_float()
					end, "Line diagnostics")
					map("<leader>ld", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", "Document diagnostics")
					map("<leader>lh", function()
						local b = vim.api.nvim_get_current_buf()
						local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = b })
						vim.lsp.inlay_hint.enable(not enabled, { bufnr = b })
					end, "Toggle inlay hints")
					map("<leader>lpd", function()
						Snacks.picker.lsp_definitions()
					end, "Pick definitions")
					map("<leader>lpr", function()
						Snacks.picker.lsp_references()
					end, "Pick references")
					map("<leader>lpi", function()
						Snacks.picker.lsp_implementations()
					end, "Pick implementations")
					map("<leader>lpt", function()
						Snacks.picker.lsp_type_definitions()
					end, "Pick type definitions")

					if client then
						if require("config.settings").server_formatting_block_list[client.name] then
							client.server_capabilities.documentFormattingProvider = false
							client.server_capabilities.documentRangeFormattingProvider = false
						end
						if
							client.server_capabilities.inlayHintProvider and require("config.settings").lsp_inlayhints
						then
							vim.lsp.inlay_hint.enable(true, { bufnr = buf })
						end
					end
				end,
			})
		end,
	},
}
