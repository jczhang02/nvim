# Language tooling

[Home](./Home.md) | [Architecture](./Architecture-and-Customization.md) | [Troubleshooting](./Troubleshooting.md)

## Ownership model

Language tools are deliberately split across owners:

- native Neovim LSP starts configured clients;
- Blink and LuaSnip provide completion and snippets;
- Treesitter installs parsers;
- Conform runs formatters;
- nvim-lint runs Vint and Shellcheck;
- nvim-dap runs debug adapters;
- Mason installs codelldb only;
- mise or the system package manager supplies every other executable.

Mason uses `PATH = "skip"`. Installing a server in Mason will not make this
configuration use it unless the ownership policy and server command are changed.

## Capability matrix

A blank entry means the repository does not configure that capability. A tool
may still be available through a project plugin or an ad hoc command.

| Language or filetype | Treesitter | LSP | Formatter | Linter | Debug or extra support |
|---|---|---|---|---|---|
| Bash, sh | `bash` | `bashls` | `shfmt` | `shellcheck` | AsyncRun |
| C | `c` | `clangd` | `clang-format` | | codelldb |
| C++ | `cpp` | `clangd` | `clang-format` | | codelldb |
| CSS | `css` | | Prettier | | color preview |
| CSV | | | | | csv.vim |
| Gentoo files | | | | | gentoo-syntax |
| Go | `go` | `gopls` | `goimports`, then `gofumpt` | | Delve |
| go.mod | `gomod` | `gopls` | | | |
| HTML | `html` | `html` | Prettier | | automatic tag updates |
| JavaScript | `javascript` | `ts_ls` | Prettier | | |
| JSON | `json` | `jsonls` | Prettier | | |
| LaTeX | `latex` installed, generic start skipped | | `latexindent` | | VimTeX, Zathura, LuaSnip |
| BibTeX | VimTeX | | `bibtex-tidy` | | LaTeX completion and snippets |
| Lua | `lua` | `lua_ls` | Stylua | | |
| Make | `make` | | | | |
| Markdown | `markdown`, `markdown_inline` | | Prettier | | render-markdown, snippets |
| Python | `python` | `pyright` through Delance, plus Ruff | `ruff_fix`, then `ruff_format` | | debugpy |
| Regex | `regex` | | | | picker highlighting |
| Rust | `rust` | rustaceanvim and rust-analyzer | `rustfmt` | | codelldb, crates.nvim |
| TypeScript | `typescript` | `ts_ls` | Prettier | | |
| Vim script | | | | `vint` | |
| Vim help | `vimdoc` | | | | |
| Vue | `vue` | | Prettier | | automatic tag updates |
| XML | | | `xmlformatter` | | |
| YAML | `yaml` | | Prettier | | |

The parser list is controlled by `settings.treesitter_parsers`. The matrix does
not claim that an installed parser starts in every filetype. TeX is the main
exception because VimTeX owns its syntax behavior.

## Language intelligence

`lua/plugins/lsp.lua` calls `vim.lsp.config` for server-specific changes and
then enables the names in `settings.lsp_servers`.

### Configured clients

| Client | Notable configuration |
|---|---|
| `bashls` | Native defaults |
| `clangd` | Background index, clang-tidy, IWYU-style header insertion; formatting disabled |
| `gopls` | gofumpt, placeholders, staticcheck, unused-parameter analysis, type/value hints |
| `html` | Native defaults |
| `jsonls` | Native defaults |
| `lua_ls` | Neovim runtime library, no telemetry, `vim`/`Snacks` globals, hints available; formatting disabled |
| `pyright` | Runs `delance-langserver --stdio`, workspace diagnostics, standard checking, library source, inlay capabilities |
| `ruff` | Error-level logging; owns Python fixes and formatting |
| `ts_ls` | Single-file support; formatting disabled |
| rustaceanvim | Starts rust-analyzer for Rust outside the global server list |

The `pyright` configuration name is retained because Neovim and project settings
refer to that server key. Its process command is Delance, not
`pyright-langserver`. No external Microsoft stub repository overrides its
bundled typeshed or installed PEP 561 packages.

Pyright's organize-import action is disabled because Ruff owns Python import
fixes. clangd, lua_ls, and ts_ls formatting capabilities are disabled because
Conform owns their filetypes.

### Attach behavior

Every attached client receives Blink capabilities. `LspAttach` then installs
buffer-local navigation, action, diagnostics, signature, and inlay-hint
mappings. If `settings.lsp_inlayhints` is true and the client supports hints,
they are enabled for the buffer.

Diagnostics use:

- signs and underlines;
- severity sorting;
- no update during insert mode;
- single-line, straight-corner floats with source names when several sources exist;
- no native virtual text or virtual lines.

Trouble and Snacks provide lists and pickers. tiny-inline-diagnostic provides
the current-line message.

### Project overrides

Neoconf reads `.neoconf.json`. Run `:Neoconf` in the project to inspect its
resolved settings. Use project-local overrides for repository-specific server
settings rather than adding one project's paths to the global config.

## Completion and snippets

Blink loads on `InsertEnter` or `CmdlineEnter`. The active default sources are:

| Source | Display label | Score offset |
|---|---|---|
| LSP | `[LSP]` | 90 |
| snippets | `[SNIP]` | 80 |
| path | `[PATH]` | 70 |
| buffer | `[BUF]` | 50 |
| spell | `[SPELL]` | 30 |

