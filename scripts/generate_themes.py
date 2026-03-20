#!/usr/bin/env python3

from __future__ import annotations

from pathlib import Path
import re
import tomllib


REPO_ROOT = Path(__file__).resolve().parents[1]
MATHEME_THEMES_DIR = Path("/Users/smoose/Documents/Code/mine/matheme/themes")
BASE46_THEMES_DIR = Path("/Users/smoose/.local/share/nvim/lazy/base46/lua/base46/themes")
OUTPUT_DIR = REPO_ROOT / "themes"
TARGET_THEMES = [
    "bearded-arc",
    "everforest",
    "everforest_light",
    "gruvchad",
    "one_light",
    "rosepine",
    "tundra",
]
COLOR_KEYS = [
    "bg",
    "fg",
    "rosewater",
    "flamingo",
    "pink",
    "mauve",
    "red",
    "maroon",
    "peach",
    "yellow",
    "green",
    "teal",
    "sky",
    "sapphire",
    "blue",
    "lavender",
    "subtext_1",
    "subtext_0",
    "overlay_2",
    "overlay_1",
    "overlay_0",
    "surface_2",
    "surface_1",
    "surface_0",
    "mantle",
    "crust",
]


def parse_lua_table(source: str, table_name: str) -> dict[str, str]:
    match = re.search(rf"M\.{table_name}\s*=\s*\{{(.*?)\n\}}", source, re.S)
    if not match:
        return {}
    table = {}
    for key, value in re.findall(r'([A-Za-z0-9_]+)\s*=\s*"([^"]+)"', match.group(1)):
        table[key] = value
    return table


def parse_base46_theme(name: str) -> tuple[dict[str, str], dict[str, str], str | None]:
    path = BASE46_THEMES_DIR / f"{name}.lua"
    if not path.exists():
        return {}, {}, None
    source = path.read_text()
    theme_type = None
    match = re.search(r'M\.type\s*=\s*"([^"]+)"', source)
    if match:
        theme_type = match.group(1)
    return parse_lua_table(source, "base_30"), parse_lua_table(source, "base_16"), theme_type


def parse_matheme_theme(name: str) -> tuple[dict[str, str], str]:
    path = MATHEME_THEMES_DIR / f"{name}.toml"
    data = tomllib.loads(path.read_text())
    return data["base_16"], data["type"]


def first_color(*values: str | None) -> str:
    for value in values:
        if value:
            return value
    raise ValueError("missing color")


def fallback_base30(base16: dict[str, str], theme_type: str) -> dict[str, str]:
    if theme_type == "light":
        return {
            "black": base16["base00"],
            "black2": base16["base01"],
            "one_bg": base16["base01"],
            "one_bg2": base16["base02"],
            "one_bg3": base16["base03"],
            "grey": base16["base04"],
            "grey_fg": base16["base05"],
            "grey_fg2": base16["base05"],
            "light_grey": base16["base06"],
            "darker_black": base16["base00"],
            "statusline_bg": base16["base02"],
            "white": base16["base07"],
            "red": base16["base08"],
            "baby_pink": base16["base08"],
            "pink": base16["base0E"],
            "green": base16["base0B"],
            "vibrant_green": base16["base0B"],
            "yellow": base16["base0A"],
            "sun": base16["base0A"],
            "orange": base16["base09"],
            "teal": base16["base0C"],
            "cyan": base16["base0C"],
            "blue": base16["base0D"],
            "nord_blue": base16["base0D"],
            "purple": base16["base0E"],
            "dark_purple": base16["base0E"],
            "folder_bg": base16["base0D"],
        }
    return {
        "black": base16["base00"],
        "black2": base16["base01"],
        "one_bg": base16["base01"],
        "one_bg2": base16["base02"],
        "one_bg3": base16["base03"],
        "grey": base16["base03"],
        "grey_fg": base16["base04"],
        "grey_fg2": base16["base04"],
        "light_grey": base16["base05"],
        "darker_black": base16["base00"],
        "statusline_bg": base16["base01"],
        "white": base16["base06"],
        "red": base16["base08"],
        "baby_pink": base16["base08"],
        "pink": base16["base0E"],
        "green": base16["base0B"],
        "vibrant_green": base16["base0B"],
        "yellow": base16["base0A"],
        "sun": base16["base0A"],
        "orange": base16["base09"],
        "teal": base16["base0C"],
        "cyan": base16["base0C"],
        "blue": base16["base0D"],
        "nord_blue": base16["base0D"],
        "purple": base16["base0E"],
        "dark_purple": base16["base0E"],
        "folder_bg": base16["base0D"],
    }


