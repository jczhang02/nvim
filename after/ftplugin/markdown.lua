-- Posts of the Lemma blog theme: fold headings and `:::` environments, and jump from
-- `\ref{}`, `\eqref{}` and `\cite{}` to the label or BibTeX entry (CTRL-], :tag, gd).
local lemma = require("lemma")
if not lemma.root() then
	return
end

vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.require'lemma'.foldexpr()"
vim.bo.tagfunc = "v:lua.require'lemma'.tagfunc"
vim.keymap.set("n", "gd", function()
	return lemma.at_cursor() and "<C-]>" or "gd"
end, { buffer = true, expr = true, desc = "Go to label or citation" })

local undo = "setlocal foldmethod< foldexpr< tagfunc< | silent! nunmap <buffer> gd"
vim.b.undo_ftplugin = vim.b.undo_ftplugin and vim.b.undo_ftplugin .. " | " .. undo or undo
