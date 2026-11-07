--- Settings and client-side commands for ltex_plus (LanguageTool grammar checks).
---
--- ltex code actions ("Add to dictionary", "Disable rule", "Hide false positive") run
--- commands that the client must handle. The handlers below append the entries to
--- files under stdpath("data")/ltex and send the new settings to the server. Nvim
--- writes those files, so they stay out of the config repository.

local M = {}

local language = "en-US"
local dir = vim.fn.stdpath("data") .. "/ltex"

---@param kind "dictionary"|"disabledRules"|"hiddenFalsePositives"
---@param lang string
local function path(kind, lang)
	return ("%s/%s.%s.txt"):format(dir, kind, lang)
end

---@return string[]
local function read(kind)
	local items = {}
	local file = io.open(path(kind, language))
	if file then
		for line in file:lines() do
			if line ~= "" then
				items[#items + 1] = line
			end
		end
		file:close()
	end
	return items
end

function M.settings()
	-- Vim's spell (en_us, cjk) checks spelling. LanguageTool's speller flags Lemma syntax
	-- such as \eqref{} and :::theorem[], and its whitespace rule flags CJK text.
	local disabled = { "MORFOLOGIK_RULE_EN_US", "WHITESPACE_RULE" }
	return {
		ltex = {
			language = language,
			diagnosticSeverity = "information",
			dictionary = { [language] = read("dictionary") },
			disabledRules = { [language] = vim.list_extend(disabled, read("disabledRules")) },
			hiddenFalsePositives = { [language] = read("hiddenFalsePositives") },
		},
	}
end

---@param kind "dictionary"|"disabledRules"|"hiddenFalsePositives"
---@param key string field of the command argument that holds the entries per language
local function handler(kind, key)
	return function(command, ctx)
		vim.fn.mkdir(dir, "p")
		for lang, items in pairs(command.arguments[1][key] or {}) do
			local file = assert(io.open(path(kind, lang), "a"))
			for _, item in ipairs(items) do
				file:write(item, "\n")
			end
			file:close()
		end
		local client = vim.lsp.get_client_by_id(ctx.client_id)
		if client then
			client.settings = M.settings()
			client:notify("workspace/didChangeConfiguration", { settings = client.settings })
		end
	end
end

function M.register_commands()
	vim.lsp.commands["_ltex.addToDictionary"] = handler("dictionary", "words")
	vim.lsp.commands["_ltex.disableRules"] = handler("disabledRules", "ruleIds")
	vim.lsp.commands["_ltex.hideFalsePositives"] = handler("hiddenFalsePositives", "falsePositives")
end

return M
