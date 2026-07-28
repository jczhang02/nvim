<h1 align="center">Neovim configuration</h1>

<p align="center">
  A Linux-first Neovim 0.12.4+ setup for editing, Git review, diagnostics,
  debugging, and Pi sessions in tmux.
</p>

<p align="center">
  <a href="https://github.com/jczhang02/nvim/actions/workflows/lint_code.yml"><img alt="lint code" src="https://github.com/jczhang02/nvim/actions/workflows/lint_code.yml/badge.svg"></a>
  <a href="https://github.com/jczhang02/nvim/actions/workflows/style_check.yml"><img alt="style check" src="https://github.com/jczhang02/nvim/actions/workflows/style_check.yml/badge.svg"></a>
  <a href="https://github.com/jczhang02/nvim/blob/main/LICENSE"><img alt="MIT license" src="https://img.shields.io/github/license/jczhang02/nvim"></a>
  <img alt="Neovim 0.12.4+" src="https://img.shields.io/badge/Neovim-0.12.4%2B-57A143?logo=neovim&logoColor=white">
</p>

<p align="center">
  <a href="./wiki/Home.md">Wiki</a> ·
  <a href="./wiki/Getting-Started.md">Install</a> ·
  <a href="./wiki/Features-and-Workflows.md">Workflows</a> ·
  <a href="./wiki/Keymap-Reference.md">Keymaps</a> ·
  <a href="./wiki/Troubleshooting.md">Troubleshooting</a>
</p>

## What this is

This is a personal configuration, not a general Neovim distribution. It targets
Linux, tmux, Git worktrees, and external development tools managed outside
Neovim.

Neovim is the human-controlled surface in the agent workflow. Pi runs in a
persistent tmux pane through Sidekick and edits the current worktree. Neovim
keeps responsibility for precise edits, diagnostics, diff review, formatting,
and debugging.

| Layer | Responsibility |
|---|---|
| Neovim | Editing, navigation, diagnostics, review, and debugging |
| Sidekick | File, selection, and context handoff between Neovim and a CLI |
| tmux | Persistent panes and process lifetime |
| Pi | Agent execution in the current worktree |
| Git worktree | Task isolation for concurrent work |

Sidekick is CLI-only. Copilot LSP, Next Edit Suggestions, embedded chat panels,
and a Neovim MCP server are intentionally absent.

## Capabilities

