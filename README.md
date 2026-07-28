<h1 align="center">Neovim Configuration</h1>

<p align="center">A personal Neovim 0.12.4+ configuration for editing, review, diagnostics, and debugging.</p>

## Role

Neovim is the human-controlled review surface in an agent-assisted workflow:

- Neovim owns precise editing, Git diff review, diagnostics, tests, and debugging.
- AI CLIs run in persistent tmux panes through `sidekick.nvim`.
- Parallel tasks use one Git worktree, one Neovim instance, and one AI CLI session per task.

Sidekick is configured for CLI integration only. Copilot LSP and Next Edit Suggestions (NES) are disabled.

## Highlights

- Native LSP through `vim.lsp.config` and `vim.lsp.enable`.
- `blink.cmp` completion with LuaSnip, spell, tmux, and LaTeX sources.
- Project-aware formatting with `conform.nvim`; linting with `nvim-lint`.
- Git review with Gitsigns, Diffview, Fugitive, and lazygit.
- Diagnostics and navigation with Trouble, Glance, quickfix, and `nvim-bqf`.
- Debugging with `nvim-dap`, DAP UI, Delve, debugpy, and codelldb.
- File navigation with Snacks picker and Neo-tree.
- Persistent, branch-aware sessions with `persisted.nvim`.
- LaTeX editing with VimTeX and LuaSnip. Unrestricted shell escape is not enabled globally.

## Layout

```text
init.lua
lua/
├── config/
│   ├── autocmds.lua
│   ├── icons.lua
│   ├── keymaps.lua
│   ├── lazy.lua
│   ├── options.lua
│   └── settings.lua
├── plugins/
│   ├── lang/
│   └── *.lua
└── snippets/
    └── tex.lua
snips/
templates/
lazy-lock.json
stylua.toml
```

Each plugin has one specification under `lua/plugins/` or `lua/plugins/lang/`.

## Requirements

Required:

- Neovim 0.12.4 or newer
- Git
- A C compiler and `make` for Treesitter parsers
- A Nerd Font
- `rg`, `fd`, and `lazygit`
- `tmux`, `pi`, `lsof`, and `ps` for Sidekick CLI integration

Language tools are supplied through mise or the system `PATH`. Mason does not modify `PATH`; it only manages codelldb for this configuration.

Expected tools include:

```text
LSP:       bash-language-server, clangd, delance-langserver, gopls,
           lua-language-server, ruff, typescript-language-server,
           vscode-html-language-server, vscode-json-language-server
Format:    stylua, prettier, ruff, goimports, gofumpt, rustfmt,
           clang-format, shfmt, latexindent, bibtex-tidy, xmlformat
Lint:      shellcheck, vint
DAP:       codelldb, dlv, debugpy-adapter
```

When `/usr/bin/mise` is available, `init.lua` imports `mise env --json` before loading plugins so Neovim and shell agents use the same tools.

## Install

```bash
git clone git@github.com:jczhang02/nvim.git ~/.config/nvim
nvim --headless "+Lazy! install" +qa
nvim
```

The first interactive launch installs the configured Treesitter parsers. Install the external language tools before enabling their corresponding features.

## Sidekick and Pi

Start Neovim from the root of the current Git worktree. Sidekick derives its persistent session from the CLI name and Neovim's current working directory.

| Key | Action |
|---|---|
| `<leader>ii` | Start or attach Pi in a 50% vertical tmux split |
| `<leader>is` | Select an installed AI CLI or existing session |
| `<leader>if` | Send the current file reference |
| `<leader>iv` | Send the visual selection |
| `<leader>it` | Send the current context |
| `<leader>ip` | Select a Sidekick prompt |
| `<leader>id` | Detach the current CLI pane without ending its process |

Different worktree directories produce separate Pi sessions. Exit Pi itself when the session should be terminated. Sidekick watches loaded buffer directories and triggers `:checktime` after CLI writes; `FocusGained` and `BufEnter` provide a fallback for changes made outside Sidekick.

## Keymap Groups

Leader is `<Space>`. Use `<leader>?` or `<leader>fk` to inspect active mappings.

| Prefix | Group |
|---|---|
| `<leader>a` | AsyncRun / AsyncTasks |
| `<leader>b` | buffers |
| `<leader>c` | code and formatting |
| `<leader>d` | DAP |
| `<leader>f` | files and picker |
| `<leader>g` | Git |
| `<leader>i` | Sidekick / AI CLI |
| `<leader>l` | LSP |
| `<leader>n` | notifications and scratch buffers |
| `<leader>p` | persisted sessions |
| `<leader>x` | Trouble and quickfix |

`<C-h/j/k/l>` moves across Neovim and tmux panes. `<A-h/j/k/l>` resizes them.

## Formatting

Conform uses repository-owned configuration first, including `stylua.toml`, `.clang-format`, and Prettier configuration. Personal rules do not override project rules.

- `<leader>cf` or `<A-S-f>` formats the current buffer or visual range.
- `<A-f>` disables or re-enables format-on-save for the current buffer only.
- Global defaults and disabled directories live in `lua/config/settings.lua`.

## Customization

`lua/config/settings.lua` contains the intentionally supported settings:

- colorscheme and background
- enabled LSP servers
- Mason-managed DAP adapters
- Treesitter parsers
- format-on-save defaults and exclusions
- LSP inlay hints

Per-project LSP overrides are loaded by `neoconf.nvim` from `.neoconf.json`.

## Checks

```bash
stylua --check --config-path=stylua.toml .
luacheck . --std luajit --max-line-length 150 --no-config --globals vim Snacks
nvim --headless +qa
```

## License

MIT — see [LICENSE](LICENSE).
