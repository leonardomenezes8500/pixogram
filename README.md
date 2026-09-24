![pixogram](assets/logo.png)

figlet, but in the single-block pixel-art style of the [mini.nvim](https://github.com/nvim-mini/mini.nvim) logo: a 4x7 grid, no antialiasing, no font-hinting artifacts — every glyph is straight and uniform.

> This is basically a copy of the technique (and the font) [Evgeni Chasnovski](https://github.com/echasnovski) built for `mini.nvim` — see [Credits](#credits). `pixogram` just generalizes it to any text, in POSIX `sh` instead of Lua+Neovim.

```
$ pixogram "hello world"
█ █ ███ █   █   ███     █ █ ███ ███ █   ██
█ █ █   █   █   █ █     █ █ █ █ █ █ █   █ █
███ ██  █   █   █ █     ███ █ █ ██  █   █ █
█ █ █   █   █   █ █     ███ █ █ █ █ █   █ █
█ █ ███ ███ ███ ███     █ █ ███ █ █ ███ ██
```

```
$ pixogram -o logo.png "pix:accent1" "o:accent" "gram:accent2"
```

## Usage

```
pixogram [-o FILE] [-p PALETTE] [-P] [-b BG] [-s SCALE] TEXT[:COLOR] ...
```

- No `-o`: prints ASCII block art to stdout (good for pasting into a code comment — no color needed).
- `-o FILE`: writes a PNG instead (needs ImageMagick's `magick`).
- `-s SCALE`: PNG upscale factor per grid cell (default `15`, the same mini.nvim uses for their own README — `15 * 7 = 105px` tall).
- Each text argument can carry its own `:COLOR` for PNG mode; with no `:COLOR` it uses the active palette's fg. Multiple arguments are just concatenated — no gap between them — because every glyph already carries its own trailing blank column.
- Only `a-z`, `0-9`, and space exist. Any other character renders as a blank cell.

### Palettes

`-p PALETTE` picks one of 4 built-in palettes (default: `autumn`). Each is `bg` + `fg` + two accent colors, real values from [mini.hues](https://github.com/nvim-mini/mini.nvim)'s 4 bundled color schemes (see [Credits](#credits)) — not made up. `mini` is the actual real mini.nvim logo colors; it exists as an option but isn't the default, so pixogram doesn't just look like a reskin of the thing it's copying.

| palette  | bg        | fg        | accents              |
|----------|-----------|-----------|-----------------------|
| `autumn` | `#262029` | `#EFCFAB` | `#F1C6E2` `#B4E2C7`  |
| `spring` | `#1C2617` | `#D8DA9D` | `#ABE5BE` `#F7C2EA`  |
| `summer` | `#27211E` | `#F6CC9B` | `#93E4EE` `#FFC1B9`  |
| `mini`   | `#00182A` | `#D9D8AA` | `#A6E1E2` `#B8E1C1`  |

mini.hues places its 8 named hues (red/orange/yellow/green/cyan/azure/blue/purple) at fixed 45° steps around the OKLCH hue wheel (`H.make_hues` in `lua/mini/hues.lua`). `mini`'s accents (cyan+green) are the real logo's own — not our choice, just transcribed. For `spring`/`summer`/`autumn` each palette's two accents are a true complementary pair from that wheel — 180° apart, the strongest-contrast pairing there is — and each uses a *different* pair (green+purple, azure+orange, red+cyan), so accent1 (`pix` above) still reads as a clearly different color across all 4. Not picked because they looked nice together — picked because the math says they're opposites.

```
pixogram -o logo.png -p spring "pix:accent1" "o:accent" "gram:accent2"
```

`-P` writes one PNG per built-in palette instead of just one (`FILE-PALETTE.ext` for each), so you can compare and pick:

```
pixogram -o logo.png -P "pix:accent1" "o:accent" "gram:accent2"
# -> logo-mini.png logo-spring.png logo-summer.png logo-autumn.png
```

`-b COLOR` overrides just the background, on top of whichever palette is active.

### Styled letter (2 colors in one glyph)

For a single letter, `LETTER:COLOR1,COLOR2` paints part of that glyph one color and the rest another — the same treatment mini.nvim gives the "n" in their logo. Only works one character at a time, and only for letters with a style defined in the script (currently: `o`, `n`). It's not automatic or "smart" — it's an optional `style[]` table you add to by hand when you want that effect on a new letter.

`LETTER:accent` is shorthand for the active palette's own two accent colors; `:accent1` / `:accent2` are shorthand for just one of them, on an ordinary (non-styled) segment. That's what the examples above are doing — `pix:accent1` and `gram:accent2` make the styled `o` read as a transition between the two, instead of an unrelated flourish sitting between two same-colored words.

```
pixogram -o logo.png "mini:#B3DAF9" "n:#A6E1E2,#B8E1C1" "vim:#D9D8AA"
```

(mini.nvim's own logo also has a "." after "mini" — `pixogram` has no `.` glyph, so it's left out here.)

### Project defaults (`.env`)

A `.env` file in the current directory is read for defaults — read as plain `KEY=VALUE` lines, never executed:

```
PIXOGRAM_PALETTE=spring
```

or a fully custom palette, same values you'd otherwise pass as flags:

```
PIXOGRAM_BG=#1a0033
PIXOGRAM_FG=#ffddaa
PIXOGRAM_ACCENT1=#ff88cc
PIXOGRAM_ACCENT2=#88ffcc
```

An explicit `-p` on the command line always wins over `.env` (so you can still reach for a built-in palette even in a project that has its own default); `-b` always wins over both.

## Install

```
make install               # installs to ~/.local/bin/pixogram
make install PREFIX=/usr   # or another prefix
make uninstall
```

Just needs POSIX `sh` (tested with `dash`), `awk`, and, for `-o`, `magick` (ImageMagick 7).

## Credits

All credit for the font and the technique goes to **[Evgeni Chasnovski](https://github.com/echasnovski)** ([@echasnovski](https://github.com/echasnovski)), author of [mini.nvim](https://github.com/nvim-mini/mini.nvim). Every letter's pixel grid was transcribed pixel-by-pixel from the [`logo-2/font/*.gif`](https://github.com/nvim-mini/assets/tree/main/logo-2/font) files in the [nvim-mini/assets](https://github.com/nvim-mini/assets) repo (MIT License), which is the actual generator behind the mini.nvim logo (`logo-2/generate.lua`).

The built-in palettes are also his: `mini` is the real mini.nvim logo palette (in turn, the `miniwinter` scheme from his [mini.hues](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-hues.md) colorscheme generator), and `spring`/`summer`/`autumn` are mini.hues' 3 other bundled seasonal schemes — real, deliberately-designed colors, not invented for this project.

`pixogram` wouldn't exist without that work — it's essentially a reimplementation of the same idea in POSIX `sh` + `awk`, to generate arbitrary text instead of just mini.nvim's own modules. See [LICENSE](LICENSE) for the full copyright notice.
