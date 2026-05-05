--- self Latex snippets

local M = {}
local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local events = require("luasnip.util.events")
local r = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

M.pipe = function(fns)
	return function(...)
		for _, fn in ipairs(fns) do
			if not fn(...) then
				return false
			end
		end

		return true
	end
end

M.no_backslash = function(line_to_cursor, matched_trigger)
	return not line_to_cursor:find("\\%a+$", -#line_to_cursor)
end

local ts_utils = require("luasnip-latex-snippets.util.ts_utils")
M.is_math = function(treesitter)
	if treesitter then
		return ts_utils.in_mathzone()
	end

	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

M.not_math = function(treesitter)
	if treesitter then
		return ts_utils.in_text(true)
	end

	return not M.is_math()
end

M.comment = function()
	return vim.fn["vimtex#syntax#in_comment"]() == 1
end

M.env = function(name)
	local x, y = unpack(vim.fn["vimtex#env#is_inside"](name))
	return x ~= "0" and y ~= "0"
end

M.with_priority = function(snip, priority)
	snip.priority = priority
	return snip
end

M.with_opts = function(fn, opts)
	return function()
		return fn(opts)
	end
end

local snips, autosnips = {}, {}

snips = {
	s(
		{ trig = "it", name = "italic", dscr = "Insert italic text." },
		{ t("\\textit{"), i(1), t("}") },
		{ condition = M.in_text, show_condition = M.in_text }
	),
	s(
		{ trig = "em", name = "emphasize", dscr = "Insert emphasize text." },
		{ t("\\emph{"), i(1), t("}") },
		{ condition = M.in_text, show_condition = M.in_text }
	),
}

autosnips = {
	s({
		trig = "([a-zA-Z])bf",
		name = "math bold",
		wordTrig = false,
		regTrig = true,
	}, {
		f(function(_, snip)
			return "\\mathbf{" .. snip.captures[1] .. "}"
		end, {}),
	}, { condition = M.in_mathzone }),
	s(
		{ trig = "bf", name = "bold", dscr = "Insert bold text." },
		{ t("\\textbf{"), i(1), t("}") },
		{ condition = M.in_text, show_condition = M.in_text }
	),
	s(
		{ trig = "bf", name = "bold", dscr = "Insert bold text." },
		{ t("\\mathbf{"), i(1), t("}") },
		{ condition = M.in_mathzone, show_condition = M.in_text }
	),

	s(
		{ trig = "vv", name = "v-th view", dscr = "Insert v-th view." },
		{ t("^{(v)}"), i(1), t("") },
		{ condition = M.in_text, show_condition = M.in_text }
	),
}

return snips, autosnips
