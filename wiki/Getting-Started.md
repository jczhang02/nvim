# Getting started

[Home](./Home.md) | [Language tooling](./Language-Tooling.md) | [Troubleshooting](./Troubleshooting.md)

## Support policy

The configuration is developed and tested on Linux with Neovim 0.12.4, tmux,
Git, and a Nerd Font. CI starts a clean Neovim 0.12.4 instance on Ubuntu and
restores the exact plugin lock.

Other Unix-like systems may run the core editor, but several integrations are
Linux-specific:

- `/usr/bin/mise` is the only path used for automatic mise environment import.
- Sidekick expects tmux plus `lsof` and `ps`.
- input-method switching uses `fcitx5-remote` when available.
- the LaTeX viewer workflow uses Zathura, XWayland, `xdotool`, `/proc`, and
  standard process tools.
- clipboard image paste expects `xclip` or `wl-clipboard`.

Windows is not a supported target for this repository.

## Requirements by feature

### Core editor

| Requirement | Why it is needed |
|---|---|
| Neovim 0.12.4 or newer | Native LSP API and the locked plugin baseline |
| Git | Plugin restore, Fugitive, Gitsigns, diffview+, and worktrees |
| C compiler and `make` | Treesitter parser builds and LuaSnip `jsregexp` |
| Nerd Font | Icons in status, picker, explorer, completion, and DAP views |
| `rg` | Live grep, grep command, TODO search, and project search |
| `fd` | Fast file discovery in Snacks picker |

### Optional features

| Feature | Commands or packages |
|---|---|
| Agent workflow | `tmux`, `pi`, `lsof`, `ps` |
| Git terminal UI | `lazygit` |
| Clipboard images | `wl-paste`/`wl-copy` on Wayland, or `xclip` on X11/XWayland |
| Input method reset | `fcitx5-remote` |
| LaTeX | `latexmk`, a TeX distribution, Zathura, `xdotool`, `pgrep`, `grep`, `kill` |
| C/C++ and Rust debugging | codelldb, installed by Mason when DAP first loads |
| Go debugging | `dlv` on `PATH` |
| Python debugging | `debugpy-adapter` on `PATH` |
| Language intelligence | The servers and tools listed in [Language tooling](./Language-Tooling.md) |

Missing optional tools do not prevent Neovim from starting. Their commands will
fail or remain unavailable until the executable is installed.

## Protect an existing installation

The repository assumes ownership of the Neovim configuration directory. Move
an existing configuration before cloning:

```bash
if [ -e "${XDG_CONFIG_HOME:-$HOME/.config}/nvim" ]; then
  mv "${XDG_CONFIG_HOME:-$HOME/.config}/nvim" \
     "${XDG_CONFIG_HOME:-$HOME/.config}/nvim.backup"
fi
```

Plugin data, undo files, sessions, logs, and caches live outside the config
directory. Back them up separately if the existing installation matters:

```bash
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.local/state/nvim ~/.local/state/nvim.backup
mv ~/.cache/nvim ~/.cache/nvim.backup
```

Only move directories that exist. Keeping the data directory is possible, but a
fresh data directory gives the clearest first-run result.

## Install

Clone over HTTPS:

```bash
git clone https://github.com/jczhang02/nvim.git \
  "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
```

SSH is equivalent when GitHub credentials are configured:

```bash
git clone git@github.com:jczhang02/nvim.git \
  "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
```

Restore the locked plugin set:

```bash
nvim --headless "+Lazy! restore" +qa
```

Use `restore`, not `install`, for reproducibility. The Lazy bootstrap initially
clones Lazy's stable branch; `Lazy! restore` then moves Lazy itself and every
other plugin to the revisions recorded in `lazy-lock.json`.

Start the editor:

```bash
nvim
```

## First interactive launch

The first launch performs work that a headless restore intentionally skips:

1. Treesitter installs the parsers listed in `lua/config/settings.lua` under
   Neovim's data directory.
