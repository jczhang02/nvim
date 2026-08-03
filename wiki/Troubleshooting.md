# Troubleshooting

[Home](./Home.md) | [Getting started](./Getting-Started.md) | [Maintenance](./Development-and-Maintenance.md)

## Diagnostic path

Use the smallest branch that matches the symptom:

1. Neovim does not start: run a headless start and inspect Lazy.
2. One plugin command is missing: inspect its Lazy trigger and checkout.
3. One language feature is missing: inspect `PATH`, then LSP/Conform/DAP.
4. A file changed unexpectedly: inspect `:messages`, buffer modified state, and
   the disk version.
5. A health check is red but the feature works: compare it with the known output
   section before changing config.

Do not delete all Neovim data as the first step. A targeted check preserves logs
and makes the root cause easier to reproduce.

## Information to collect

Run outside Neovim:

```bash
nvim --version | head -n 3
git -C ~/.config/nvim status --short --branch
git -C ~/.config/nvim rev-parse HEAD
printf '%s\n' "$PATH"
```

Run inside Neovim:

```vim
:messages
:checkhealth
:Lazy
:pwd
:set filetype?
:set modified?
```

For a mapping:

```vim
:verbose nmap <leader>gd
:verbose imap <C-k>
```

For a language feature:

```vim
:LspInfo
:ConformInfo
:checkhealth dap
```

Record the exact filetype, working directory, executable path, and first error.
A later stack trace often describes cleanup after the original failure.

## Startup and Lazy restore

### `nvim --headless +qa` fails

Run from a shell and preserve all output:

```bash
nvim --headless +qa 2>&1 | tee /tmp/nvim-startup.log
```

Then inspect:

```bash
nvim --headless "+Lazy! restore" +qa
```

Common causes:

- Neovim is older than 0.12.4.
- A plugin checkout does not match `lazy-lock.json`.
- the config is not at `${XDG_CONFIG_HOME:-$HOME/.config}/nvim`.
- Git cannot reach GitHub.
- a previous install left an incomplete plugin directory.

Use `:Lazy log` or `<leader>Pl` to inspect plugin operations. `Lazy! restore`
should be the recovery action. `Lazy update` changes the lock and is not a repair
command.

### `:Lazy` is not a command

Confirm the config actually loaded:

```vim
:echo stdpath('config')
:scriptnames
```

The bootstrap path is `stdpath("data")/lazy/lazy.nvim`. If its clone failed,
remove only that incomplete directory and start again:

```bash
mv "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy/lazy.nvim" \
   /tmp/lazy.nvim.incomplete
nvim --headless "+Lazy! restore" +qa
```

### A command does not lazy-load its plugin

Check the plugin spec for the command in `cmd`. Key mappings can load a parent
spec even when a direct Ex command was not registered. This repository lists
all `DapView*` commands on the parent nvim-dap spec so they work as first entry
points.

## PATH, mise, and Mason

### Neovim cannot find a tool that the shell can

Compare paths:

```vim
:echo $PATH
:echo executable('ruff')
:echo exepath('ruff')
```

`init.lua` prepends `~/.local/share/mise/shims` so GUI launches do not depend on
interactive shell startup. Check that the expected shim exists and that the
tool is selected in mise. If `MISE_DATA_DIR` or `XDG_DATA_HOME` is customized,
update the path in `init.lua` or start Neovim from a shell that already provides
the tool.

### Mason shows no LSP servers

That is expected. Mason owns only codelldb in this configuration. LSP servers,
formatters, linters, Delve, and debugpy come from mise or the system `PATH`.

### codelldb is absent

Load a DAP command, open `:Mason`, and wait for codelldb installation. The
expected executable is:

```text
stdpath("data")/mason/bin/codelldb
```

If installation was interrupted, uninstall and reinstall codelldb from Mason,
then run `:checkhealth dap`.

## Treesitter

### Highlighting or textobjects are missing

Check the filetype and parser:

```vim
:set filetype?
:InspectTree
```

Run an interactive Neovim session after changing
`settings.treesitter_parsers`; headless startup deliberately skips parser
installation. Use `:checkhealth nvim-treesitter`, `:TSInstall {parser}`, or
`:TSUpdate` with the locked main branch.

### TeX does not start a Treesitter highlighter

That is intentional. VimTeX owns TeX syntax and package-aware math behavior.
The LaTeX parser is still installed for plugins and snippet conditions.

### Embedded comments use the wrong syntax

Confirm `ts-comments.nvim` has loaded after `VeryLazy` and the injected parser is
available. In Vue, a script block needs the TypeScript or JavaScript parser, and
the template needs the Vue/HTML tree. Inspect the node with `:InspectTree`.

## LSP and completion

### No client attaches

1. Run `:set filetype?`.
2. Run `:LspInfo`.
3. Check the server name in `settings.lsp_servers`.
4. Check `executable()` and `exepath()` for the process command.
5. Inspect `.neoconf.json` for a project override.

