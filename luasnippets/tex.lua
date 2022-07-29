--- self Latex snippets

local snips, autosnips = {}, {}

local tex = {}

tex.in_mathzone = function()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

tex.in_comment = function()
	return vim.fn["vimtex#syntax#in_comment"]() == 1
end

tex.in_text = function()
	return not tex.in_mathzone() and not tex.in_comment()
end

tex.in_align = function()
	return vim.fn["vimtex#env#is_inside"]("align")[1] ~= 0
end

snips = {
	s(
		{ trig = "it", name = "italic", dscr = "Insert italic text." },
		{ t("\\textit{"), i(1), t("}") },
		{ condition = tex.in_text, show_condition = tex.in_text }
	),
	s(
		{ trig = "em", name = "emphasize", dscr = "Insert emphasize text." },
		{ t("\\emph{"), i(1), t("}") },
		{ condition = tex.in_text, show_condition = tex.in_text }
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
	}, { condition = tex.in_mathzone }),
	s(
		{ trig = "bf", name = "bold", dscr = "Insert bold text." },
		{ t("\\textbf{"), i(1), t("}") },
		{ condition = tex.in_text, show_condition = tex.in_text }
	),
	s(
		{ trig = "bf", name = "bold", dscr = "Insert bold text." },
		{ t("\\mathbf{"), i(1), t("}") },
		{ condition = tex.in_mathzone, show_condition = tex.in_text }
	),
}

return snips, autosnips