def build_palette(base30: dict[str, str], base16: dict[str, str], theme_type: str) -> dict[str, str]:
    if not base30:
        base30 = fallback_base30(base16, theme_type)

    is_light = theme_type == "light"
    if is_light:
        surfaces = {
            "surface_0": first_color(base30.get("one_bg"), base30.get("black2"), base16.get("base01")),
            "surface_1": first_color(base30.get("one_bg2"), base30.get("one_bg"), base16.get("base02")),
            "surface_2": first_color(base30.get("one_bg3"), base30.get("one_bg2"), base16.get("base03")),
            "overlay_0": first_color(base30.get("grey"), base16.get("base04")),
            "overlay_1": first_color(base30.get("grey_fg"), base30.get("grey"), base16.get("base05")),
            "overlay_2": first_color(base30.get("light_grey"), base30.get("grey_fg"), base16.get("base06")),
            "subtext_1": first_color(base16.get("base07"), base16.get("base06")),
            "subtext_0": first_color(base16.get("base06"), base16.get("base05")),
            "mantle": first_color(base30.get("darker_black"), base16.get("base00")),
            "crust": first_color(base30.get("statusline_bg"), base30.get("black2"), base16.get("base01")),
        }
    else:
        surfaces = {
            "surface_0": first_color(base30.get("one_bg"), base16.get("base01")),
            "surface_1": first_color(base30.get("one_bg2"), base16.get("base02")),
            "surface_2": first_color(base30.get("one_bg3"), base16.get("base03")),
            "overlay_0": first_color(base30.get("grey"), base16.get("base03")),
            "overlay_1": first_color(base30.get("grey_fg"), base30.get("grey"), base16.get("base04")),
            "overlay_2": first_color(base30.get("light_grey"), base30.get("grey_fg"), base16.get("base05")),
            "subtext_1": first_color(base16.get("base04"), base16.get("base05")),
            "subtext_0": first_color(base16.get("base06"), base16.get("base05")),
            "mantle": first_color(base30.get("statusline_bg"), base30.get("black2"), base16.get("base01")),
            "crust": first_color(base30.get("darker_black"), base16.get("base00")),
        }

    return {
        "bg": first_color(base30.get("black"), base16.get("base00")),
        "fg": first_color(base16.get("base05"), base30.get("white"), base16.get("base06")),
        "rosewater": first_color(base30.get("baby_pink"), base30.get("pink"), base16.get("base08")),
        "flamingo": first_color(base30.get("pink"), base30.get("baby_pink"), base16.get("base08")),
        "pink": first_color(base30.get("pink"), base30.get("purple"), base16.get("base0E")),
        "mauve": first_color(base30.get("purple"), base30.get("dark_purple"), base16.get("base0E")),
        "red": first_color(base30.get("red"), base16.get("base08")),
        "maroon": first_color(base30.get("baby_pink"), base30.get("red"), base16.get("base08")),
        "peach": first_color(base30.get("orange"), base16.get("base09")),
        "yellow": first_color(base30.get("yellow"), base30.get("sun"), base16.get("base0A")),
        "green": first_color(base30.get("vibrant_green"), base30.get("green"), base16.get("base0B")),
        "teal": first_color(base30.get("teal"), base30.get("cyan"), base16.get("base0C")),
        "sky": first_color(base30.get("cyan"), base30.get("teal"), base16.get("base0C")),
        "sapphire": first_color(base30.get("nord_blue"), base30.get("blue"), base16.get("base0D")),
        "blue": first_color(base30.get("blue"), base30.get("folder_bg"), base16.get("base0D")),
        "lavender": first_color(base30.get("dark_purple"), base30.get("purple"), base30.get("nord_blue"), base16.get("base0E")),
        **surfaces,
    }


def display_name(name: str) -> str:
    parts = name.replace("-", " ").replace("_", " ").split()
    return " ".join(part.capitalize() for part in parts)


def render_theme(name: str, palette: dict[str, str]) -> str:
    lines = ["# vim:set ft=tmux:", "", f"# --> tmux-theme ({display_name(name)})"]
    for key in COLOR_KEYS:
        lines.append(f'set -gq @thm_{key} "{palette[key]}"')
        if key == "fg":
            lines.append("")
            lines.append("# Colors")
        if key == "lavender":
            lines.append("")
            lines.append("# Surfaces and overlays")
    lines.append("")
    return "\n".join(lines)


def main() -> None:
    OUTPUT_DIR.mkdir(exist_ok=True)
    for theme_name in TARGET_THEMES:
        matheme_base16, matheme_type = parse_matheme_theme(theme_name)
        base30, base16, base46_type = parse_base46_theme(theme_name)
        theme_type = base46_type or matheme_type
        merged_base16 = {**matheme_base16, **base16}
        palette = build_palette(base30, merged_base16, theme_type)
        output = render_theme(theme_name, palette)
        (OUTPUT_DIR / f"{theme_name}.conf").write_text(output)


if __name__ == "__main__":
    main()
