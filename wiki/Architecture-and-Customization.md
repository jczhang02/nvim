# Architecture and customization

[Home](./Home.md) | [Language tooling](./Language-Tooling.md) | [Maintenance](./Development-and-Maintenance.md)

## Startup sequence

`init.lua` keeps startup ordering explicit:

1. `vim.loader.enable()` enables Neovim's Lua module cache.
2. `/usr/bin/mise env --json` is imported when that executable exists.
3. `<Space>` becomes leader and `,` becomes local leader.
4. `lua/config/options.lua` sets editor options and disables unused providers.
5. `lua/config/lazy.lua` bootstraps Lazy and imports plugin specifications.
6. `lua/config/keymaps.lua` installs global mappings.
7. `lua/config/autocmds.lua` installs global automatic behavior.

This order matters. Plugin setup can use options, leaders, and the mise-provided
`PATH`, while global keymaps and autocmds are installed after Lazy has registered
its command and key triggers.

```mermaid
flowchart TD
    Init[init.lua] --> Loader[vim.loader]
    Loader --> Mise[/usr/bin/mise env]
    Mise --> Options[lua/config/options.lua]
    Options --> Lazy[lua/config/lazy.lua]
    Lazy --> Specs[lua/plugins and lua/plugins/lang]
    Lazy --> Keys[lua/config/keymaps.lua]
    Keys --> Autocmds[lua/config/autocmds.lua]
```

