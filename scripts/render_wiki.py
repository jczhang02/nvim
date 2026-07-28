#!/usr/bin/env python3
"""Render repository-local Wiki sources for GitHub Wiki publication."""

from pathlib import Path
from urllib.parse import urlsplit
import argparse
import re

ROOT = Path(__file__).resolve().parents[1]
WIKI = ROOT / "wiki"
LINK_RE = re.compile(r"(!?\[[^\]]*\]\()([^)]+)(\))")


def rewrite_target(target: str) -> str:
    """Convert one local Markdown page target to a GitHub Wiki slug."""
    parsed = urlsplit(target)
    if parsed.scheme or parsed.netloc or not parsed.path:
        return target
    if not parsed.path.endswith(".md"):
        return target

    path = parsed.path.removeprefix("./")
    slug = Path(path).with_suffix("").as_posix()
    if parsed.query:
        slug += f"?{parsed.query}"
    if parsed.fragment:
        slug += f"#{parsed.fragment}"
    return slug


def rewrite_links(text: str) -> str:
    """Rewrite local page links outside fenced code blocks."""
    rendered: list[str] = []
    in_fence = False
    fence = ""

    for line in text.splitlines(keepends=True):
        stripped = line.lstrip()
        if stripped.startswith(("```", "~~~")):
            marker = stripped[:3]
            if not in_fence:
                in_fence = True
                fence = marker
            elif marker == fence:
                in_fence = False
                fence = ""
            rendered.append(line)
            continue

        if in_fence:
            rendered.append(line)
            continue

        def replace(match: re.Match[str]) -> str:
            return f"{match.group(1)}{rewrite_target(match.group(2))}{match.group(3)}"

        rendered.append(LINK_RE.sub(replace, line))

    return "".join(rendered)


def remove_page_title(text: str) -> str:
    """Remove the source H1 because GitHub Wiki renders the filename as title."""
    lines = text.splitlines(keepends=True)
    for index, line in enumerate(lines):
        if not line.strip():
            continue
        if line.startswith("# "):
            del lines[index]
            if index < len(lines) and not lines[index].strip():
                del lines[index]
        break
    return "".join(lines)


def render_page(source: Path) -> str:
    """Render one Wiki source page."""
    text = source.read_text(encoding="utf-8")
    if not source.name.startswith("_"):
        text = remove_page_title(text)
    return rewrite_links(text)


def render_wiki(output: Path) -> list[Path]:
    """Render all Wiki Markdown files into an output directory."""
    output = output.resolve()
    if output == WIKI.resolve():
        raise ValueError("output directory must not be the Wiki source directory")

    output.mkdir(parents=True, exist_ok=True)
    for stale in output.glob("*.md"):
        stale.unlink()

    rendered: list[Path] = []
    for source in sorted(WIKI.glob("*.md")):
        target = output / source.name
        target.write_text(render_page(source), encoding="utf-8")
        rendered.append(target)
    return rendered


def parse_args() -> argparse.Namespace:
    """Parse command-line arguments."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "output", type=Path, help="empty/staging directory for rendered Wiki files"
    )
    return parser.parse_args()


def main() -> int:
    """Render the Wiki and report the generated file count."""
    args = parse_args()
    rendered = render_wiki(args.output)
    print(f"rendered {len(rendered)} Wiki files to {args.output.resolve()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
