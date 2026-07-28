# Features and workflows

[Home](./Home.md) | [Keymaps](./Keymap-Reference.md) | [Troubleshooting](./Troubleshooting.md)

This page describes the intended workflows and their side effects. The
[Keymap reference](./Keymap-Reference.md) is the exact mapping list.

## Discovering commands and mappings

Use the runtime interfaces before searching Lua:

| Entry | Result |
|---|---|
| `<leader>?` | Which-key view for the current buffer |
| `<leader>fk` | Search registered keymaps with Snacks |
| `<C-p>` | Open the legacy keymap panel |
| `:verbose map {lhs}` | Show the mapping and the file that last set it |
| `:Lazy` | Inspect plugin load state and errors |
| `:checkhealth` | Run Neovim and plugin health checks |

Many mappings are lazy-load triggers. A command may exist before its plugin has
loaded because Lazy installs a stub that loads the plugin and replays the
command.

## Files, buffers, and navigation

### Transient lookup with Snacks

Snacks picker is the fastest path when the target is not already visible:

- `<leader>ff` finds files, including hidden files;
- `<leader>fg` searches project text;
- `<leader>fb` selects an open buffer;
- `<leader>fr` shows recent files;
- `<leader>fp` selects a project;
- `<leader>fc`, `<leader>fh`, `<leader>fu`, and `<leader>fk` search command
  history, help, undo history, and keymaps.

File search includes hidden and ignored files by configuration. Text grep
includes hidden files. Review the result path before editing generated or
vendor files.

### Persistent context with Neo-tree

Neo-tree remains the persistent explorer because it has three sources in one
window:

| Source | Entry |
|---|---|
| Filesystem | `<leader>e` or `<C-n>` |
| Current file reveal | `<leader>fE` |
| Buffers | `<leader>be` |
| Git status | `<leader>ge` |

The filesystem source shows dotfiles and Git-ignored files but hides `.git` and
`node_modules`. It follows the current file and uses a libuv watcher. The source
selector appears in the winbar.

Inside Neo-tree:

| Key | Action |
|---|---|
| `o` or `l` | Open the node |
| `h` | Close the node |
| `P` | Toggle a floating preview |
| `Y` | Copy the node to the clipboard |
| `<C-v>` | Open in a vertical split |
| `<C-x>` | Open in a horizontal split |

### Buffers, windows, and tabs

Bufferline supports cycling, pinning, moving, directory sorting, and direct
selection with `<A-1>` through `<A-9>`. `<S-h>` and `<S-l>` provide simple
previous/next movement. Snacks deletes a buffer without forcing a window layout
change.

smart-splits maps `<C-h/j/k/l>` across Neovim and tmux. `<A-h/j/k/l>` resizes
the active split, and `<leader>W...` swaps buffers between neighboring windows.
This repository does not set the tmux prefix. The companion dotfiles currently
use `C-a`; smart-splits does not replace it.

Dropbar shows a breadcrumb and `<leader>;` opens its picker. Flash uses `s` and
`S` for label-based movement and Treesitter-aware selection.

## Editing, completion, and snippets

Blink loads on insert or command-line entry. The normal completion order is:

1. LSP
2. snippets
3. path
4. current/open buffers
5. spelling

TeX and BibTeX add the LaTeX source. Markdown keeps spelling suggestions. A tmux
provider is registered but is not part of any active source list.

Completion does not preselect an item. `<CR>` accepts the selected item,
`<C-n>/<C-p>` move through candidates, and Tab/S-Tab prefer snippet jumps before
completion movement. Documentation opens after 200 ms. Ghost text is enabled
when the menu is hidden.

LuaSnip loads:

- `friendly-snippets`;
- repository snippets from `snips/snippets/c.json`, `cpp.json`, `go.json`, and
  `latex.json`;
- Lua snippets from `lua/snippets/tex.lua`;
- `luasnip-latex-snippets.nvim` for TeX, BibTeX, and Markdown.

The repository manifest lists only files that exist. Do not use its old upstream
language list as a statement of support.

Selected editing helpers:

- nvim-surround provides its standard add, delete, and change operations;
- mini.align provides `ga` and `gA` alignment flows;
- autoclose inserts matching pairs;
- Vim Sleuth detects indentation from the current file;
- `g?p` and `g?P` insert debug prints below or above the cursor;
- visual `p` pastes without replacing the unnamed register.

## Language intelligence and diagnostics

Native `vim.lsp.config` and `vim.lsp.enable` start the configured clients.
Buffer-local LSP mappings appear only after a client attaches.

The navigation model distinguishes a direct jump from a result picker:

| Task | Direct | Picker |
|---|---|---|
| Definition | `gd` | `gD` or `<leader>lpd` |
| Implementation | `gm` | `gi` or `<leader>lpi` |
| Type definition | n/a | `gy` or `<leader>lpt` |
| References | n/a | `gh` or `<leader>lpr` |