## Repository structure

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
├── package.json
└── snippets/
templates/
wiki/
scripts/
├── check_docs.py
└── render_wiki.py
lazy-lock.json
stylua.toml
```

The boundaries are simple:

- `config/` owns behavior shared across plugins.
- `plugins/` owns plugin declarations and plugin-specific integration.
- `settings.lua` is the supported personal customization surface.
- `snips/` and `lua/snippets/` own repository-specific snippets.
- `wiki/` owns long-form documentation.
- `lazy-lock.json` owns exact plugin revisions.

## Lazy loading and lock policy

Lazy defaults every plugin to lazy loading unless a spec explicitly sets
`lazy = false`. Most plugins load through a filetype, command, event, or mapping.
The main startup plugins are Catppuccin, Snacks, Treesitter, and smart-splits.

The automatic update checker and config change detector are disabled. This
prevents background update prompts and keeps the current checkout tied to the
reviewed lock. Use `:Lazy update` only for an intentional update; use
`:Lazy restore` for normal installation and recovery.

Several built-in runtime plugins are disabled because another component owns
their job: netrw, gzip, tar, zip, tutor, matchparen, matchit, `tohtml`, and the
related archive plugins.

## Tool ownership

| Owner | Managed items | Does not manage |
|---|---|---|
| Lazy | Neovim plugins under `stdpath("data")/lazy` | LSP servers and CLI tools |
| Treesitter | Configured parsers under `stdpath("data")/site` | VimTeX syntax for TeX buffers |
| Mason | codelldb under `stdpath("data")/mason` | LSP servers, formatters, Delve, debugpy |
| mise/system | Servers, formatters, linters, `dlv`, `debugpy-adapter` | Plugin revisions |
| Project repository | `.clang-format`, Prettier config, Stylua config, `.neoconf.json` | Personal global defaults |
| Neovim state | undo, sessions, logs, Shada | Source configuration |

Mason is configured with `PATH = "skip"`. codelldb is referenced by absolute
path, and all other executables must already be on `PATH`.

## Supported settings

`lua/config/settings.lua` is the intended place for machine or personal policy.
Changes elsewhere are valid, but they are implementation changes rather than
settings changes.

| Field | Type | Default | Effect |
|---|---|---|---|
| `format_on_save` | boolean | `true` | Enables Conform on save globally |
| `format_timeout_ms` | integer | `1000` | Save-time formatting timeout |
| `formatter_block_list` | table keyed by filetype | `{}` | Disables save formatting for selected filetypes |
| `format_disabled_dirs` | list of paths | `{}` | Disables save formatting below selected paths |
| `server_formatting_block_list` | table keyed by client | clangd, lua_ls, ts_ls | Prevents selected LSP clients from formatting |
| `colorscheme` | string | `catppuccin-latte` | Colorscheme applied after Catppuccin setup |
| `background` | `light` or `dark` | `light` | Neovim background option |
| `transparent_background` | boolean | `false` | Catppuccin transparency |
| `lsp_inlayhints` | boolean | `false` | Enables supported LSP inlay hints on attach |
| `lsp_servers` | list of server names | Bash, C/C++, Go, HTML, JSON, Lua, Python, Ruff, TypeScript | Native LSP clients enabled at startup |
| `mason_dap_adapters` | list of adapter names | `codelldb` | Adapters ensured by mason-nvim-dap |
| `treesitter_parsers` | list of parser names | language list in the file | Parsers installed on interactive startup |

Most setting changes apply to newly opened buffers or newly attached clients.
Restart Neovim after changing the colorscheme, server list, parser list, or
plugin ownership settings.

## Global options

`lua/config/options.lua` defines the editor baseline:

- absolute and relative line numbers, a permanent sign column, cursor line, and
  an eight-line scroll offset;
- four-space indentation as a fallback, with Vim Sleuth available to detect a
  file's actual indentation;
- smart-case search, persistent search highlighting, and `rg` as `grepprg`;
- system clipboard integration through `unnamedplus`;
- persistent undo under `stdpath("state")/undo`;
- swap files enabled, backups disabled, and confirmation for destructive exits;
- right and below split defaults;
- a global statusline, visible bufferline, popup limits, and true color;
- branch-aware session options without runtime paths;
- GUI and Neovide defaults for the local font and animation policy.

Perl, Ruby, Python 3, and Node provider hosts are disabled. Language servers and
Python DAP do not use Neovim's Python provider, so this does not disable Python
editing or debugging.

## Global autocmds

`lua/config/autocmds.lua` owns behavior that should not depend on one plugin:

| Event | Behavior |
|---|---|
| `TextYankPost` | Briefly highlights copied text |
| `BufReadPost` | Restores the last valid cursor position |
| `FocusGained`, `BufEnter` | Schedules `:checktime` for external changes |
| `BufWritePre` | Creates missing parent directories |
| tool-window `FileType` | Makes buffers unlisted and maps `q` to close |
| Markdown, text, TeX `FileType` | Enables CJK-friendly wrapping and disables hard text width |
| other `FileType` values | Starts an available Treesitter parser |

TeX, LaTeX, and plain TeX buffers skip the generic Treesitter start because
VimTeX owns package-aware syntax and math-zone behavior.

## State and recovery locations

Neovim follows its standard XDG directories:

| Data | Default location |
|---|---|
| Configuration | `~/.config/nvim` |
| Plugins, Mason, parsers, sessions | `~/.local/share/nvim` |
| Undo, logs, Shada | `~/.local/state/nvim` |
| Cache | `~/.cache/nvim` |

`persisted.nvim` writes branch-aware sessions below the data directory. It does
not load them automatically. Sidekick and `checktime` handle files changed by an
external CLI; they do not replace swap files or dirty-buffer conflict handling.

## Plugin catalog

The table lists every plugin specification file in this repository. Exact
plugin revisions and transitive dependencies belong in `lazy-lock.json`, not in
a hand-maintained version table.

| Configuration | Main component | Responsibility and load boundary |
|---|---|---|
| `lua/plugins/asyncrun.lua` | AsyncRun | Prompted background commands; command or mapping |
| `lua/plugins/autoclose.lua` | autoclose.nvim | Pair insertion after `InsertEnter` |
| `lua/plugins/blink.lua` | Blink, LuaSnip, completion sources | Insert and command-line completion |
| `lua/plugins/bufferline.lua` | Bufferline | Buffer tabs, diagnostics, pinning, movement |
| `lua/plugins/colorscheme.lua` | Catppuccin | Startup colors and integrations |
| `lua/plugins/conform.lua` | Conform | Manual and save-time formatting |
| `lua/plugins/dap.lua` | nvim-dap, nvim-dap-view, Mason DAP | Debug adapters, UI, and controls |
| `lua/plugins/debugprint.lua` | debugprint.nvim | Insert and manage debug statements |
| `lua/plugins/diffview.lua` | diffview+ | Repository diff and file history commands |
| `lua/plugins/dropbar.lua` | Dropbar | Breadcrumb navigation after buffer read |
| `lua/plugins/edgy.lua` | Edgy | Placement rules for tool windows and Neo-tree |
| `lua/plugins/flash.lua` | Flash | Label-based and Treesitter-aware jumps |
| `lua/plugins/fugitive.lua` | Fugitive | Git porcelain commands |
| `lua/plugins/gitsigns.lua` | Gitsigns | Hunks, staging, blame, and inline Git signs |
| `lua/plugins/grug-far.lua` | grug-far | Interactive project search and replace |
| `lua/plugins/highlight-colors.lua` | nvim-highlight-colors | Color literal previews |
| `lua/plugins/hlslens.lua` | nvim-hlslens | Search result counts and search navigation |
| `lua/plugins/im-select.lua` | im-select.nvim | fcitx5 input-method reset |
| `lua/plugins/img-clip.lua` | img-clip.nvim | Clipboard image files and markup insertion |
| `lua/plugins/lang/csv.lua` | csv.vim | CSV editing support |
| `lua/plugins/lang/gentoo.lua` | gentoo-syntax | Gentoo filetype syntax |
| `lua/plugins/lang/latex.lua` | VimTeX, LaTeX snippets | TeX compilation, viewer, syntax, snippets |
| `lua/plugins/lang/markdown.lua` | render-markdown | In-buffer Markdown rendering |
| `lua/plugins/lang/rust.lua` | rustaceanvim, crates.nvim | Rust LSP integration and Cargo metadata |
| `lua/plugins/lsp.lua` | Mason, native LSP, Neoconf, lsp_signature | LSP startup, capabilities, diagnostics, signatures |
| `lua/plugins/lualine.lua` | Lualine | Global statusline |
| `lua/plugins/mini-align.lua` | mini.align | Interactive alignment |
| `lua/plugins/neo-tree.lua` | Neo-tree | Filesystem, buffer, and Git status explorer |
| `lua/plugins/nvim-bqf.lua` | nvim-bqf | Quickfix preview and sizing |
| `lua/plugins/nvim-lint.lua` | nvim-lint | Shellcheck and Vint triggers |
| `lua/plugins/nvim-surround.lua` | nvim-surround | Surround add, delete, and change operations |
| `lua/plugins/pangu.lua` | pangu.vim | CJK and Latin spacing in documents |
| `lua/plugins/persisted.lua` | persisted.nvim | Manual branch-aware sessions |
| `lua/plugins/sidekick.lua` | Sidekick | Pi and other CLI sessions in tmux |
| `lua/plugins/smart-splits.lua` | smart-splits | Neovim and tmux window movement and resize |
| `lua/plugins/snacks.lua` | Snacks | Picker, terminal, dashboard, scroll, profiler, notifications |
| `lua/plugins/suda.lua` | suda.vim | Elevated reads and writes |
| `lua/plugins/tiny-inline-diagnostic.lua` | tiny-inline-diagnostic | Current-line diagnostic rendering |
| `lua/plugins/todo-comments.lua` | todo-comments | TODO signs, jumps, and picker source |
| `lua/plugins/treesitter.lua` | Treesitter and related modules | Parsers, textobjects, context, tags, matchup, delimiters |
| `lua/plugins/trouble.lua` | Trouble | Diagnostic, LSP, quickfix, and location-list views |
| `lua/plugins/ts-comments.lua` | ts-comments | Native comments for Treesitter languages |
| `lua/plugins/vim-sleuth.lua` | Vim Sleuth | Buffer indentation detection |
| `lua/plugins/which-key.lua` | Which-key | Leader group descriptions and mapping discovery |

The documentation check requires each specification path to appear in this
catalog. Adding a new file under `lua/plugins/` therefore requires a matching
catalog entry.

## Project-local configuration

Neoconf reads `.neoconf.json` from a project. Use `:Neoconf` to inspect and edit
project-local LSP settings. Keep server-specific experiments there when they
should not affect every repository.

Formatters discover their normal project files:

- Stylua reads the nearest `stylua.toml` or `.stylua.toml`.
- clang-format reads the nearest `.clang-format`.
- Prettier resolves its supported configuration files.
- Ruff uses project configuration for Python fixes and formatting.

Conform does not inject a personal style over these files.

## Customization recipes

### Change appearance

Edit `colorscheme`, `background`, or `transparent_background` in
`lua/config/settings.lua`. Catppuccin integrations remain in
`lua/plugins/colorscheme.lua`.

### Add an LSP server

1. Install the server through mise or the system package manager.
2. Add its Neovim server name to `settings.lsp_servers`.
3. Add `vim.lsp.config("name", {...})` in `lua/plugins/lsp.lua` only when the
   defaults are insufficient.
4. Add a parser, formatter, or linter separately if the language needs one.
5. Open a representative file and verify `:LspInfo`.

Mason should not be used for the server unless the ownership policy is changed
as a separate decision.

### Add a formatter or linter

Add the formatter to `formatters_by_ft` in `lua/plugins/conform.lua` and install
its executable outside Neovim. Add a linter to `linters_by_ft` in
`lua/plugins/nvim-lint.lua`. Verify both the success path and an unavailable-tool
failure.

### Add a parser

Add the parser name to `settings.treesitter_parsers`. Interactive startup will
install it. Confirm its filetype-to-language mapping before adding a custom
`FileType` autocmd.

### Add a plugin

Create one focused file under `lua/plugins/`, use the narrowest useful lazy-load
trigger, and avoid duplicating an existing component. Run the full validation
set, update the plugin catalog, and review the lock diff.

### Add a mapping

Prefer a plugin's Lazy `keys` field for plugin-owned mappings and
`lua/config/keymaps.lua` for editor-wide behavior. Every mapping needs a `desc`
for Which-key and Snacks discovery. Update [Keymap reference](./Keymap-Reference.md)
when the mapping is user-facing.

## Architecture boundaries

The following changes alter the configuration's design rather than one setting:

- replacing Neo-tree with a transient picker;
- moving LSP, formatter, or linter installation into Mason;
- enabling another embedded AI interface;
- enabling Copilot LSP or Sidekick NES;
- allowing sessions to load automatically;
- enabling unrestricted LaTeX shell escape globally;
- changing Sidekick away from tmux or worktree-root session isolation.

Document and verify those changes as architecture changes.