2. Startup plugins initialize Catppuccin, Snacks, Treesitter, and smart-splits.
3. Feature plugins remain unloaded until their event, command, filetype, or key
   is used.
4. Loading DAP initializes Mason and ensures codelldb is installed. Mason does
   not install the other adapters.

Parser and codelldb installation may continue briefly. Inspect progress with
`:Lazy` and `:Mason` instead of exiting immediately.

## Tool environment

At startup, `init.lua` checks the fixed path `/usr/bin/mise`. When that file is
executable, Neovim imports `mise env --json` before loading plugins. This keeps
Neovim and shell-launched agents on the same `PATH`.

If mise is installed elsewhere, one of these must be true:

- the shell already exports every required tool before Neovim starts;
- `/usr/bin/mise` points to the installed binary;
- `init.lua` is adjusted to the local path.

The machine used to develop this config keeps its mise tool list in
`~/.config/mise/config.toml`. That file is outside this repository. A clone must
supply equivalent tools through its own mise configuration or system packages.

Mason uses `PATH = "skip"`. It will not prepend its bin directory or shadow
mise/system executables. The one exception is codelldb, whose absolute Mason
path is configured in `lua/plugins/dap.lua`.

## Verify the installation

Run these outside Neovim:

```bash
nvim --version | head -n 1
nvim --headless "+Lazy! restore" +qa
nvim --headless +qa
```

Run these inside Neovim:

```vim
:checkhealth
:Lazy
:Mason
```

Then open one file in a configured language and inspect the active components:

```vim
:LspInfo
:ConformInfo
:checkhealth dap
```

Useful feature checks:

| Feature | Check |
|---|---|
| Search | `<leader>ff`, then `<leader>fg` |
| Neo-tree | `<leader>e` |
| Git | Open a tracked file and run `<leader>gd` |
| Sidekick | Start from a tmux worktree and run `<leader>ii` |
| Python LSP | Open a Python file and inspect `:LspInfo` for `pyright` and `ruff` |
| DAP | Run `:checkhealth dap` after a DAP command has loaded the plugin |
| LaTeX | Open a TeX file and run `:VimtexInfo` |
| Images | Run `:ImgClipConfig` and `:ImgClipDebug` after `<leader>pi` |

Known non-blocking health output is documented in
[Troubleshooting](./Troubleshooting.md#known-health-output).

## Update, restore, and roll back

Pull configuration changes and return plugins to the committed lock:

```bash
cd "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
git pull --ff-only
nvim --headless "+Lazy! restore" +qa
```

`:Lazy update` is different. It intentionally fetches newer revisions and
changes `lazy-lock.json`. Use it only when the lock change will be reviewed and
committed with verification.

To discard an accidental plugin update:

```bash
git restore lazy-lock.json
nvim --headless "+Lazy! restore" +qa
```

To roll back the whole configuration, check out a known commit and restore:

```bash
git checkout <known-commit>
nvim --headless "+Lazy! restore" +qa
```

See [Development and maintenance](./Development-and-Maintenance.md#plugin-and-lockfile-updates)
for the full update checklist.

## Remove or reset

Move the directories instead of deleting them until the replacement has been
verified:

```bash
mv "${XDG_CONFIG_HOME:-$HOME/.config}/nvim" /tmp/nvim-config.backup
mv "${XDG_DATA_HOME:-$HOME/.local/share}/nvim" /tmp/nvim-data.backup
mv "${XDG_STATE_HOME:-$HOME/.local/state}/nvim" /tmp/nvim-state.backup
mv "${XDG_CACHE_HOME:-$HOME/.cache}/nvim" /tmp/nvim-cache.backup
```

Neovim recreates data, state, and cache directories on the next launch. The
configuration directory must be restored or replaced before that launch.

## Next steps

- Read [Features and workflows](./Features-and-Workflows.md) for normal use.
- Keep [Keymap reference](./Keymap-Reference.md) open during the first sessions.
- Use [Language tooling](./Language-Tooling.md) to install only the tools needed
  by the projects on the machine.
