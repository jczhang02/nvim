# Keymap reference

[Home](./Home.md) | [Workflows](./Features-and-Workflows.md) | [Troubleshooting](./Troubleshooting.md)

This page covers mappings defined or enabled by this repository. Plugin buffers
may expose additional context-specific mappings. Use their `g?` help where
available.

## Notation and discovery

- `<leader>` is Space.
- `<localleader>` is comma.
- Modes: N normal, I insert, V visual, O operator-pending, T terminal, C command.
- A comma-separated mode list means the same mapping exists in each mode.

| Key | Action |
|---|---|
| `<leader>?` | Show Which-key mappings for the current buffer |
| `<leader>fk` | Search all keymaps with Snacks |
| `<C-p>` | Open the legacy keymap panel |
| `:verbose map {lhs}` | Show the winning mapping and its source |
| `g?` | Show local help in Neo-tree, diffview+, nvim-dap-view, and similar views |

Runtime output wins over this page when a plugin changes a mapping.

## Core editing

Source: `lua/config/keymaps.lua`.

| Mode | Key | Action |
|---|---|---|
| I | `jk` | Leave insert mode |
| N | `<Esc>` | Clear search highlighting |
| N | `<C-s>` | Save |
| I | `<C-s>` | Save and remain in insert mode |
| N | `<C-q>` | Save and quit |
| I | `<C-q>` | Save, quit, and leave insert mode |
| N | `<A-S-q>` | Quit without saving |
| V | `J` | Move selection down and reindent |
| V | `K` | Move selection up and reindent |
| V | `<` / `>` | Indent and reselect |
| V | `p` | Paste without replacing the unnamed register |
| N,V | `<leader>y` | Yank to the system clipboard |
| N | `<leader>Y` | Yank the line to the system clipboard |
| N | `Y` | Yank to end of line |
| N | `D` | Delete to end of line |
| N | `J` | Join the next line without moving the cursor |
| N | `<S-Tab>` | Toggle the fold under the cursor |
| N | `<leader>o` | Toggle English spell checking in the buffer |
| I | `<C-u>` | Delete the previous insert block with an undo break |
| I | `<C-b>` | Move one character left |
| I | `<C-a>` | Move to the first column and resume insert |

Search keys `n`, `N`, `*`, `#`, `g*`, and `g#` start hlslens after it loads.
`n` and `N` are count-aware. The initial global mappings also center ordinary
search jumps before hlslens replaces them.

## Command-line editing

Source: `lua/config/keymaps.lua`.

| Mode | Key | Action |
|---|---|---|
| C | `<C-b>` / `<C-f>` | Move left / right |
| C | `<C-a>` / `<C-e>` | Move to start / end |
| C | `<C-d>` | Delete the character under the cursor |
| C | `<C-h>` | Backspace |
| C | `<C-t>` | Insert the current file's directory and a slash |

## Tool buffers

Source: `lua/config/autocmds.lua`.

| Mode | Key | Action |
|---|---|---|
| N | `q` | Close `qf`, help, man, LSP info, health, notification, Trouble, and diffview+ file windows |

The mapping is buffer-local and does not replace normal `q` macro recording in
ordinary editing buffers.

## Diagnostics

Global diagnostic mappings work without an LSP-specific attach mapping.

| Mode | Key | Action |
|---|---|---|
| N | `[d` / `]d` | Previous / next diagnostic |
| N | `<leader>cd` | Open diagnostic float |