`K` opens hover, `gr` renames, `ga` requests code actions, and `gs` opens
signature help. Trouble provides workspace, document, symbol, quickfix, and
location-list views.

Diagnostics use signs and underlines. Native virtual text and virtual lines are
disabled. tiny-inline-diagnostic renders the current-line message and can be
toggled with `<leader>lv`.

See [Language tooling](./Language-Tooling.md#language-intelligence) for servers,
capabilities, completion, and parser ownership.

## Formatting and linting

`<leader>cf` and `<A-S-f>` format the current buffer or visual range. `<A-f>`
toggles save formatting for the current buffer only. The toggle sets
`vim.b.disable_autoformat`; it does not change the global setting or another
buffer.

Save formatting stops when any of these conditions is true:

- global `format_on_save` is false;
- the current buffer toggle is off;
- the filetype appears in `formatter_block_list`;
- the file is below a path in `format_disabled_dirs`.

Conform uses a configured formatter first and falls back to LSP formatting when
no formatter is available. clangd, lua_ls, and ts_ls have server formatting
disabled so Conform remains the owner.

nvim-lint runs after buffer read, after write, and after leaving insert mode. It
currently runs Vint for Vim files and Shellcheck for shell files.

Use `:ConformInfo` for formatter resolution. The exact tool matrix is in
[Language tooling](./Language-Tooling.md#formatters-and-linters).

## Git review

The Git tools have separate jobs:

| Tool | Job |
|---|---|
| Gitsigns | Current-buffer hunks, staging, reset, preview, blame, and diff |
| diffview+ | Repository-wide review, file history, merge layouts |
| Fugitive | Git command interface, blame, push, pull |
| lazygit | Floating terminal UI |
| Neo-tree Git source | Persistent status tree |

A typical review:

1. Start Neovim at the worktree root.
2. Use `<leader>gg` for a status overview or `<leader>ge` for Neo-tree status.
3. Open `<leader>gd` to review all working-tree changes in diffview+.
4. Use `[h` and `]h` in a normal file to move between Gitsigns hunks.
5. Preview with `<leader>ghp`; stage or reset with `<leader>ghs` or
   `<leader>ghr`.
6. Close diffview+ with `<leader>gD`.

`<leader>gh` opens repository file history. `<leader>gB`, `<leader>gG`, and
`<leader>gP` open blame, Fugitive, and push. diffview+ uses the maintained fork
but keeps the original `Diffview*` commands and `require("diffview")` API.

For merge conflicts, open diffview+ and use `g?` in its buffers to inspect the
layout-specific actions. Do not assume a key from a two-way diff has the same
meaning in a merge layout.

## Debugging

nvim-dap owns protocol sessions. nvim-dap-view provides one tab-local debugging
view with watches, scopes, exceptions, breakpoints, threads, REPL, controls, and
inline virtual values.

A normal session:

1. Open the program file.
2. Set a breakpoint with `<leader>db` or a conditional breakpoint with
   `<leader>dB`.
3. Start or continue with `<leader>dc`.
4. nvim-dap-view opens automatically.
5. Step with `<leader>di`, `<leader>do`, and `<leader>dO`.
6. Add a watch with `<leader>dw` or hover a value with `<leader>dh`.
7. Terminate with `<leader>dt`; the view closes when the last session finishes.

`<leader>du` toggles the view, `<leader>dC` closes it and its terminal, and
`<leader>dv` toggles DAP virtual text. Visual hover calls the plugin's selection
helper directly because the locked `DapViewHover` Ex command does not accept a
range. Visual watch uses `DapViewWatch`, which does accept a range.

The configured adapters are:

| Language | Adapter | Owner |
|---|---|---|
| C, C++, Rust | codelldb | Mason |
| Go | Delve (`dlv`) | mise/system `PATH` |
| Python | debugpy adapter | mise/system `PATH` |

Run `:checkhealth dap` after loading a DAP command. The view itself does not ship
a health provider, so an absent `dap-view` health entry is not a failure.

## Terminal and AsyncRun

Snacks terminal entries:

| Key | Layout |
|---|---|
| `<C-\>` | Toggle the default terminal |
| `<A-\>` or `<F5>` | Toggle a right-side terminal |
| `<A-d>` | Toggle a floating terminal |
| `<leader>gg` | Open lazygit in a floating terminal |

Terminal mode uses `<Esc><Esc>` to return to normal mode. `<C-w>h/j/k/l>` moves
between windows from a terminal buffer.

`<leader>ar` opens an `:AsyncRun` command line. AsyncTasks and Vimux are not part
of the configuration. Use AsyncRun for one-off commands rather than expecting a
project task catalog.

## Sessions

persisted.nvim records sessions manually and includes the current Git branch in
the session identity.

| Key | Action |
|---|---|
| `<leader>ps` | Save the current session |
| `<leader>pl` | Load the most recent session |
| `<leader>pt` | Start, stop, or load as needed |
| `<leader>ss/sl/sd` | Legacy save/load/delete aliases |

Autoload is false. Starting Neovim in a directory will not silently replace the
current layout. `/tmp` and `/var` are excluded.

Session files include buffers, current directory, tabs, sizes, help, globals,
and folds. Runtime paths are excluded. Worktrees with different branches get
separate session names.

## Sidekick, Pi, and worktrees

Start Neovim from the root of the worktree that Pi should edit:

```bash
git worktree add ../project-task -b task/name
cd ../project-task
tmux new-session -s project-task
nvim .
```

Use `<leader>ii` to start or attach Pi. Sidekick opens a persistent vertical
tmux split at 50% width. The session inherits Neovim's current working
directory, so separate worktree roots produce separate CLI sessions.

| Key | Action |
|---|---|
| `<leader>ii` | Start or attach Pi |
| `<leader>is` | Select an installed CLI or existing session |
| `<leader>if` | Send the current file reference |
| `<leader>iv` | Send the visual selection |
| `<leader>it` | Send the current context |
| `<leader>ip` | Select a Sidekick prompt |
| `<leader>id` | Detach the pane without ending the CLI process |

Detaching a pane is not the same as exiting Pi. Exit the CLI when the process
should end.

Use one worktree, one Neovim process, and one CLI session per concurrent task.
Sharing a dirty worktree between agents defeats the session isolation and makes
review provenance unclear.

### External file changes

Sidekick watches loaded buffer directories and asks Neovim to check files after
CLI writes. `FocusGained` and `BufEnter` also schedule `:checktime` as a fallback
for writes outside Sidekick.

- A clean buffer reloads from disk.
- A dirty buffer keeps its local changes and raises `W12` when the file changed
  on disk as well.
- swap files remain enabled.

Do not suppress `W12` globally. Review both versions and choose which content to
keep.

## Documents and images

### Markdown

`<F1>` toggles render-markdown for the current Markdown buffer. CJK-friendly
wrapping is enabled and hard text width is disabled for Markdown, text, and TeX
buffers. Pangu spacing is available for those filetypes.

`<leader>pi` invokes img-clip. Clipboard images are saved below `figures/` at
the current working directory and inserted relative to the edited file.

| Filetype | Inserted form |
|---|---|
| Markdown | `![](relative/path.png)` |
| HTML | `<img src="relative/path.png" alt="">` |
| TeX | `\includegraphics[width=\linewidth]{relative/path.png}` |

The command prompts for a filename and can also consume a local file or URL
through the plugin API. Use `:ImgClipConfig` and `:ImgClipDebug` when the
clipboard backend fails.

### LaTeX

VimTeX owns TeX syntax, compilation, quickfix, and Zathura integration.
`latexmk` writes auxiliary files and PDFs to `build/`, runs continuously by
default, enables SyncTeX, and uses nonstop interaction. Global unrestricted
shell escape is not enabled.

The main flow:

1. `<leader>ll` starts or toggles continuous compilation.
2. `<leader>lv` opens Zathura and performs forward search.
3. `<leader>le` opens compilation errors.
4. `<leader>lo` opens compiler output.
5. `<leader>lk` stops compilation.
6. `<leader>lc` cleans auxiliary files.

On Wayland, VimTeX initialization sets Neovim's `GDK_BACKEND` environment to
`x11` before launching Zathura so `xdotool` can find the viewer. Neovim's TUI is
unaffected, but later GDK child processes can inherit the same value. After a
successful compile, Neovim sends `SIGHUP` to the VimTeX-spawned Zathura process
because the output file's inode may change.

The warning `Viewer cannot find Zathura window ID!` is ignored in normal
notifications because the 500 ms lookup can run before XWayland maps the
window. It remains available in `:VimtexLog`.

## CJK and input methods

Markdown, text, and TeX use wrapped display lines, break indentation, no fixed
text width, and no automatic spell checking. `<leader>o` can enable English
spell checking for the current buffer.

im-select loads on the first insert entry. If `fcitx5-remote` is executable, it
switches to `keyboard-us` on normal-mode and focus transitions, then restores
the previous input method on insert entry.

## Privileged writes and trust

`<A-s>` invokes `:SudaWrite`. It may request elevated privileges and should only
be used after reviewing the exact target path.

Pi and other CLIs can modify any file allowed by their process permissions.
Sidekick supplies context and file watching, not a sandbox. Keep unrelated
secrets outside the worktree, review diffs before staging, and do not rely on a
clean-buffer reload as an approval step.
