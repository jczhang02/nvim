-- ~/.config/nvim-new/lua/plugins/conform.lua
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = { "n", "v" }, desc = "Format buffer/range" },
    },
    opts = {
      formatters_by_ft = {
        lua        = { "stylua" },
        python     = { "ruff_format", "ruff_fix" },
        go         = { "goimports", "gofumpt" },
        rust       = { "rustfmt" },
        c          = { "clang_format" },
        cpp        = { "clang_format" },
        sh         = { "shfmt" }, bash = { "shfmt" }, zsh = { "shfmt" },
        javascript = { "prettier" }, typescript = { "prettier" },
        vue        = { "prettier" }, html = { "prettier" }, css = { "prettier" },
        json       = { "prettier" }, yaml = { "prettier" }, markdown = { "prettier" },
        tex        = { "latexindent" },
        bib        = { "bibtex-tidy" },
        xml        = { "xmlformat" },
      },
      format_on_save = function(bufnr)
        local s = require("config.settings")
        if not s.format_on_save then return end
        if s.formatter_block_list[vim.bo[bufnr].filetype] then return end
        local fname = vim.api.nvim_buf_get_name(bufnr)
        for _, dir in ipairs(s.format_disabled_dirs or {}) do
          local norm = vim.fs.normalize(dir)
          if fname:find(norm, 1, true) then return end
        end
        return { timeout_ms = s.format_timeout or 1000, lsp_format = "fallback" }
      end,
      formatters = {
        stylua = {
          prepend_args = function()
            local cfg = vim.fn.stdpath("config") .. "/stylua.toml"
            return vim.uv.fs_stat(cfg) and { "--config-path", cfg } or {}
          end,
        },
        clang_format = {
          prepend_args = { "-style={BasedOnStyle: LLVM, IndentWidth: 4}" },
        },
        latexindent = { prepend_args = { "-l", "-m" } },
        ["bibtex-tidy"] = {
          command = "bibtex-tidy",
          args = { "--curly", "--numeric", "--align=13", "--blank-lines", "--sort", "--duplicates", "--no-escape", "--sort-fields", "--remove-empty-fields", "--quiet", "$FILENAME" },
          stdin = false,
        },
      },
    },
  },
}
