--- Snippets for posts of the Lemma blog theme (see `lua/lemma`): environments, figures, equations.

local ls = require("luasnip")
local fmta = require("luasnip.extras.fmt").fmta
local make_condition = require("luasnip.extras.conditions").make_condition
local line_begin = require("luasnip.extras.conditions.expand").line_begin

local s = ls.snippet
local i = ls.insert_node

local in_post = make_condition(function()
	return require("lemma").root() ~= nil
end)
local before_text = make_condition(function(line_to_cursor)
	return line_to_cursor:match("^%a*$") ~= nil
end)
local opts = { condition = in_post * line_begin, show_condition = in_post * before_text }

--- `:::theorem[Title]{#thm:id}`; an empty title leaves no parentheses.
local function environment(trig, name, prefix)
	return s(
		{ trig = trig, name = name, dscr = "Insert a " .. name .. " environment." },
		fmta(":::" .. name .. "[<>]{#" .. prefix .. ":<>}\n<>\n:::", { i(1), i(2), i(0) }),
		opts
	)
end

local snippets = {
	environment("thm", "theorem", "thm"),
	environment("lem", "lemma", "lem"),
	environment("prop", "proposition", "prop"),
	environment("cor", "corollary", "cor"),
	environment("def", "definition", "def"),
	environment("ex", "example", "ex"),
	environment("rem", "remark", "rem"),
	s({ trig = "proof", name = "proof", dscr = "Insert a proof." }, fmta(":::proof\n<>\n:::", { i(0) }), opts),
	s(
		{ trig = "fig", name = "figure", dscr = "Insert a numbered figure." },
		fmta(":::figure{#fig:<>}\n![<>](./<>)\n\n<>\n:::", { i(1), i(2), i(3), i(0) }),
		opts
	),
	s(
		{ trig = "tab", name = "table", dscr = "Insert a numbered table." },
		fmta(":::table{#tab:<>}\n| <> |\n|--|\n\n<>\n:::", { i(1), i(2), i(0) }),
		opts
	),
	s(
		{ trig = "eq", name = "equation", dscr = "Insert a numbered equation." },
		fmta("$$\n\\begin{equation}\n  <>\n  \\label{eq:<>}\n\\end{equation}\n$$", { i(1), i(2) }),
		opts
	),
	s(
		{ trig = "tikzcd", name = "tikzcd", dscr = "Insert a commutative diagram." },
		fmta("```tikzcd\n<>\n```", { i(0) }),
		opts
	),
	s({ trig = "tikz", name = "tikz", dscr = "Insert a TikZ picture." }, fmta("```tikz\n<>\n```", { i(0) }), opts),
}

return snippets
