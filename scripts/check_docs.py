#!/usr/bin/env python3
"""Validate the repository-local README and Wiki source."""

from pathlib import Path
from tempfile import TemporaryDirectory
from urllib.parse import unquote, urlsplit
import json
import re

from render_wiki import render_wiki

ROOT = Path(__file__).resolve().parents[1]
WIKI = ROOT / "wiki"
README = ROOT / "README.md"
SIDEBAR = WIKI / "_Sidebar.md"
CATALOG = WIKI / "Architecture-and-Customization.md"
SNIPPET_MANIFEST = ROOT / "snips/package.json"
LINK_RE = re.compile(r"!?\[[^\]]*\]\(([^)]+)\)")
HTML_LINK_RE = re.compile(r'(?:href|src)="([^"]+)"')
CONTENT_NAME_RE = re.compile(r"^[A-Za-z0-9]+(?:-[A-Za-z0-9]+)*\.md$")
CATALOG_SECTION_RE = re.compile(
    r"^## Plugin catalog\s*$\n(.*?)(?=^##\s|\Z)", re.MULTILINE | re.DOTALL
)
CATALOG_PATH_RE = re.compile(r"^\|\s*`(lua/plugins/[^`]+\.lua)`\s*\|", re.MULTILINE)


def without_fenced_code(text: str) -> str:
    """Return Markdown text without fenced code blocks."""
    kept: list[str] = []
    in_fence = False
    fence = ""

    for line in text.splitlines():
        stripped = line.lstrip()
        if stripped.startswith(("```", "~~~")):
            marker = stripped[:3]
            if not in_fence:
                in_fence = True
                fence = marker
            elif marker == fence:
                in_fence = False
                fence = ""
            continue
        if not in_fence:
            kept.append(line)

    text_without_fences = "\n".join(kept)
    return re.sub(r"`[^`\n]*`", "", text_without_fences)


def markdown_links(path: Path) -> list[str]:
    """Extract Markdown and HTML link targets outside fenced code blocks."""
    text = without_fenced_code(path.read_text(encoding="utf-8"))
    markdown = [match.group(1).strip().strip("<>") for match in LINK_RE.finditer(text)]
    html = [match.group(1).strip() for match in HTML_LINK_RE.finditer(text)]
    return [*markdown, *html]


def resolve_local_link(source: Path, target: str) -> Path | None:
    """Resolve a local Markdown target, or return None for external links."""
    parsed = urlsplit(target)
    if parsed.scheme or parsed.netloc or target.startswith(("mailto:", "tel:")):
        return None
    if not parsed.path:
        return source.resolve() if parsed.fragment else None

    decoded = unquote(parsed.path)
    resolved = (source.parent / decoded).resolve()
    return resolved


def heading_anchors(path: Path) -> set[str]:
    """Return GitHub-style anchors for Markdown headings in a file."""
    anchors: set[str] = set()
    counts: dict[str, int] = {}
    body = without_fenced_code(path.read_text(encoding="utf-8"))

    for line in body.splitlines():
        match = re.match(r"^#{1,6}\s+(.+?)\s*#*\s*$", line)
        if not match:
            continue
        title = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", match.group(1))
        slug = re.sub(r"[^\w\s-]", "", title.lower())
        slug = re.sub(r"[\s-]+", "-", slug).strip("-")
        count = counts.get(slug, 0)
        counts[slug] = count + 1
        anchors.add(slug if count == 0 else f"{slug}-{count}")

    return anchors


def substantive_pages() -> list[Path]:
    """Return normal Wiki pages, excluding GitHub Wiki special files."""
    return sorted(path for path in WIKI.glob("*.md") if not path.name.startswith("_"))


def check_links(documents: list[Path], errors: list[str]) -> None:
    """Check that every local Markdown target and heading anchor exists."""
    anchor_cache: dict[Path, set[str]] = {}

    for document in documents:
        for target in markdown_links(document):
            parsed = urlsplit(target)
            resolved = resolve_local_link(document, target)
            if resolved is None:
                continue
            if not resolved.is_relative_to(ROOT):
                errors.append(
                    f"{document.relative_to(ROOT)}: link leaves repository: {target}"
                )
            elif not resolved.exists():
                errors.append(
                    f"{document.relative_to(ROOT)}: missing link target: {target}"
                )
            elif parsed.fragment and resolved.suffix.lower() == ".md":
                anchors = anchor_cache.setdefault(resolved, heading_anchors(resolved))
                anchor = unquote(parsed.fragment).lower()
                if anchor not in anchors:
                    errors.append(
                        f"{document.relative_to(ROOT)}: missing heading anchor: {target}"
                    )


