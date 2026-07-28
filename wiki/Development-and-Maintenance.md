# Development and maintenance

[Home](./Home.md) | [Architecture](./Architecture-and-Customization.md) | [Troubleshooting](./Troubleshooting.md)

## Development setup

Work in a normal Git clone and keep plugin data outside the repository. The
configuration should remain usable while the worktree has uncommitted changes.

Minimum checks need Neovim 0.12.4, Stylua, Luacheck, Python 3.10+, and Git.
Feature checks need the tools for the path being changed.

The current repository style:

- tabs, width 4, and 120 columns for Lua through `stylua.toml`;
- LuaJIT runtime globals from `.luarc.json`;
- one focused plugin spec per file or language integration;
- Conventional Commits;
- signed commits when the local Git policy requires them;
- no generated backup directories or committed runtime data.

## Plugin and lockfile updates

### Restore the reviewed baseline

Use this for normal setup, CI reproduction, and recovery:

```bash
nvim --headless "+Lazy! restore" +qa
```

`restore` applies `lazy-lock.json` to Lazy itself and every locked plugin.

### Update intentionally

1. Start with a clean or understood worktree.
2. Run `:Lazy update` interactively.
3. Review every `lazy-lock.json` change.
4. Read upstream breaking changes for plugins with configuration changes.
5. Run startup, static, health, and real workflow checks.
6. Restore unrelated revisions instead of bundling them.
7. Update the Wiki when behavior, ownership, commands, or keys change.

Do not use plugin age alone as a reason to replace a stable component. A
replacement must preserve the user path or document the deliberate change.

### Verify lock and checkout state

A clean isolated restore is the most useful proof:

```bash
root="$(mktemp -d)"
mkdir -p "$root/config/nvim" "$root/data" "$root/state" "$root/cache"
rsync -a --exclude=.git --exclude=__pycache__ --exclude='*.py[cod]' ./ \
  "$root/config/nvim/"
XDG_CONFIG_HOME="$root/config" \
XDG_DATA_HOME="$root/data" \
XDG_STATE_HOME="$root/state" \
XDG_CACHE_HOME="$root/cache" \
  nvim --headless "+Lazy! restore" +qa
XDG_CONFIG_HOME="$root/config" \
XDG_DATA_HOME="$root/data" \
XDG_STATE_HOME="$root/state" \
XDG_CACHE_HOME="$root/cache" \
  nvim --headless +qa
```

This prevents a plugin already present in the normal data directory from hiding
a missing dependency or incorrect repository URL.

## Local validation

Run the static baseline from the repository root:

```bash
stylua --check --config-path=stylua.toml .
luacheck . --std luajit --max-line-length 150 --no-config --globals vim Snacks
python scripts/check_docs.py
python -m json.tool lazy-lock.json >/dev/null
git diff --check
nvim --headless +qa
```

Use `actionlint` when a workflow changes:

```bash
actionlint
```

Then run the smallest real workflow that proves the change:

| Changed area | Minimum behavioral check |
|---|---|
| LSP | Attach to a representative project file and inspect `:LspInfo` |
| completion/snippets | Trigger the source and expand a real snippet |
| formatter/linter | Verify output and unavailable-tool behavior |
| DAP | Launch an adapter, stop at a breakpoint, inspect variables, continue |
| Git | Open and close diffview+, then stage/reset a test hunk |
| Sidekick | Attach Pi in tmux, send context, observe an external file write |
| sessions | Save and load in an isolated session directory |
| LaTeX | Compile, forward-search, inspect errors, refresh Zathura |
| images | Paste or import an image in Markdown and TeX |
| comments | Comment host and injected-language nodes |

A headless startup proves only that startup completed. It does not prove LSP,
formatters, DAP, Sidekick, LaTeX, or clipboard integration.

## CI jobs

### `lint_code.yml`

- Luacheck scans the repository with LuaJIT globals.
- The smoke job installs Neovim 0.12.4, symlinks the repository to
  `~/.config/nvim`, runs `Lazy! restore`, and starts headless Neovim.

### `style_check.yml`

- Stylua 2.4.1 verifies Lua formatting.
- The documentation job runs `python scripts/check_docs.py` without external
  packages.

Dependabot checks GitHub Actions weekly. It does not update Neovim plugins.

## Documentation ownership

The documentation system has three layers:

| Layer | Responsibility |
|---|---|
| `README.md` | Positioning, quick start, high-value entry points, documentation map |
| `wiki/*.md` | Reviewable long-form source with normal `.md` links and one H1 per page |
| `scripts/render_wiki.py` | GitHub Wiki output: slug links and no duplicate page H1 |
| Lua and lock files | Executable behavior and exact revisions |

`wiki/` is the canonical source for the future GitHub Wiki. Do not maintain a
second hand-edited copy.

### Page responsibilities

| Page | Owns |
|---|---|
| `Getting-Started.md` | Support, requirements, install, first run, restore, removal |
| `Architecture-and-Customization.md` | Startup, state, settings, plugin catalog, extension boundaries |
| `Features-and-Workflows.md` | Intent and normal task sequences |
| `Language-Tooling.md` | Language capability and tool ownership matrix |
| `Keymap-Reference.md` | Repository-defined mappings |
| `Troubleshooting.md` | Symptoms, diagnostic commands, known health output |
| `Development-and-Maintenance.md` | Updates, CI, docs policy, Wiki publishing |

