-- ~/.config/nvim/lua/plugins/lang/latex.lua
return {
  {
    "lervag/vimtex",
    ft = { "tex", "bib" },
    cmd = { "VimtexInverseSearch" },
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_view_forward_search_on_start = 1
      vim.g.vimtex_view_automatic = 1
      vim.g.vimtex_view_zathura_check_libsynctex = 0

      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = "build",
        out_dir = "build",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
          "-shell-escape",
        },
      }

      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_indent_enabled = 1
      vim.g.vimtex_syntax_enabled = 1
      vim.g.vimtex_imaps_enabled = 0
      vim.g.vimtex_complete_enabled = 1
      vim.g.vimtex_mappings_enabled = 1

      -- zathura uses filemonitor=signal; force reload via SIGHUP after every compile.
      -- (latexmk unlink+create cycle breaks zathura's GFileMonitor — inode changes.)
      local grp = vim.api.nvim_create_augroup("VimtexZathuraReload", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = grp,
        pattern = "VimtexEventCompileSuccess",
        callback = function()
          -- Only signal vimtex-spawned zathura (cmdline carries --synctex-forward).
          -- Filter by exact comm name to avoid matching the shell that runs pgrep.
          vim.fn.jobstart({
            "sh", "-c",
            "for pid in $(pgrep -x zathura); do "
            .. "grep -qa synctex-forward /proc/$pid/cmdline 2>/dev/null && kill -HUP $pid; "
            .. "done",
          }, { detach = true })
        end,
      })

      vim.g.vimtex_quickfix_ignore_filters = {
        "Underfull \\\\hbox",
        "Overfull \\\\hbox",
        "LaTeX Warning: .\\+ float specifier changed to",
        "LaTeX hooks Warning",
        "Package siunitx Warning: Detected the \"physics\" package:",
        "Package hyperref Warning: Token not allowed in a PDF string",
      }
    end,
    keys = {
      { "<leader>ll", "<cmd>VimtexCompile<CR>",       ft = { "tex", "bib" }, desc = "Vimtex: compile (toggle continuous)" },
      { "<leader>lL", "<cmd>VimtexCompileSS<CR>",     ft = { "tex", "bib" }, desc = "Vimtex: compile single-shot" },
      { "<leader>lv", "<cmd>VimtexView<CR>",          ft = { "tex", "bib" }, desc = "Vimtex: view PDF (forward search)" },
      { "<leader>lk", "<cmd>VimtexStop<CR>",          ft = { "tex", "bib" }, desc = "Vimtex: stop compile" },
      { "<leader>lK", "<cmd>VimtexStopAll<CR>",       ft = { "tex", "bib" }, desc = "Vimtex: stop all" },
      { "<leader>lc", "<cmd>VimtexClean<CR>",         ft = { "tex", "bib" }, desc = "Vimtex: clean aux" },
      { "<leader>lC", "<cmd>VimtexClean!<CR>",        ft = { "tex", "bib" }, desc = "Vimtex: clean all (incl. PDF)" },
      { "<leader>le", "<cmd>VimtexErrors<CR>",        ft = { "tex", "bib" }, desc = "Vimtex: errors quickfix" },
      { "<leader>lo", "<cmd>VimtexCompileOutput<CR>", ft = { "tex", "bib" }, desc = "Vimtex: compile log" },
      { "<leader>lt", "<cmd>VimtexTocOpen<CR>",       ft = { "tex", "bib" }, desc = "Vimtex: TOC open" },
      { "<leader>lT", "<cmd>VimtexTocToggle<CR>",     ft = { "tex", "bib" }, desc = "Vimtex: TOC toggle" },
      { "<leader>lq", "<cmd>VimtexLog<CR>",           ft = { "tex", "bib" }, desc = "Vimtex: log file" },
      { "<leader>ls", "<cmd>VimtexStatus<CR>",        ft = { "tex", "bib" }, desc = "Vimtex: status" },
      { "<leader>lS", "<cmd>VimtexStatusAll<CR>",     ft = { "tex", "bib" }, desc = "Vimtex: status all" },
      { "<leader>lr", "<cmd>VimtexReload<CR>",        ft = { "tex", "bib" }, desc = "Vimtex: reload plugin" },
      { "<leader>lR", "<cmd>VimtexReloadState<CR>",   ft = { "tex", "bib" }, desc = "Vimtex: reload state" },
      { "<leader>li", "<cmd>VimtexInfo<CR>",          ft = { "tex", "bib" }, desc = "Vimtex: info" },
      { "<leader>lI", "<cmd>VimtexInfo!<CR>",         ft = { "tex", "bib" }, desc = "Vimtex: info (full)" },
      { "<leader>la", "<plug>(vimtex-context-menu)",  ft = { "tex", "bib" }, desc = "Vimtex: context menu" },
    },
  },
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    ft = { "tex", "bib", "markdown" },
    dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
    config = function()
      require("luasnip-latex-snippets").setup({ use_treesitter = true })
      require("luasnip").config.setup({ enable_autosnippets = true })
    end,
  },
}