def check_wiki_structure(pages: list[Path], errors: list[str]) -> None:
    """Check page names, H1 headings, and sidebar coverage."""
    for page in pages:
        if not CONTENT_NAME_RE.fullmatch(page.name):
            errors.append(f"wiki page name is not portable: {page.name}")

        body = without_fenced_code(page.read_text(encoding="utf-8"))
        h1_count = sum(line.startswith("# ") for line in body.splitlines())
        if h1_count != 1:
            errors.append(
                f"{page.relative_to(ROOT)}: expected one H1, found {h1_count}"
            )

    sidebar_targets = {
        resolved
        for target in markdown_links(SIDEBAR)
        if (resolved := resolve_local_link(SIDEBAR, target)) is not None
    }
    for page in pages:
        if page.resolve() not in sidebar_targets:
            errors.append(f"{page.relative_to(ROOT)}: not linked from wiki/_Sidebar.md")


def check_plugin_catalog(errors: list[str]) -> None:
    """Require an exact match between plugin specs and catalog paths."""
    catalog = CATALOG.read_text(encoding="utf-8")
    section = CATALOG_SECTION_RE.search(catalog)
    if section is None:
        errors.append("architecture page has no Plugin catalog section")
        return

    documented = set(CATALOG_PATH_RE.findall(section.group(1)))
    actual = {
        spec.relative_to(ROOT).as_posix()
        for spec in (ROOT / "lua/plugins").rglob("*.lua")
    }

    for relative in sorted(actual - documented):
        errors.append(f"plugin spec is absent from catalog: {relative}")
    for relative in sorted(documented - actual):
        errors.append(f"catalog references a missing plugin spec: {relative}")


def check_published_wiki(errors: list[str]) -> None:
    """Render and validate the GitHub Wiki publication format."""
    with TemporaryDirectory(prefix="nvim-wiki-") as temporary:
        output = Path(temporary)
        rendered = render_wiki(output)
        expected_names = {path.name for path in WIKI.glob("*.md")}
        rendered_names = {path.name for path in rendered}
        if rendered_names != expected_names:
            errors.append("rendered Wiki file set does not match source file set")

        anchor_cache: dict[Path, set[str]] = {}
        for page in rendered:
            if not page.name.startswith("_"):
                body = without_fenced_code(page.read_text(encoding="utf-8"))
                if any(line.startswith("# ") for line in body.splitlines()):
                    errors.append(f"rendered Wiki page keeps duplicate H1: {page.name}")

            for target in markdown_links(page):
                parsed = urlsplit(target)
                if (
                    parsed.scheme
                    or parsed.netloc
                    or target.startswith(("mailto:", "tel:"))
                ):
                    continue
                if parsed.path.endswith(".md"):
                    errors.append(
                        f"rendered Wiki link keeps .md suffix: {page.name}: {target}"
                    )
                    continue

                if parsed.path:
                    relative = unquote(parsed.path).removeprefix("./") + ".md"
                    resolved = (output / relative).resolve()
                elif parsed.fragment:
                    resolved = page.resolve()
                else:
                    continue

                if not resolved.is_relative_to(output):
                    errors.append(
                        f"rendered Wiki link leaves output: {page.name}: {target}"
                    )
                elif not resolved.is_file():
                    errors.append(
                        f"rendered Wiki link has no page: {page.name}: {target}"
                    )
                elif parsed.fragment:
                    anchors = anchor_cache.setdefault(
                        resolved, heading_anchors(resolved)
                    )
                    anchor = unquote(parsed.fragment).lower()
                    if anchor not in anchors:
                        errors.append(
                            f"rendered Wiki link has no anchor: {page.name}: {target}"
                        )


def check_snippet_manifest(errors: list[str]) -> None:
    """Check that the snippet manifest and repository files agree."""
    manifest = json.loads(SNIPPET_MANIFEST.read_text(encoding="utf-8"))
    entries = manifest.get("contributes", {}).get("snippets", [])
    declared: set[Path] = set()

    for entry in entries:
        raw_path = entry.get("path")
        if not isinstance(raw_path, str):
            errors.append("snips/package.json: snippet entry has no string path")
            continue
        path = (SNIPPET_MANIFEST.parent / raw_path).resolve()
        declared.add(path)
        if not path.is_file():
            errors.append(f"snips/package.json: missing snippet file: {raw_path}")

    actual = {path.resolve() for path in (ROOT / "snips/snippets").rglob("*.json")}
    for path in sorted(actual - declared):
        errors.append(f"snippet file is absent from manifest: {path.relative_to(ROOT)}")


def main() -> int:
    """Run all documentation consistency checks."""
    errors: list[str] = []
    pages = substantive_pages()
    documents = [README, *sorted(WIKI.glob("*.md"))]

    for required in (README, SIDEBAR, WIKI / "_Footer.md", CATALOG, SNIPPET_MANIFEST):
        if not required.is_file():
            errors.append(
                f"required documentation input is missing: {required.relative_to(ROOT)}"
            )

    if not errors:
        check_links(documents, errors)
        check_wiki_structure(pages, errors)
        check_plugin_catalog(errors)
        check_published_wiki(errors)
        check_snippet_manifest(errors)

    if errors:
        for error in errors:
            print(f"error: {error}")
        return 1

    plugin_specs = list((ROOT / "lua/plugins").rglob("*.lua"))
    print(
        "documentation check passed: "
        f"{len(documents)} Markdown files, "
        f"{len(pages)} Wiki pages, "
        f"{len(plugin_specs)} plugin specs"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
