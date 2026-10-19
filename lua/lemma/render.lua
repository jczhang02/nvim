--- render-markdown.nvim handler for Lemma posts. Draws a `:::theorem[Title]{#thm:x}` line as
--- "定理 2.1 (Title)", its closing `:::` as a rule, and `\ref{thm:x}` as "2.1", as on the page;
--- underlines labels and citation keys that the build would not find.

local lemma = require("lemma")

local M = {}

local function highlights()
	local groups = {
		LemmaEnv = { link = "@markup.environment" },
		LemmaEnvTitle = {},
		LemmaEnvRule = { link = "NonText" },
		LemmaLabel = { link = "Comment" },
		LemmaRef = { link = "@markup.link" },
		LemmaUnresolved = { link = "DiagnosticUnderlineWarn" },
	}
	for name, hl in pairs(groups) do
		hl.default = true
		vim.api.nvim_set_hl(0, name, hl)
	end
end

highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("LemmaHighlights", { clear = true }),
	callback = highlights,
})

---@param marks render.md.Mark[]
---@param row integer
---@param s integer 0-based
---@param e integer 0-based, exclusive
---@param hl string
local function highlight(marks, row, s, e, hl)
	marks[#marks + 1] = {
		modes = true,
		conceal = false,
		start_row = row,
		start_col = s,
		opts = { end_row = row, end_col = e, hl_group = hl },
	}
end

--- Hide a range and show `text` in its place, except on the cursor line.
---@param marks render.md.Mark[]
---@param row integer
---@param s integer 0-based
---@param e integer 0-based, exclusive
---@param text render.md.mark.Line
local function replace(marks, row, s, e, text)
	marks[#marks + 1] = {
		conceal = true,
		start_row = row,
		start_col = s,
		opts = { end_row = row, end_col = e, conceal = "", virt_text = text, virt_text_pos = "inline" },
	}
end

--- A title with `\ref{}` in it, as the page shows it.
---@param doc lemma.Doc
---@param title string
---@return string
local function resolve(doc, title)
	return (
		title:gsub("\\ref{([^}]+)}", function(id)
			local label = doc.labels[id]
			return label and (label.number or label.title)
		end)
	)
end

---@param marks render.md.Mark[]
---@param doc lemma.Doc
---@param env lemma.Env
---@param lines string[]
---@param first integer row of lines[1]
local function environment(marks, doc, env, lines, first)
	local names = lemma.labels[doc.lang]
	local open = lines[env.open - first + 1]
	local name = #open:match("^:+%a[%w-]*")
	if not names[env.kind] then
		highlight(marks, env.open, 0, name, "LemmaUnresolved")
		return
	end
	highlight(marks, env.open, 0, name, "LemmaEnv")
	local attrs = open:find("{", name + 1, true)
	if env.id and attrs then
		highlight(marks, env.open, attrs - 1, #open, "LemmaLabel")
	end

	local title = env.title and resolve(doc, env.title)
	local head = names[env.kind] .. (env.number and " " .. env.number or "")
	if env.kind == "proof" and title then
		head = title
	end
	local text = { { head, "LemmaEnv" } } ---@type render.md.mark.Line
	if title and env.kind ~= "proof" then
		text[#text + 1] = { " (" .. title .. ")", "LemmaEnvTitle" }
	end
	if env.id then
		text[#text + 1] = { "  #" .. env.id, "LemmaLabel" }
	end
	replace(marks, env.open, 0, #open, text)

	local close = env.close and lines[env.close - first + 1]
	if close then
		highlight(marks, env.close, 0, #close, "LemmaEnv")
		local width = math.min(vim.api.nvim_strwidth(head), 24)
		local rule = env.kind == "proof" and { "∎", "LemmaEnv" } or { ("─"):rep(width), "LemmaEnvRule" }
		replace(marks, env.close, 0, #close, { rule })
	end
end

---@param marks render.md.Mark[]
---@param doc lemma.Doc
---@param bib table<string, lemma.Entry>
---@param line string
---@param row integer
local function references(marks, doc, bib, line, row)
	for _, command in ipairs(lemma.commands(line)) do
		for _, key in ipairs(command.keys) do
			local known = command.name == "cite" and bib[key.key] or doc.labels[key.key]
			if not known then
				highlight(marks, row, key.s - 1, key.e, "LemmaUnresolved")
			end
		end
		local label = command.name == "ref" and #command.keys == 1 and doc.labels[command.keys[1].key]
		local text = label and (label.number or label.title)
		if text then
			replace(marks, row, command.s - 1, command.e, { { text, "LemmaRef" } })
		end
	end
end

---@param ctx render.md.handler.Context
---@return render.md.Mark[]
function M.parse(ctx)
	local root = lemma.root(ctx.buf)
	if not root then
		return {}
	end
	local first, _, last = ctx.root:range()
	local lines = vim.api.nvim_buf_get_lines(ctx.buf, first, last + 1, false)
	local doc = lemma.doc(ctx.buf)
	local bib = lemma.bibliography(root)
	local marks = {} ---@type render.md.Mark[]
	for _, env in ipairs(doc.envs) do
		if env.open >= first and env.open <= last then
			environment(marks, doc, env, lines, first)
		end
	end
	for i, line in ipairs(lines) do
		if doc.prose[first + i] then
			references(marks, doc, bib, line, first + i - 1)
		end
	end
	return marks
end

return M
