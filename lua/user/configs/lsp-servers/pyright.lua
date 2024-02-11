return {
	cmd = { "delance-langserver", "--stdio" },
	-- cmd = { "/usr/bin/pyright-langserver", "--stdio" },
	-- filetypes = { "python" },
	settings = {
		python = {
			analysis = {
				autoImportCompletions = true,
				autoSearchPaths = true,
				diagnosticMode = "workspace", -- openFilesOnly, workspace
				typeCheckingMode = "basic", -- off, basic, strict
				useLibraryCodeForTypes = true,
				-- stubPath = vim.fn.stdpath("data") .. "/site/lazy/python-type-stubs",
				inlayHints = {
					functionReturnTypes = true,
					pytestParameters = true,
					variableTypes = true,
					callArgumentNames = true,
				},
			},
		},
	},
	single_file_support = true,
}
