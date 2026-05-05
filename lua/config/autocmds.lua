local aug = vim.api.nvim_create_augroup
local au  = vim.api.nvim_create_autocmd

au("TextYankPost", {
  group = aug("HighlightYank", { clear = true }),
  callback = function()
    if vim.hl and vim.hl.on_yank then
      vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
    elseif vim.highlight and vim.highlight.on_yank then
      vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end
  end,
})

au({ "BufReadPost" }, {
  group = aug("LastPosition", { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

au("BufWritePre", {
  group = aug("AutoMkdir", { clear = true }),
  callback = function(args)
    local dir = vim.fn.fnamemodify(args.file, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, "p") end
  end,
})

au("FileType", {
  group = aug("CloseWithQ", { clear = true }),
  pattern = { "qf", "help", "man", "lspinfo", "checkhealth", "notify", "trouble", "DiffviewFiles" },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf, silent = true })
  end,
})

au("FileType", {
  group = aug("TSStart", { clear = true }),
  callback = function(args)
    local ok, lang = pcall(vim.treesitter.language.get_lang, vim.bo[args.buf].filetype)
    if ok and lang then
      pcall(vim.treesitter.language.add, lang)
      pcall(vim.treesitter.start, args.buf, lang)
    end
  end,
})