Python's configured server key is `pyright`, but its process is
`delance-langserver --stdio`. Testing `pyright-langserver` does not verify this
configuration.

Rust is different: rustaceanvim starts rust-analyzer when a Rust buffer opens.
It is not listed in `settings.lsp_servers`.

### Python has duplicate or conflicting diagnostics

Two clients are expected: Delance under the `pyright` key and Ruff. Delance owns
type analysis and Ruff owns lint/fix behavior. Pyright organize imports are
disabled. Check each diagnostic source before disabling a client.

### Completion opens but a source is absent

Use Blink's source labels. Active defaults are LSP, snippets, path, buffer, and
spell. LaTeX is filetype-specific. The tmux provider is installed but not active
in any source list.

If the Rust fuzzy matcher is unavailable, Blink may warn and fall back according
to `prefer_rust_with_warning`. Completion can still function.

### Signature help does not appear

Blink signature help is disabled. The expected provider is
`ray-x/lsp_signature.nvim`. Test native help with `gs` in normal mode or
`<C-k>` in insert mode while a client with signature capability is attached.

### Diagnostics have no inline text

Native virtual text and virtual lines are disabled. Look for signs and
underlines, open `<leader>lx`, or toggle tiny-inline-diagnostic with
`<leader>lv`.

## Formatting and linting

### Save does not format

Run `:ConformInfo`, then inspect:

```vim
:lua print(vim.inspect(vim.b.disable_autoformat))
:lua print(vim.inspect(require('config.settings').format_on_save))
:set filetype?
```

Also check `formatter_block_list`, `format_disabled_dirs`, and the executable.
`<A-f>` changes only the current buffer.

### Manual format works but save does not

Manual formatting is asynchronous. Save formatting has a 1,000 ms timeout by
default and may be disabled by one of the save gates. Increase
`format_timeout_ms` only after confirming the formatter is expected to take
longer.

### Formatting ignores project style

Confirm the tool finds the project file from Neovim's current working directory
and the edited file path. Conform does not replace `.clang-format`, Prettier,
Stylua, Ruff, or project-specific configuration.

### BibTeX formatting fails under Node

This repository does not pin the external `bibtex-tidy` or Node versions. Check
that the installed pair is compatible before changing Conform arguments or
assuming a formatter regression.

### Shellcheck or Vint does not run

nvim-lint is configured only for Vim script, sh, and Bash. It runs on buffer
read, write, and insert leave. Check `:messages` and `exepath('shellcheck')` or
`exepath('vint')`.

## DAP

### Adapter health fails

Load DAP first, then run:

```vim
:checkhealth dap
```

Expected ownership:

- codelldb from Mason;
- `dlv` from `PATH`;
- `debugpy-adapter` from `PATH`.

A passing Mason screen does not verify Delve or debugpy.

### DAP starts but the view does not open

Check `:DapViewOpen` directly. All DapView commands are registered as nvim-dap
lazy-load triggers. `auto_toggle = true` opens the view before attach/launch and
closes it when the last session ends.

### Visual hover raises `E481: No range allowed`

The locked plugin's `DapViewHover` Ex command does not accept a range even
though its documentation discusses visual selection. Use `<leader>dh`; the
repository's visual mapping calls the plugin selection helper and public hover
API directly.

`DapViewWatch` does accept a visual range, so `<leader>dw` uses the command.

### `:checkhealth dap-view` says no healthcheck exists

nvim-dap-view does not provide a health module. Use its commands, `g?` help, and
`:checkhealth dap` for the protocol adapters.

## Search and Git

### Snacks file or grep picker returns nothing

Check:

```vim
:echo executable('fd')
:echo executable('rg')
:pwd
```

The configured file picker includes hidden and ignored paths. Grep includes
hidden paths. A wrong working directory is more likely than an ignore rule.

### diffview+ fails to open

Run `git status` in `:pwd` and confirm the directory is a Git worktree. Git is
the only required VCS. Health warnings for absent `jj`, `hg`, or `p4` are
optional unless that VCS is intended.

The configuration tracks diffview+ main because its post-release fixes include
a guard for closing during an in-flight layout swap.

### Gitsigns hunk navigation uses native diff keys

When the current window has `diff` set, `[h` and `]h` delegate to `[c` and `]c`.
Outside diff mode they navigate Gitsigns hunks. This is expected.

## Sidekick, tmux, and worktrees

### `<leader>ii` does not open Pi

Check:

```vim
:echo executable('tmux')
:echo executable('pi')
:echo executable('lsof')
:echo executable('ps')
:pwd
```

Run Neovim inside tmux and from the intended worktree root. Sidekick's backend
is tmux and the default Pi entry is selected by name.

### Pi opens in the wrong directory

Sidekick inherits Neovim's current working directory. Check `:pwd`; do not rely
on the shell pane's directory after Neovim has changed its own cwd.