The buffer source searches all open buffers only when the current buffer has
fewer than 15,000 lines. This avoids scanning every open buffer while editing a
large file.

Per-filetype changes:

| Filetype | Sources |
|---|---|
| TeX | LSP, LaTeX, snippets, path, buffer, spell |
| BibTeX | LSP, LaTeX, snippets, path, buffer |
| Markdown | LSP, snippets, path, buffer, spell |

The tmux provider is installed and registered with offset 40, but no active
source list includes it. Add `"tmux"` to a default or per-filetype list before
describing tmux text as a completion source.

Blink's experimental signature interface is disabled. `ray-x/lsp_signature.nvim`
registers straight-corner signature help without virtual parameter hints. `gs` and
insert-mode `<C-k>` call Neovim signature help.

### Snippet sources

LuaSnip loads three classes of snippets:

1. `friendly-snippets` from the plugin dependency;
2. the four repository-owned VS Code files in `snips/snippets/`;
3. Lua snippets from `lua/snippets/tex.lua` and
   `luasnip-latex-snippets.nvim`.

Repository VS Code snippets cover C, C++, Go, and LaTeX. The manifest is kept
small on purpose and must not reference files that are absent from the tree.

LaTeX autosnippets use Treesitter-aware conditions where appropriate. Their
runtime load is tied to LuaSnip and TeX-related filetypes, not Neovim startup.

## Treesitter and comments

Interactive startup ensures these parsers:

```text
bash, c, cpp, css, go, gomod, html, javascript, json, latex, lua,
make, markdown, markdown_inline, python, regex, rust, typescript,
vimdoc, vue, yaml
```

The Treesitter stack also provides:

- function/class textobjects and movement;
- repeatable movement and parameter swapping;
- a four-line context window;
- matchup for structural pairs;
- HTML-style automatic tag updates;
- rainbow delimiters;
- `ts-comments.nvim` integration with native `gc` comments.

`ts-comments.nvim` loads on `VeryLazy` as an independent top-level spec. It
supports node-specific comments such as TypeScript inside a Vue script block and
HTML comments inside the template block.

## Formatters and linters

### Formatter order

| Filetype | Conform sequence |
|---|---|
| Lua | `stylua` |
| Python | `ruff_fix`, `ruff_format` |
| Go | `goimports`, `gofumpt` |
| Rust | `rustfmt` |
| C, C++ | `clang-format` |
| sh, Bash | `shfmt` |
| JavaScript, TypeScript, Vue, HTML, CSS, JSON, YAML, Markdown | `prettier` |
| TeX | `latexindent -l -m` |
| BibTeX | `bibtex-tidy` with repository-defined sorting and cleanup flags |
| XML | `xmlformatter` |

Manual formatting is asynchronous and uses LSP fallback. Save formatting has a
1,000 ms timeout by default and follows the global, buffer, filetype, and
directory gates described in [Features and workflows](./Features-and-Workflows.md#formatting-and-linting).

`bibtex-tidy` runs against the file rather than stdin. Its executable and
Node-compatible version are owned by the external mise/system environment, not
this repository.

### Linter triggers

| Filetype | Linter | Triggers |
|---|---|---|
| Vim script | Vint | buffer read, write, insert leave |
| sh, Bash | Shellcheck | buffer read, write, insert leave |

Ruff diagnostics come from the Ruff LSP client, not nvim-lint.

## DAP adapters

| Adapter | Executable | Configuration source |
|---|---|---|
| codelldb | `stdpath("data")/mason/bin/codelldb` | mason-nvim-dap default setup |
| Delve | `dlv dap -l 127.0.0.1:${port}` | mason-nvim-dap mappings, external executable |
| Python | `debugpy-adapter` | mason-nvim-dap mappings, external executable |

`settings.mason_dap_adapters` contains only `codelldb`. DAP health should show
all three executables when the full C/C++, Go, and Python toolchain is present.

## Project configuration precedence

The practical precedence is:

1. project-owned formatter or language configuration;
2. project `.neoconf.json` LSP overrides;
3. this repository's server and formatter defaults;
4. tool defaults.

Examples of project-owned files include `.clang-format`, Prettier config,
`stylua.toml`, `ruff.toml`, and `pyproject.toml`. The Neovim configuration selects
the tool but does not replace its project style.

## Inspect active tools

| Command | Use |
|---|---|
| `:LspInfo` | Attached clients, roots, commands, and buffers |
| `:checkhealth vim.lsp` | Native LSP health |
| `:ConformInfo` | Formatter selection and executable errors |
| `:checkhealth dap` | Adapter executable paths and sessions |
| `:Mason` | codelldb installation state |
| `:InspectTree` | Treesitter tree at the cursor |
| `:checkhealth nvim-treesitter` | Parser state when available |
| `:VimtexInfo` | TeX project, compiler, viewer, and root |

## Add or remove a language

Treat each capability independently:

1. Add only the parser to `settings.treesitter_parsers` when syntax structure is
   needed.
2. Install the server externally, then add its Neovim name to
   `settings.lsp_servers` or a language-specific plugin.
3. Add formatter and linter entries in their owning specs.
4. Add DAP configuration only when an adapter and a representative launch case
   can be tested.
5. Update this matrix and [Keymaps](./Keymap-Reference.md) if new user controls
   appear.
6. Verify a real project rather than only an empty temporary buffer.
