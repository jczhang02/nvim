--- Support for posts of the Lemma blog theme (a repository with `lemma.config.mjs`):
--- theorem-like `:::` environments, `\label`/`\ref`, and `\cite` keys.
---
--- The scan below mirrors `plugins/remark-theorems.mjs` of the theme, so the numbers shown in
--- the editor are the numbers on the page.

local M = {}

--- BibTeX files, relative to the repository root; mirrors `bibliography.files` in `lemma.config.mjs`.
M.bib_files = { "src/bibliography.bib" }

--- Names of the environments, per language; mirrors `theorems.labels` in `lemma.config.mjs`.
M.labels = {
	zh = {
		theorem = "定理",
		lemma = "引理",
		proposition = "命题",
		corollary = "推论",
		definition = "定义",
		example = "例",
		remark = "注",
		proof = "证明",
		figure = "图",
		table = "表",
	},
	en = {
		theorem = "Theorem",
		lemma = "Lemma",
		proposition = "Proposition",
		corollary = "Corollary",
		definition = "Definition",
		example = "Example",
		remark = "Remark",
		proof = "Proof",
		figure = "Figure",
		table = "Table",
	},
}

---@class lemma.Label
---@field id string
---@field kind string `section`, `equation`, or an environment name
---@field row integer 0-based
---@field number? string
---@field title? string

---@class lemma.Env
---@field kind string
---@field open integer 0-based row of the `:::name` line
---@field close? integer 0-based row of the closing `:::`
---@field colons integer
---@field title? string
---@field id? string
---@field number? string

---@class lemma.Doc
---@field tick integer
---@field lang "zh"|"en"
---@field labels table<string, lemma.Label>
---@field envs lemma.Env[]
---@field folds string[] fold level of each line, as 'foldexpr' returns it
---@field prose boolean[] whether each line (1-based) is prose: not frontmatter, code or display math

---@class lemma.Entry
---@field key string
---@field file string
---@field row integer 0-based
---@field author? string
---@field title? string
---@field year? string
---@field venue? string

local roots = {} ---@type table<integer, string|false>
local docs = {} ---@type table<integer, lemma.Doc>
local bibs = {} ---@type table<string, { mtime: integer, entries: table<string, lemma.Entry> }>

vim.api.nvim_create_autocmd({ "BufWipeout", "BufFilePost" }, {
	group = vim.api.nvim_create_augroup("Lemma", { clear = true }),
	callback = function(args)
		roots[args.buf] = nil
		docs[args.buf] = nil
	end,
})

---@param buf? integer
---@return integer
local function resolve(buf)
	if buf == nil or buf == 0 then
		return vim.api.nvim_get_current_buf()
	end
	return buf
end

--- Repository root, if the buffer is a post of a Lemma blog.
---@param buf? integer
---@return string?
function M.root(buf)
	buf = resolve(buf)
	if roots[buf] == nil then
		local root = vim.fs.root(buf, "lemma.config.mjs")
		local posts = root and vim.fs.joinpath(root, "src/content/posts")
		roots[buf] = posts and vim.fs.relpath(posts, vim.api.nvim_buf_get_name(buf)) and root or false
	end
	return roots[buf] or nil
end

---@param text string
---@return string
local function trim(text)
	return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