### Detaching kills or does not kill the process

`<leader>id` closes/detaches the Sidekick pane. Exit Pi itself when the process
should terminate. Reopen `<leader>ii` to attach a persistent session.

### Sidekick health complains about Copilot

NES and Copilot status are disabled. An upstream health check may still report a
missing Copilot LSP. That warning does not block CLI/tmux operation.

## External file changes

### A clean buffer did not reload

Sidekick watches directories associated with loaded buffers. `FocusGained` and
`BufEnter` schedule `:checktime` as fallback. Run `:checktime` manually and
inspect `:messages` if neither event occurred.

### `W12` appears after an agent edit

The file changed on disk while the buffer also had local edits. Neovim keeps the
dirty buffer instead of overwriting it. Compare the buffer with disk, preserve
the intended changes, and write only after resolving the conflict.

Swap files are enabled. Do not disable them to hide the warning.

## Clipboard images and input methods

### img-clip reports missing `wl-clipboard`

On Wayland, img-clip's health checker requires `wl-clipboard`. The runtime
backend can fall back to `xclip` when `DISPLAY` and XWayland are available. Check
the selected backend without printing clipboard content:

```vim
:lua print(require('img-clip.clipboard').get_clip_cmd())
```

Install `wl-clipboard` for a native Wayland path. Use `:ImgClipDebug` for command
output and `:ImgClipConfig` for the resolved `figures/` path.

### Input method does not reset

`im-select.nvim` activates only when `fcitx5-remote` is executable. Check:

```vim
:echo executable('fcitx5-remote')
```

The configured default input method is `keyboard-us`. Systems using another
input method framework need a different plugin command and state identifier.

## LaTeX, Zathura, and Wayland

### VimTeX refuses to load

Confirm Neovim is at least 0.12.4 and the filetype is `tex` or `bib`. Run:

```vim
:VimtexInfo
:VimtexLog
```

### Compilation fails

Check `latexmk`, the TeX distribution, the project root, and `build/` write
permissions. The global config does not enable unrestricted shell escape. A
project that requires it must make that trust decision explicitly.

### Forward search warns that Zathura cannot be found

On Wayland, VimTeX initialization sets Neovim's `GDK_BACKEND=x11` before it
spawns the viewer so `xdotool` can inspect Zathura. Neovim's TUI is unaffected,
but later GDK child processes can inherit the value. The initial 500 ms lookup
may still run before the window is mapped. The cosmetic warning is ignored from
normal notifications but remains in `:VimtexLog`.

Confirm `zathura`, `xdotool`, SyncTeX support, and XWayland. Trigger
`<leader>lv` again after the PDF exists.

### PDF does not refresh

After successful compile, the config sends `SIGHUP` only to a Zathura process
whose command line contains `synctex-forward`. Check Linux `/proc`, `pgrep`,
`grep`, and `kill` if that reload path fails.

## Sessions and stale state

### A session did not load on startup

Autoload is false. Use `<leader>pl` for the latest session or `<leader>pt` to
toggle the current session state.

The current commands use `:Persisted ...`. Old `:SessionSave` and related
commands do not exist in persisted.nvim v3.

### A session opens the wrong branch layout

Sessions include the Git branch. Check `:pwd`, `git branch --show-current`, and
the worktree path. Detached HEAD or a changed cwd may produce a different
session identity.

### State corruption is suspected

Move one state class at a time:

```bash
mv ~/.local/share/nvim/sessions /tmp/nvim-sessions.backup
mv ~/.local/state/nvim/undo /tmp/nvim-undo.backup
```

Do not move the whole data directory unless Lazy, Mason, parser, and session
state all need to be isolated.

## Known health output

These messages may be expected in the current design:

| Health output | Interpretation |
|---|---|
| Disabled Perl, Ruby, Python 3, or Node provider | Providers are explicitly disabled |
| Sidekick missing Copilot LSP | NES/Copilot features are disabled; CLI mode can still work |
| img-clip missing `wl-clipboard` | Native Wayland backend absent; xclip may be the runtime fallback |
| diffview missing `jj`, `hg`, `p4`, or mini.icons | Optional VCS/icon integrations |
| no healthcheck for dap-view or lsp_signature | Those plugins do not ship a provider |
| Snacks dashboard/input/picker errors in headless checks | UI hooks did not run without `UIEnter`; test interactively |
| Missing Mermaid renderer in Snacks image health | Optional image rendering, unrelated to picker/scroll/terminal |

A warning is non-blocking only when the corresponding configured user path has
been tested. Do not blanket-ignore health output.

## Reporting a reproducible problem

Include:

- Neovim version and operating environment;
- configuration commit and `git status`;
- minimal filetype/project needed to reproduce;
- exact command or key sequence;
- first error from `:messages` or headless output;
- relevant health section and executable paths.

Remove private paths, source text, credentials, and clipboard content before
sharing logs.