| Area | Current implementation | Details |
|---|---|---|
| Completion | Blink, LuaSnip, LSP, path, buffer, spell, and LaTeX sources | [Language tooling](./wiki/Language-Tooling.md#completion-and-snippets) |
| LSP and diagnostics | Native `vim.lsp`, Snacks pickers, Trouble, and tiny inline diagnostics | [Language tooling](./wiki/Language-Tooling.md#language-intelligence) |
| Formatting and linting | Conform with project-owned rules; nvim-lint for Vim and shell files | [Language tooling](./wiki/Language-Tooling.md#formatters-and-linters) |
| Git | Gitsigns, diffview+, Fugitive, and lazygit | [Workflows](./wiki/Features-and-Workflows.md#git-review) |
| Debugging | nvim-dap, nvim-dap-view, codelldb, Delve, and debugpy | [Workflows](./wiki/Features-and-Workflows.md#debugging) |
| Navigation | Snacks picker, Neo-tree, Flash, Dropbar, Bufferline, and smart-splits | [Workflows](./wiki/Features-and-Workflows.md#files-buffers-and-navigation) |
| Documents | VimTeX, render-markdown, custom snippets, and clipboard image paste | [Workflows](./wiki/Features-and-Workflows.md#documents-and-images) |
| Agent handoff | Sidekick with a persistent 50% vertical Pi pane in tmux | [Agent workflow](./wiki/Features-and-Workflows.md#sidekick-pi-and-worktrees) |

## Quick start

Protect an existing configuration before cloning:

```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

Install this repository and restore the locked plugin set:

```bash
git clone https://github.com/jczhang02/nvim.git ~/.config/nvim
nvim --headless "+Lazy! restore" +qa
nvim
```

`Lazy! restore` checks out every plugin at the commit in `lazy-lock.json`. The
first interactive launch installs the configured Treesitter parsers. DAP loads
Mason later and installs only codelldb.

The normal editing experience expects:

- Neovim 0.12.4 or newer
- Git, a C compiler, and `make`
- a Nerd Font
- `rg` and `fd` for search and file discovery

Sidekick, language servers, formatters, debuggers, LaTeX, lazygit, and clipboard
images have separate feature dependencies. See
[Getting started](./wiki/Getting-Started.md#requirements-by-feature) before
setting up a new machine.

## First commands

Leader is `<Space>` and local leader is `,`.

| Key or command | Purpose |
|---|---|
| `<leader>?` | Show mappings for the current buffer |
| `<leader>fk` | Search all registered keymaps |
| `<leader>ff` / `<leader>fg` | Find files / search text |
| `<leader>e` | Toggle Neo-tree |
| `<leader>cf` | Format the current buffer or selection |
| `<leader>gd` | Open diffview+ |
| `<leader>ii` | Start or attach Pi in tmux |
| `:checkhealth` | Inspect Neovim and plugin health |
| `:Lazy` / `:Mason` | Inspect plugins / codelldb |

The complete reference is in [Keymaps](./wiki/Keymap-Reference.md). Runtime
Which-key and the Snacks keymap picker remain the final authority when a plugin
changes a mapping.

## Documentation

The repository keeps its Wiki source in `wiki/` so documentation changes can be
reviewed with configuration changes.

| Page | Use it for |
|---|---|
| [Home](./wiki/Home.md) | Documentation map and configuration boundaries |
| [Getting started](./wiki/Getting-Started.md) | Installation, requirements, first launch, update, and removal |
| [Architecture and customization](./wiki/Architecture-and-Customization.md) | Startup sequence, state ownership, settings, plugin catalog, and extension recipes |
| [Features and workflows](./wiki/Features-and-Workflows.md) | Daily editing, Git, DAP, sessions, Sidekick, Markdown, and LaTeX |
| [Language tooling](./wiki/Language-Tooling.md) | LSP, parser, formatter, linter, DAP, completion, and snippet matrix |
| [Keymap reference](./wiki/Keymap-Reference.md) | Repository-defined global, plugin, and buffer-local mappings |
| [Troubleshooting](./wiki/Troubleshooting.md) | Symptom-based checks and known health noise |
| [Development and maintenance](./wiki/Development-and-Maintenance.md) | Lock updates, CI, documentation checks, and Wiki publishing |

GitHub's separate Wiki repository is not initialized. The version-controlled
files in `wiki/` are the canonical source and are ready for one-way publishing
when the Wiki is enabled.

## Repository map

```text
init.lua                         startup and environment import
lua/config/                      options, settings, keymaps, autocmds, Lazy
lua/plugins/                     plugin specifications and integrations
lua/snippets/tex.lua             custom LuaSnip LaTeX snippets
snips/                           repository-owned VS Code snippets
wiki/                            version-controlled Wiki source
scripts/check_docs.py            source and rendered-Wiki consistency check
scripts/render_wiki.py           GitHub Wiki publication renderer
lazy-lock.json                   exact plugin revisions
stylua.toml                      Lua formatting policy
.github/workflows/               Lua, startup, style, and documentation CI
```

## Local checks

```bash
stylua --check --config-path=stylua.toml .
luacheck . --std luajit --max-line-length 150 --no-config --globals vim Snacks
python scripts/check_docs.py
nvim --headless +qa
```

For a locked install or recovery, run:

```bash
nvim --headless "+Lazy! restore" +qa
```

See [Development and maintenance](./wiki/Development-and-Maintenance.md) before
updating Neovim, plugin revisions, or the Wiki publication.

## License

MIT. See [LICENSE](LICENSE).
