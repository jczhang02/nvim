-- ~/.config/nvim-new/lua/plugins/lang/rust.lua
return {
  {
    "mrcjkb/rustaceanvim",
    version = "*",
    ft = "rust",
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
            local map = function(l, r, d) vim.keymap.set("n", l, r, { buffer = bufnr, desc = d }) end
            map("<leader>cR", function() vim.cmd.RustLsp("codeAction") end, "Rust code action")
            map("<leader>cE", function() vim.cmd.RustLsp({"explainError"}) end, "Explain error")
          end,
        },
      }
    end,
  },
  {
    "Saecki/crates.nvim",
    event = { "BufReadPost Cargo.toml" },
    opts = { completion = { cmp = { enabled = false }, blink = { enabled = true } } },
  },
}