LSP-specific diagnostic keys are listed under
[LSP and diagnostics](#lsp-and-diagnostics).

## Buffers

Sources: `lua/config/keymaps.lua`, `lua/plugins/bufferline.lua`, and
`lua/plugins/snacks.lua`.

| Mode | Key | Action |
|---|---|---|
| N | `<S-h>` / `<S-l>` | Previous / next buffer |
| N | `[b` / `]b` | Previous / next Bufferline item |
| N | `<A-o>` / `<A-i>` | Previous / next Bufferline item |
| N | `<A-S-o>` / `<A-S-i>` | Move buffer left / right |
| N | `<A-1>` through `<A-9>` | Select buffer by position |
| N | `<leader>bn` | Create an empty buffer |
| N | `<leader>bd` | Delete the current buffer with Snacks |
| N | `<leader>bD` | Delete all other buffers |
| N | `<A-q>` | Delete the current buffer |
| N | `<leader>bp` | Pin or unpin the current buffer |
| N | `<leader>bP` | Close all non-pinned buffers |
| N | `<leader>bs` | Sort buffers by directory |
| N | `<leader>be` | Open Neo-tree's buffer source |

## Windows and tabs

Sources: `lua/config/keymaps.lua` and `lua/plugins/smart-splits.lua`.

| Mode | Key | Action |
|---|---|---|
| N | `<C-h/j/k/l>` | Move left/down/up/right, including across tmux panes |
| N | `<A-h/j/k/l>` | Resize left/down/up/right |
| N | `<leader>Wh/Wj/Wk/Wl` | Swap the buffer with a neighboring window |
| N | `<leader>wh/wj/wk/wl` | Native window movement |
| N | `<leader>ws` / `<leader>wv` | Horizontal / vertical split |
| N | `<leader>wc` | Close the window |
| N | `<leader>wo` | Keep only the current window |
| N | `<leader>tn` | New tab |
| N | `<leader>tc` | Close tab |
| N | `<leader>to` | Keep only the current tab |
| N | `<leader>tl` / `<leader>th` | Next / previous tab |
| N | `tn` / `tk` / `tj` / `to` | Legacy tab new/next/previous/only |

## Files, picker, and explorer

Sources: `lua/plugins/snacks.lua`, `lua/plugins/neo-tree.lua`, and
`lua/plugins/dropbar.lua`.

| Mode | Key | Action |
|---|---|---|
| N | `<leader>ff` | Find files |
| N | `<leader>fg` | Live grep |
| N | `<leader>fb` | Select an open buffer |
| N | `<leader>fr` | Recent files |
| N | `<leader>fc` | Command history |
| N | `<leader>fh` | Help tags |
| N | `<leader>fs` | LSP symbols in the current buffer |
| V | `<leader>fs` | Grep the visual selection/current word |
| N | `<leader>fw` | Workspace LSP symbols |
| N | `<leader>fd` | Diagnostics picker |
| N | `<leader>fu` | Undo tree picker |
| N | `<leader>fp` | Project picker |
| N | `<leader>fk` | Keymap picker |
| N | `<leader>e` / `<C-n>` | Toggle Neo-tree |
| N | `<leader>fE` | Reveal the current file in Neo-tree |
| N | `<leader>ge` | Open Neo-tree Git status |
| N | `<leader>;` | Open Dropbar picker |

Neo-tree local mappings:

| Key | Action |
|---|---|
| `o` / `l` | Open node |
| `h` | Close node |
| `P` | Toggle floating preview |
| `Y` | Copy node to clipboard |
| `<C-v>` / `<C-x>` | Open vertical / horizontal split |
| `<Space>` | Disabled so leader does not trigger a tree action |

## Jump and structural movement

Sources: `lua/plugins/flash.lua` and `lua/plugins/treesitter.lua`.

| Mode | Key | Action |
|---|---|---|
| N,V,O | `s` | Flash jump |
| N,V,O | `S` | Flash Treesitter selection |
| O | `r` | Remote Flash operation |
| V,O | `R` | Treesitter search |
| N,V | `<leader>jw` | Jump to word |
| N,V | `<leader>jj` / `<leader>jk` | Jump to line |
| N,V | `<leader>jc` | One-character jump mode |
| N,V | `<leader>jC` | General/two-character jump |
| V,O | `af` / `if` | Outer / inner function textobject |
| V,O | `ac` / `ic` | Outer / inner class textobject |
| N | `<leader>za` / `<leader>zA` | Swap next inner / outer parameter |
| N,V,O | `][` / `]]` | Next function start / end |
| N,V,O | `[[` / `[]` | Previous function start / end |
| N,V,O | `]m` / `]M` | Next class start / end |
| N,V,O | `[m` / `[M` | Previous class start / end |
| N,V,O | `;` | Repeat the last Treesitter move forward |

## LSP and diagnostics

Source: buffer-local mappings created by `lua/plugins/lsp.lua` after
`LspAttach`.

| Mode | Key | Action |
|---|---|---|
| N | `gd` | Go directly to definition |
| N | `gD` | Pick definitions |
| N | `gi` | Pick implementations |
| N | `gm` | Go directly to implementation |
| N | `gy` | Pick type definitions |
| N | `gh` | Pick references |
| N | `gr` / `gR` | Rename symbol |
| N,V | `ga` | Code action |
| N | `gs` | Signature help |
| I | `<C-k>` | Signature help |
| N | `K` | Hover |
| N | `go` | Trouble symbols at the right |
| N | `gto` | Symbol picker |
| N | `g[` / `g]` | Previous / next diagnostic |
| N | `gci` / `gco` | Incoming / outgoing calls |
| N | `gt` | Toggle Trouble diagnostics |
| N | `<leader>rn` | Rename |
| N,V | `<leader>ca` | Code action |
| N | `<leader>li` | LSP info |
| N | `<leader>lr` | Restart LSP clients |
| N | `<leader>lx` | Current-line diagnostic float |
| N | `<leader>lw` | Workspace diagnostics |
| N | `<leader>ld` | Document diagnostics |
| N | `<leader>lh` | Toggle inlay hints |
| N | `<leader>lv` | Toggle tiny inline diagnostics |
| N | `<leader>lpd` | Pick definitions |
| N | `<leader>lpr` | Pick references |
| N | `<leader>lpi` | Pick implementations |
| N | `<leader>lpt` | Pick type definitions |

Trouble mappings:

| Mode | Key | Action |
|---|---|---|
| N | `<leader>xx` | Workspace diagnostics |
| N | `<leader>xX` | Current-buffer diagnostics |
| N | `<leader>xs` | Symbols |
| N | `<leader>xl` | LSP definitions/references view |
| N | `<leader>xL` | Location list |
| N | `<leader>xQ` | Quickfix list |

## Completion and snippets

Source: `lua/plugins/blink.lua`.

| Mode | Key | Action |
|---|---|---|
| I | `<C-n>` / `<C-p>` | Next / previous completion item |
| I | `<C-d>` / `<C-f>` | Scroll documentation up / down |
| I | `<C-w>` | Hide completion |
| I | `<Tab>` | Jump forward in snippet, else select next item |
| I | `<S-Tab>` | Jump backward in snippet, else select previous item |
| I | `<CR>` | Accept selected item, otherwise normal Enter |

Command-line completion uses Blink's command-line preset.

## Formatting, refactoring, and code tools

| Mode | Key | Action | Source |
|---|---|---|---|
| N,V | `<leader>cf` | Format buffer or range | Conform |
| N,V | `<A-S-f>` | Format buffer or range | Conform |
| N | `<A-f>` | Toggle save formatting for this buffer | Conform |
| N | `<leader>cm` | Open Mason | LSP config |
| N | `<leader>cM` | Update Mason registry | LSP config |
| N | `<leader>cR` | Rust code action | rustaceanvim, Rust buffer |
| N | `<leader>cE` | Explain Rust error | rustaceanvim, Rust buffer |
| N | `<leader>sr` | Open project search and replace | grug-far |
| N | `<leader>Ss` | Legacy search and replace panel | grug-far |
| N | `<leader>Sp` | Search/replace word in project | grug-far |
| V | `<leader>Sp` | Search/replace visual selection | grug-far |
| N | `<leader>Sf` | Search/replace in current file | grug-far |
| N | `g?p` / `g?P` | Insert debug print below / above | debugprint |
| N,V | `ga` | Start mini.align | mini.align default |
| N,V | `gA` | Start mini.align with preview | mini.align default |

nvim-surround keeps its standard mappings such as `ys`, `ds`, and `cs`. Use
`:help nvim-surround.usage` for its complete grammar.

## Git

Sources: `lua/plugins/gitsigns.lua`, `lua/plugins/diffview.lua`,
`lua/plugins/fugitive.lua`, and `lua/plugins/snacks.lua`.

| Mode | Key | Action |
|---|---|---|
| N | `[h` / `]h` | Previous / next Gitsigns hunk, or native diff hunk |
| N,V | `<leader>ghs` | Stage hunk |
| N,V | `<leader>ghr` | Reset hunk |
| N | `<leader>ghp` | Preview hunk |
| N | `<leader>ghb` | Full blame for line |
| N | `<leader>ghd` | Diff current file |
| N | `<leader>ghD` | Diff against `HEAD~` |
| N | `<leader>gd` | Open diffview+ |
| N | `<leader>gD` | Close diffview+ |
| N | `<leader>gh` | File history |
| N | `<leader>gg` | Floating lazygit |
| N | `<leader>gB` | Fugitive blame |
| N | `<leader>gG` | Fugitive status/interface |
| N | `<leader>gP` | Git push |
| N | `gps` / `gpl` | Legacy Git push / pull |

## DAP

Source: `lua/plugins/dap.lua`.

| Mode | Key | Action |
|---|---|---|
| N | `<leader>dc` | Start or continue |
| N | `<leader>db` | Toggle breakpoint |
| N | `<leader>dB` | Conditional breakpoint |
| N | `<leader>di` | Step into |
| N | `<leader>do` | Step over |
| N | `<leader>dO` | Step out |
| N | `<leader>dt` | Terminate |
| N | `<leader>dr` | Toggle REPL |
| N | `<leader>du` | Toggle nvim-dap-view |
| N | `<leader>dC` | Close view and terminal |
| N,V | `<leader>dh` | Hover expression or visual selection |
| N,V | `<leader>dw` | Add expression or visual selection to watches |
| N | `<leader>dv` | Toggle inline DAP values |
| N | `<leader>dx` | Run to cursor |
| N | `<leader>dL` | Run last configuration |
| N | `<leader>dR` | Open REPL |
| N | `<F6>` | Continue |
| N | `<F7>` | Stop |
| N | `<F8>` | Toggle breakpoint |
| N | `<F9>` | Step into |
| N | `<F10>` | Step out |
| N | `<F11>` | Step over |

Inside nvim-dap-view, use `B`, `S`, `E`, `W`, `T`, and `R` for the named
sections shown in its winbar. `g?` lists the active local mappings.

## Terminal and commands

| Mode | Key | Action |
|---|---|---|
| N,I,T | `<C-\>` | Toggle default Snacks terminal |
| N,I,T | `<A-\>` | Toggle right-side terminal |
| N,I,T | `<F5>` | Toggle right-side terminal |
| N,I,T | `<A-d>` | Toggle floating terminal |
| T | `<Esc><Esc>` | Enter terminal normal mode |
| T | `<C-w>h/j/k/l` | Move to neighboring window |
| N | `<leader>ar` | Start an AsyncRun command line |

## Sidekick and Pi

Source: `lua/plugins/sidekick.lua`.

| Mode | Key | Action |
|---|---|---|
| N | `<leader>ii` | Start or attach Pi |
| N | `<leader>is` | Select installed CLI/session |
| N | `<leader>if` | Send current file reference |
| V | `<leader>iv` | Send visual selection |
| N,V | `<leader>it` | Send current context |
| N,V | `<leader>ip` | Select prompt |
| N | `<leader>id` | Detach CLI pane |

## Sessions, images, and documents

| Mode | Key | Action |
|---|---|---|
| N | `<leader>ps` | Save persisted session |
| N | `<leader>pl` | Load most recent session |
| N | `<leader>pt` | Toggle session state |
| N | `<leader>ss` | Legacy session save |
| N | `<leader>sl` | Legacy current session load |
| N | `<leader>sd` | Legacy session delete picker |
| N | `<leader>pi` | Paste clipboard image |
| N | `<F1>` | Toggle Markdown rendering |
| N | `<leader>st` | TODO picker |
| N | `[t` / `]t` | Previous / next TODO |

### VimTeX

These mappings are active for TeX and BibTeX buffers.

| Key | Action |
|---|---|
| `<leader>ll` | Toggle continuous compile |
| `<leader>lL` | Single-shot compile |
| `<leader>lv` | View PDF / forward search |
| `<leader>lk` / `<leader>lK` | Stop current / all compilers |
| `<leader>lc` / `<leader>lC` | Clean auxiliary files / clean including PDF |
| `<leader>le` | Errors quickfix |
| `<leader>lo` | Compiler output |
| `<leader>lt` / `<leader>lT` | Open / toggle table of contents |
| `<leader>lq` | VimTeX log |
| `<leader>ls` / `<leader>lS` | Current / all status |
| `<leader>lr` / `<leader>lR` | Reload plugin / state |
| `<leader>li` / `<leader>lI` | Brief / full info |
| `<leader>la` | VimTeX context menu |

The `<leader>l...` namespace is context-sensitive. LSP mappings occupy some of
the same suffixes in LSP-attached buffers; TeX currently has no enabled LSP
client, so the VimTeX mappings win there.

## Notifications, profiling, packages, and elevated writes

| Mode | Key | Action |
|---|---|---|
| N | `<leader>n.` | Open scratch buffer |
| N | `<leader>nh` | Notification history |
| N | `<leader>nd` | Dismiss notifications |
| N | `<leader>hpb` / `<leader>hps` | Start / stop Snacks profiler |
| N | `<A-s>` | Elevated write through suda.vim |
| N | `<leader>Ph` | Open Lazy UI |
| N | `<leader>Ps` | Lazy sync |
| N | `<leader>Pu` | Lazy update |
| N | `<leader>Pi` | Lazy install |
| N | `<leader>Pl` | Lazy log |
| N | `<leader>Pc` | Lazy check |
| N | `<leader>Pp` | Lazy profile |
| N | `<leader>Pr` | Lazy restore |
| N | `<leader>Px` | Lazy clean |

## Conflict and precedence notes

Mappings can share the same keys when their modes or buffer scope differ:

- `ga` is mini.align globally, but an attached LSP maps normal and visual `ga`
  to code action. Use `gA` for alignment in an LSP buffer.
- normal `<C-k>` moves to the split above; insert `<C-k>` opens signature help.
- normal `<C-p>` opens the keymap panel; insert `<C-p>` selects the previous
  completion item.
- VimTeX and LSP use several `<leader>l...` suffixes. VimTeX owns them in TeX
  buffers because no TeX LSP is enabled.
- `<leader>gh` is diffview+ file history and is also a prefix for Gitsigns hunk
  actions. Neovim waits up to `timeoutlen` for a longer suffix.

Use `:verbose map` with the relevant mode and buffer when adding a mapping to one
of these namespaces.

## Legacy mapping policy

Legacy aliases remain when they are muscle-memory shortcuts and do not hide a
newer mapping. They are marked in this page. New documentation should use the
leader-based primary mapping.

Before deleting an alias:

1. search this page and the Lua source;
2. check `:verbose map` in each relevant mode;
3. verify no which-key group or plugin buffer depends on the prefix;
4. remove the alias and documentation in the same change.
