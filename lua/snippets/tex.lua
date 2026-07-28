--- Personal LaTeX snippets.

local ls = require("luasnip")
local ts_utils = require("luasnip-latex-snippets.util.ts_utils")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function in_math()
	return ts_utils.in_mathzone()
end

local function in_text()
	return ts_utils.in_text(true)
end

local snippets = {
	s(
		{ trig = "it", name = "italic", dscr = "Insert italic text." },
		{ t("\\textit{"), i(1), t("}") },
		{ condition = in_text, show_condition = in_text }
	),
	s(
		{ trig = "em", name = "emphasize", dscr = "Insert emphasized text." },
		{ t("\\emph{"), i(1), t("}") },
		{ condition = in_text, show_condition = in_text }
	),
}

local autosnippets = {
	s({
		trig = "([a-zA-Z])bf",
		name = "math bold",
		wordTrig = false,
		regTrig = true,
	}, {
		f(function(_, snippet)
			return "\\mathbf{" .. snippet.captures[1] .. "}"
		end, {}),
	}, { condition = in_math }),
	s(
		{ trig = "bf", name = "bold", dscr = "Insert bold text." },
		{ t("\\textbf{"), i(1), t("}") },
		{ condition = in_text, show_condition = in_text }
	),
	s(
		{ trig = "bf", name = "math bold", dscr = "Insert bold math." },
		{ t("\\mathbf{"), i(1), t("}") },
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = "vv", name = "v-th view", dscr = "Insert a view superscript." },
		{ t("^{(v)}") },
		{ condition = in_math, show_condition = in_math }
	),
}

return snippets, autosnippets
