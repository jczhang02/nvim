--- blink.cmp source for Lemma posts: labels in `\ref{}` and `\eqref{}`, BibTeX keys in `\cite{}`.

local lemma = require("lemma")

local kinds = {
	zh = { section = "节", equation = "式" },
	en = { section = "Section", equation = "Equation" },
}

--- @module 'blink.cmp'
--- @class blink.cmp.Source
local Source = {}

function Source.new()
	return setmetatable({}, { __index = Source })
end

function Source.enabled()
	return vim.bo.filetype == "markdown" and lemma.root() ~= nil
end

function Source.get_trigger_characters()
	return { "{", "," }
end

---@param doc lemma.Doc
---@param label lemma.Label
---@return string
local function describe(doc, label)
	local name = lemma.labels[doc.lang][label.kind] or kinds[doc.lang][label.kind] or label.kind
	local text = name .. (label.number and " " .. label.number or "")
	return label.title and text .. " · " .. label.title or text
end

---@param buf integer
---@param label lemma.Label
---@return string
local function preview(buf, label)
	local lines = vim.api.nvim_buf_get_lines(buf, label.row, label.row + 8, false)
	return "```markdown\n" .. table.concat(lines, "\n") .. "\n```"
end

--- "Serre 1973", and the title and venue for the documentation window.
---@param entry lemma.Entry
---@return string, string
local function cite(entry)
	local short = vim.trim((entry.author or "") .. " " .. (entry.year or ""))
	local parts = { entry.title and "**" .. entry.title .. "**", entry.venue, short }
	local long = {} ---@type string[]
	for i = 1, 3 do
		if parts[i] and parts[i] ~= "" then
			long[#long + 1] = parts[i]
		end
	end
	return short, table.concat(long, "\n\n")
end

function Source.get_completions(_, ctx, callback)
	local col = ctx.cursor[2]
	local before = ctx.line:sub(1, col)
	local command, args = before:match("\\(%a+){([^{}]*)$")
	if not command then
		command, args = before:match("\\(cite)%b[]{([^{}]*)$")
	end
	local root = lemma.root(ctx.bufnr)
	if not root or (command ~= "ref" and command ~= "eqref" and command ~= "cite") then
		callback({ items = {}, is_incomplete_backward = false, is_incomplete_forward = false })
		return
	end

	local prefix = args:match("[^,%s]*$")
	local suffix = ctx.line:sub(col + 1):match("^[^,%s}]*")
	local range = {
		start = { line = ctx.cursor[1] - 1, character = col - #prefix },
		["end"] = { line = ctx.cursor[1] - 1, character = col + #suffix },
	}
	local kind = require("blink.cmp.types").CompletionItemKind
	local items = {} ---@type lsp.CompletionItem[]

	if command == "cite" then
		for key, entry in pairs(lemma.bibliography(root)) do
			local short, long = cite(entry)
			items[#items + 1] = {
				label = key,
				kind = kind.Reference,
				detail = short,
				documentation = { kind = "markdown", value = long },
				sortText = key,
				textEdit = { newText = key, range = range },
			}
		end
	else
		local doc = lemma.doc(ctx.bufnr)
		for id, label in pairs(doc.labels) do
			if (command == "eqref") == (label.kind == "equation") then
				items[#items + 1] = {
					label = id,
					kind = label.kind == "section" and kind.Module or kind.Reference,
					detail = describe(doc, label),
					documentation = { kind = "markdown", value = preview(ctx.bufnr, label) },
					sortText = ("%06d"):format(label.row),
					textEdit = { newText = id, range = range },
				}
			end
		end
	end
	callback({ items = items, is_incomplete_backward = false, is_incomplete_forward = false })
end

return Source