---@param buf integer
---@return lemma.Doc
local function scan(buf)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local lang = vim.api.nvim_buf_get_name(buf):match("[/\\]en%.md$") and "en" or "zh"
	local doc = { ---@type lemma.Doc
		tick = vim.api.nvim_buf_get_changedtick(buf),
		lang = lang,
		labels = {},
		envs = {},
		folds = {},
		prose = {},
	}

	local function label(id, kind, row, number, title)
		if id and not doc.labels[id] then
			doc.labels[id] = { id = id, kind = kind, row = row, number = number, title = title }
		end
	end

	local numbered = true
	local first = 1
	if lines[1] == "---" then
		for i = 2, #lines do
			if lines[i] == "---" then
				first = i + 1
				break
			end
			if lines[i]:match("^numbering:%s*false%s*$") then
				numbered = false
			end
		end
	end
	for i = 1, first - 1 do
		doc.folds[i] = "0"
		doc.prose[i] = false
	end

	local section, subsection, counter = 0, 0, 0
	local floats = { figure = 0, table = 0 }
	local level = 0 -- fold level of the current heading
	local stack = {} ---@type lemma.Env[]
	local fence ---@type string?
	local display = false -- inside a $$ block

	for i = first, #lines do
		local line = lines[i]
		local row = i - 1
		doc.folds[i] = "="
		doc.prose[i] = false
		if fence then
			if line:match("^%s*" .. fence:sub(1, 1):rep(#fence) .. "+%s*$") then
				fence = nil
			end
		elseif line:match("^%s*```") or line:match("^%s*~~~") then
			fence = line:match("^%s*([`~]+)")
		elseif display then
			display = not line:match("%$%$%s*$")
			for id in line:gmatch("\\label{([^}]+)}") do
				label(id, "equation", row)
			end
		elseif line:match("^%s*%$%$") then
			display = not line:match("^%s*%$%$.*%$%$%s*$")
			for id in line:gmatch("\\label{([^}]+)}") do
				label(id, "equation", row)
			end
		else
			doc.prose[i] = true
			local hashes, heading = line:match("^(##+)%s+(.*)$")
			local colons, name, rest = line:match("^(:::+)(%a[%w-]*)(.*)$")
			if hashes and #hashes <= 6 then
				local id = heading:match("\\label{([^}]+)}")
				local title = trim(heading:gsub("%s*\\label{[^}]*}", ""))
				local number
				if numbered and #hashes <= 3 then
					if #hashes == 2 then
						section, subsection, counter = section + 1, 0, 0
						number = tostring(section)
					else
						subsection = subsection + 1
						number = section .. "." .. subsection
					end
				end
				label(id, "section", row, number, title)
				level = #hashes - 1
				doc.folds[i] = ">" .. level
			elseif colons then
				local title = rest:match("^%b[]")
				local attrs = rest:match("^%b{}", title and #title + 1 or 1)
				local env = { kind = name, open = row, colons = #colons } ---@type lemma.Env
				env.title = title and title:sub(2, -2) ~= "" and title:sub(2, -2) or nil
				env.id = attrs and attrs:match("#([^%s}]+)")
				if floats[name] then
					floats[name] = floats[name] + 1
					env.number = tostring(floats[name])
				elseif name ~= "proof" and M.labels[lang][name] then
					counter = counter + 1
					env.number = (numbered and section > 0) and (section .. "." .. counter) or tostring(counter)
				end
				label(env.id, name, row, env.number, env.title)
				doc.envs[#doc.envs + 1] = env
				stack[#stack + 1] = env
				doc.folds[i] = ">" .. (level + #stack)
			else
				local closer = line:match("^(:::+)%s*$")
				local top = stack[#stack]
				if closer and top and #closer >= top.colons then
					top.close = row
					doc.folds[i] = "<" .. (level + #stack)
					stack[#stack] = nil
				end
			end
		end
	end
	return doc
end

--- The parsed buffer, rescanned when it changes.
---@param buf? integer
---@return lemma.Doc
function M.doc(buf)
	buf = resolve(buf)
	local doc = docs[buf]
	if not doc or doc.tick ~= vim.api.nvim_buf_get_changedtick(buf) then
		doc = scan(buf)
		docs[buf] = doc
	end
	return doc
end

--- Byte ranges of code spans and inline math in a line, where `\ref` and `\cite` are not prose.
---@param line string
---@return integer[][] 1-based, inclusive ranges
function M.literals(line)
	local ranges = {}
	local function inside(pos)
		for _, range in ipairs(ranges) do
			if pos >= range[1] and pos <= range[2] then
				return true
			end
		end
		return false
	end
	for s, _, e in line:gmatch("()(`+).-%2()") do
		ranges[#ranges + 1] = { s, e - 1 }
	end
	local pos = 1
	while true do
		local s, e = line:find("%$[^$]+%$", pos)
		if not s then
			break
		end
		if not inside(s) and line:sub(s - 1, s - 1) ~= "\\" then
			ranges[#ranges + 1] = { s, e }
		end
		pos = e + 1
	end
	return ranges
end

---@class lemma.Command
---@field name string `ref`, `eqref` or `cite`
---@field s integer 1-based byte position of the backslash
---@field e integer 1-based byte position of the closing brace
---@field keys { key: string, s: integer, e: integer }[]

--- Each `\ref{}`, `\eqref{}` and `\cite[...]{}` in a line of prose.
---@param line string
---@return lemma.Command[]
function M.commands(line)
	local literals = M.literals(line)
	local commands = {}
	for s, name, after in line:gmatch("()\\(%a+)()") do
		local quoted = false
		for _, range in ipairs(literals) do
			quoted = quoted or (s >= range[1] and s <= range[2])
		end
		if not quoted and (name == "ref" or name == "eqref" or name == "cite") then
			local note = name == "cite" and line:match("^%b[]", after)
			local brace = after + (note and #note or 0)
			local arg = line:match("^%b{}", brace)
			if arg then
				local command = { name = name, s = s, e = brace + #arg - 1, keys = {} }
				for ks, key, ke in arg:sub(2, -2):gmatch("()([^,%s]+)()") do
					command.keys[#command.keys + 1] = { key = key, s = brace + ks, e = brace + ke - 1 }
				end
				commands[#commands + 1] = command
			end
		end
	end
	return commands
end

--- The command and key under the cursor.
---@return lemma.Command?, string?
function M.at_cursor()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1
	for _, command in ipairs(M.commands(line)) do
		if col >= command.s and col <= command.e then
			for _, key in ipairs(command.keys) do
				if col <= key.e then
					return command, key.key
				end
			end
			local last = command.keys[#command.keys]
			return command, last and last.key
		end
	end
end

---@param value string
---@return string
local function clean(value)
	return trim(value:gsub("[{}]", ""):gsub("%s+", " "))
end

--- "Serre", "Gilbarg and Trudinger", "Figalli et al."
---@param authors string
---@return string
local function surnames(authors)
	local names = vim.split(authors, "%s+and%s+")
	local function surname(name)
		return name:match("^([^,]+),") or name:match("(%S+)$") or name
	end
	if #names > 2 then
		return surname(names[1]) .. " et al."
	elseif #names == 2 then
		return surname(names[1]) .. " and " .. surname(names[2])
	end
	return surname(names[1])
end

---@param path string
---@return table<string, lemma.Entry>
local function parse_bib(path)
	local entries = {}
	local file = io.open(path, "r")
	if not file then
		return entries
	end
	local text = file:read("*a")
	file:close()

	local pos, row, counted = 1, 0, 1
	while true do
		local s, _, kind, key = text:find("@(%a+)%s*{%s*([^,%s]+)%s*,", pos)
		if not s then
			break
		end
		local _, newlines = text:sub(counted, s):gsub("\n", "")
		row, counted = row + newlines, s + 1
		local brace = text:find("{", s, true)
		local body = text:match("^%b{}", brace) or text:sub(brace)
		pos = brace + #body
		kind = kind:lower()
		if kind ~= "comment" and kind ~= "string" and kind ~= "preamble" then
			local fields = {}
			local at = 2
			while true do
				local _, e, field = body:find("([%a_%-]+)%s*=%s*", at)
				if not e then
					break
				end
				local value = body:match("^%b{}", e + 1) or body:match('^%b""', e + 1)
				local raw = value or body:match("^[^,}]*", e + 1)
				fields[field:lower()] = clean(value and value:sub(2, -2) or raw)
				at = e + 1 + #raw
			end
			entries[key] = {
				key = key,
				file = path,
				row = row,
				author = fields.author and surnames(fields.author),
				title = fields.title,
				year = fields.year or (fields.date and fields.date:match("^%d+")),
				venue = fields.journal or fields.booktitle or fields.publisher,
			}
		end
	end
	return entries
end

--- Entries of the blog's BibTeX files; the first file wins for a repeated key, as on the site.
---@param root string
---@return table<string, lemma.Entry>
function M.bibliography(root)
	local entries = {}
	for i = #M.bib_files, 1, -1 do
		local path = vim.fs.joinpath(root, M.bib_files[i])
		local stat = vim.uv.fs_stat(path)
		if stat then
			local cached = bibs[path]
			if not cached or cached.mtime ~= stat.mtime.sec then
				cached = { mtime = stat.mtime.sec, entries = parse_bib(path) }
				bibs[path] = cached
			end
			entries = vim.tbl_extend("force", entries, cached.entries)
		end
	end
	return entries
end

--- 'foldexpr': headings, and `:::` environments inside them.
---@return string
function M.foldexpr()
	return M.doc().folds[vim.v.lnum] or "="
end

--- 'tagfunc': labels of the post and keys of the bibliography, so that CTRL-] and :tag reach them.
---@param pattern string
---@param flags string
---@return table[]|userdata vim.NIL to fall back to tags files
function M.tagfunc(pattern, flags)
	local root = M.root()
	if not root then
		return vim.NIL
	end
	local name = pattern
	if flags:find("c") then
		local command, key = M.at_cursor()
		if not command or not key then
			return vim.NIL
		end
		name = key
	end
	local label = M.doc().labels[name]
	if label then
		return {
			{ name = name, filename = vim.api.nvim_buf_get_name(0), cmd = tostring(label.row + 1), kind = label.kind },
		}
	end
	local entry = M.bibliography(root)[name]
	if entry then
		return { { name = name, filename = entry.file, cmd = tostring(entry.row + 1), kind = "bib" } }
	end
	return flags:find("c") and {} or vim.NIL
end

return M
