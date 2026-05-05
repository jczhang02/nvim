# nvim

Personal Neovim configuration for Neovim 0.11+ / 0.12. Folke-style flat layout, one plugin per file under `lua/plugins/`.

## Highlights

- **Native LSP** — `vim.lsp.config` + `vim.lsp.enable` (Neovim 0.11+) wired through `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim`, and `neoconf.nvim`.
- **Rust-fast completion** — `blink.cmp` with LuaSnip, `friendly-snippets`, plus dedicated providers for spell, tmux, and LaTeX symbols.
- **Modern formatting & linting** — `conform.nvim` (format-on-save) and `nvim-lint`.
- **Snacks consolidation** — `snacks.nvim` provides picker, explorer, dashboard, notifier, terminal, indent guides, big-file handling, scope, scratch, and more (replaces telescope, nvim-tree, nvim-notify, alpha, toggleterm, indent-blankline, faster.nvim, mini.cursorword, nvim-bufdel).
- **Treesitter (`main` branch)** — registered through `vim.treesitter.start` with native APIs; `textobjects`, `context`, `vim-matchup`, `nvim-ts-autotag`, `rainbow-delimiters`, and `ts-context-commentstring` all included.
- **Catppuccin Latte** — light by default; flip via `lua/config/settings.lua`.
- **Languages** — Lua, Python (ruff + zuban), Go (gopls), Rust (rustaceanvim + crates), C/C++ (clangd), TypeScript/JavaScript (ts_ls), Shell (bashls + shellcheck), HTML/JSON, LaTeX (vimtex), Markdown (render-markdown), CSV, ebuild (Gentoo).
- **DAP** — `nvim-dap` + `nvim-dap-ui` + `mason-nvim-dap` (codelldb / delve / debugpy).
- **CJK aware** — `im-select.nvim` (fcitx5) + `pangu.vim` for CJK whitespace normalization.

## Layout

```
init.lua
lua/
├── config/
│   ├── options.lua      vim.opt + globals + provider toggles
│   ├── keymaps.lua      global non-plugin keymaps
│   ├── autocmds.lua     global autocmds (yank highlight, last-pos, mkdir, q-to-close, ts-start)
│   ├── lazy.lua         lazy.nvim bootstrap + import "plugins"
│   ├── settings.lua     user-tunable flags (colorscheme, lsp_deps, treesitter_deps, etc.)
│   └── icons.lua        icon table consumed by blink and lualine
├── plugins/             one plugin per file (40 specs)
│   ├── snacks.lua / blink.lua / lsp.lua / treesitter.lua  (large)
│   ├── conform.lua / nvim-lint.lua / glance.lua / tiny-inline-diagnostic.lua
│   ├── bufferline.lua / lualine.lua / dropbar.lua / edgy.lua / neoscroll.lua /
│   │   which-key.lua / trouble.lua / todo-comments.lua
│   ├── flash.lua / nvim-surround.lua / autoclose.lua / mini-align.lua /
│   │   hlslens.lua / vim-cool.lua / vim-sleuth.lua / smart-splits.lua /
│   │   grug-far.lua
│   ├── gitsigns.lua / diffview.lua / fugitive.lua / dap.lua
│   ├── nvim-bqf.lua / highlight-colors.lua / pastify.lua / persisted.lua /
│   │   suda.lua / debugprint.lua / asyncrun.lua / im-select.lua / pangu.lua
│   └── lang/{rust,latex,markdown,python,csv,gentoo}.lua
└── snippets/            LuaSnip from_lua source root
    └── tex.lua + ...
snips/                   VSCode-format snippet pack (c/cpp/go/latex)
templates/               file templates
docs/superpowers/        spec + implementation plan
stylua.toml / .luarc.json
```

## Requirements

- Neovim 0.11+ (0.12 preferred)
- `git`, `make`, a C compiler (treesitter parsers)
- A Nerd Font (default: JetBrainsMono Nerd Font)
- Optional binaries via `mason.nvim`: lua-language-server, ruff, gopls, clangd, typescript-language-server, bash-language-server, html-lsp, json-lsp, stylua, prettier, shfmt, latexindent, codelldb, delve, debugpy, shellcheck, vint
- Outside Mason: `rust-analyzer` (rustup), `zuban` (`pip install zuban`), `bibtex-tidy`, `xmlformat`, `beautysh`

## Install

```bash
git clone git@github.com:jczhang02/nvim.git ~/.config/nvim
nvim --headless -c 'Lazy! sync' -c 'qa'
nvim --headless -c 'MasonInstall lua-language-server ruff gopls clangd typescript-language-server bash-language-server stylua prettier shfmt' -c 'qa'
```

The first interactive launch installs treesitter parsers and remaining mason packages on demand.

## Keymaps

Leader is `<Space>`. Discover live with `<leader>?` (which-key buffer) or `<leader>fk` (snacks picker). Group prefixes:

| Prefix | Group |
|---|---|
| `<leader>f` | find / picker (snacks) |
| `<leader>l` / `<leader>lp` | LSP / peek (glance) |
| `<leader>d` | DAP / debug |
| `<leader>g` | git (gitsigns / diffview / fugitive) |
| `<leader>b` | buffer |
| `<leader>w` | window |
| `<leader>t` | terminal / tab |
| `<leader>x` | trouble / quickfix |
| `<leader>s` | search / replace (grug-far / todo) |
| `<leader>c` | code (format / diagnostic) |
| `<leader>r` | refactor / rename |
| `<leader>n` | notify / scratch |
| `<leader>p` | pastify / persisted |
| `<leader>a` | asyncrun / asynctasks |

Movement: `<C-h/j/k/l>` window jump (smart-splits), `<A-h/j/k/l>` resize, `<S-h>` / `<S-l>` buffer cycle, `s` / `S` flash jump / treesitter, `]h` / `[h` git hunk, `]d` / `[d` diagnostic, `]t` / `[t` todo.

## Customizing

Edit `lua/config/settings.lua` for:
- `colorscheme` — any catppuccin variant (`catppuccin-latte`, `catppuccin-mocha`, etc.)
- `background` — `light` or `dark`
- `lsp_deps` / `dap_deps` / `treesitter_deps` — bootstrap install lists
- `format_on_save` / `format_disabled_dirs` / `formatter_block_list`
- `diagnostics_virtual_lines` / `diagnostics_level`
- `lsp_inlayhints`

Per-project overrides via `.neoconf.json` (handled by `neoconf.nvim`).

## Documentation

- Design spec: [docs/superpowers/specs/2026-05-04-nvim-0.12-fresh-config-design.md](docs/superpowers/specs/2026-05-04-nvim-0.12-fresh-config-design.md)
- Implementation plan: [docs/superpowers/plans/2026-05-04-nvim-0.12-fresh-config.md](docs/superpowers/plans/2026-05-04-nvim-0.12-fresh-config.md)

## License

MIT — see [LICENSE](LICENSE).