Avoid copying a full table into another page. Link to the owning page and state
only the context needed for the current workflow.

### Documentation checks

`scripts/check_docs.py` performs deterministic checks:

- local Markdown link targets exist;
- every substantive Wiki page has one H1;
- `_Sidebar.md` links every substantive page;
- no content page is orphaned;
- the architecture catalog exactly matches `lua/plugins/**/*.lua` spec paths;
- `snips/package.json` exactly matches the repository snippet JSON files;
- the rendered Wiki has the same files, valid slug links and anchors, and no
  duplicate page H1.

It deliberately does not fetch external links during normal CI. Network health
should not make an otherwise valid pull request fail.

## Change-to-documentation matrix

| Configuration change | Review these pages |
|---|---|
| Neovim version, bootstrap, install command | README, Getting started, Maintenance |
| `settings.lua`, options, autocmds | Architecture, Language tooling, Troubleshooting |
| plugin addition/removal or ownership | Architecture catalog, Workflows, Maintenance |
| user mapping | Keymap reference and the owning workflow |
| LSP, parser, completion, snippet | Language tooling, Keymaps, Troubleshooting |
| formatter, linter, DAP adapter | Language tooling, Workflows, Troubleshooting |
| Sidekick, tmux, session behavior | Workflows, Keymaps, Troubleshooting |
| Git review behavior | Workflows, Keymaps |
| LaTeX, Markdown, image behavior | Workflows, Language tooling, Troubleshooting |
| expected health warning | Troubleshooting |

## Adding or removing a feature

Use this review order:

1. Name the user-visible outcome and current owner.
2. Check whether an installed component already provides it.
3. Choose the narrowest lazy-load trigger.
4. Avoid concurrent writers for the same file or logical area.
5. Preserve current keys unless a conflict requires a migration.
6. Test the real path, including external executable failure.
7. Update the owning documentation page and plugin catalog.
8. Review lock changes and startup time.

For plugin replacement, test both removal and replacement. A stale checkout can
make the new configuration appear to work even when the old plugin is still
supplying a command.

## Compatibility review

Before raising the Neovim minimum:

- read the target release notes and deprecated API list;
- restore all locked plugins under the target version;
- load every configured plugin once;
- run `:checkhealth vim.deprecated` after loading them;
- verify VimTeX, LSP attach, DAP, Treesitter, Sidekick, external changes, and
  formatting;
- update CI and both installation pages in the same change.

Do not describe a development-branch feature as present in a released Neovim
version without testing the installed runtime files.

## Publishing to GitHub Wiki

GitHub creates the separate Wiki repository only after an initial Wiki page
exists. At the time this documentation was written,
`https://github.com/jczhang02/nvim.wiki.git` was not initialized.

After enabling Wiki and creating its first page:

```bash
python scripts/check_docs.py

wiki_publish="$(mktemp -d)"
wiki_checkout="$(mktemp -d)"
python scripts/render_wiki.py "$wiki_publish"
git clone git@github.com:jczhang02/nvim.wiki.git "$wiki_checkout"
rsync -a --delete --exclude=.git "$wiki_publish/" "$wiki_checkout/"
diff -ru --exclude=.git "$wiki_publish/" "$wiki_checkout/"

git -C "$wiki_checkout" status --short
git -C "$wiki_checkout" add --all
git -C "$wiki_checkout" commit -S -m "docs(wiki): sync from nvim main"
git -C "$wiki_checkout" push origin HEAD
```

The renderer removes each source H1 because GitHub Wiki supplies the page title,
and converts local `Page.md` links to Wiki-native `Page` slugs. The documentation
check validates both source and rendered forms; `diff` proves the checkout
matches the rendered staging directory. Review the `rsync` destination and
`git status` before committing. The `--exclude=.git` guard is required when
`--delete` is present.

Publication is one-way from the main repository:

1. edit and review files under `wiki/`;
2. merge them into `main`;
3. render `wiki/` into a temporary publication directory;
4. copy the rendered files to the Wiki checkout;
5. record the source repository commit in the Wiki commit body when useful;
6. avoid edits through the Wiki web UI because the next sync will overwrite
   them.

A future publication workflow should use a manually approved trigger, minimal
write credentials, a concurrency lock, and no-op behavior when content did not
change. Creating that external write path requires a separate authorization.

## Review checklist

Before reporting a documentation/configuration change complete:

- [ ] Every explicit requirement maps to a changed file or verified behavior.
- [ ] README stays a quick entry rather than a second Wiki.
- [ ] The owning Wiki page contains the detail once.
- [ ] Internal links and sidebar coverage pass `scripts/check_docs.py`.
- [ ] Plugin and snippet catalogs match the repository.
- [ ] Lua, JSON, workflow, and diff checks pass.
- [ ] Clean headless restore/start passes.
- [ ] User-visible workflows changed by the diff were tested directly.
- [ ] Known warnings and untested external paths are reported plainly.
- [ ] Nothing is staged, committed, or pushed without the requested authority.
