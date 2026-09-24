![pixogram](assets/logo.png)

figlet, but in the single-block pixel-art style of the [mini.nvim](https://github.com/nvim-mini/mini.nvim) logo: a 4x7 grid, no antialiasing, no font-hinting artifacts.

```
$ pixogram "hello world"
█ █ ███ █   █   ███     █ █ ███ ███ █   ██
█ █ █   █   █   █ █     █ █ █ █ █ █ █   █ █
███ ██  █   █   █ █     ███ █ █ ██  █   █ █
█ █ █   █   █   █ █     ███ █ █ █ █ █   █ █
█ █ ███ ███ ███ ███     █ █ ███ █ █ ███ ██
```

## Usage

```
pixogram [-o FILE] [-p PALETTE] [-l] [-P] [-b BG] [-s SCALE] TEXT[:COLOR] ...
```

- No `-o`: prints ASCII block art to stdout (no color needed — good for a code comment).
- `-o FILE`: writes a PNG instead (needs ImageMagick's `magick`).
- `-p PALETTE`: `mini`, `spring`, `summer`, or `autumn` (default: `summer`). `-l` switches to its light variant. `-P` writes one PNG per palette (`FILE-PALETTE.ext`) to compare.
- `-b COLOR`: override just the background.
- `-s SCALE`: PNG upscale factor per grid cell (default `15`).
- Each text argument can carry its own `:COLOR`; with none, it uses the palette's `fg`. `:accent` / `:accent1` / `:accent2` are shorthand for the palette's accent colors. Arguments are concatenated with no gap.
- Only `a-z`, `0-9`, and space exist. Anything else renders blank.

```
pixogram -o logo.png "pix:accent1" "o:accent" "gram:accent2"
pixogram -o logo.png -p spring -l "pix:accent1" "o:accent" "gram:accent2"
```

### Palettes

| palette  | bg        | fg        | accents              |
|----------|-----------|-----------|-----------------------|
| `summer` | `#27211E` | `#F6CC9B` | `#93E4EE` `#FFC1B9`  |
| `autumn` | `#262029` | `#EFCFAB` | `#F1C6E2` `#B4E2C7`  |
| `spring` | `#1C2617` | `#D8DA9D` | `#ABE5BE` `#F7C2EA`  |
| `mini`   | `#00182A` | `#D9D8AA` | `#A6E1E2` `#B8E1C1`  |

Real [mini.hues](https://github.com/nvim-mini/mini.nvim) colors, not invented — see [Credits](#credits). `mini` is the actual mini.nvim logo palette; it's not the default so pixogram doesn't just look like a reskin.

### Styled letter

`LETTER:COLOR1,COLOR2` paints one letter in two colors — the same treatment mini.nvim gives the "n" in their logo. One character at a time, only for letters with a style defined in the script (currently `o`, `n`).

### Project defaults (`.env`)

A `.env` file in the current directory is read for defaults — plain `KEY=VALUE`, never executed: `PIXOGRAM_PALETTE`, `PIXOGRAM_MODE=light`, or a fully custom `PIXOGRAM_BG`/`FG`/`ACCENT1`/`ACCENT2`. CLI flags win over `.env`.

## Install

```
make install               # installs to ~/.local/bin/pixogram
make install PREFIX=/usr   # or another prefix
make uninstall
```

Needs POSIX `sh`, `awk`, and, for `-o`, `magick` (ImageMagick 7).

## Credits

All credit for the font and the technique goes to **[Evgeni Chasnovski](https://github.com/echasnovski)** ([@echasnovski](https://github.com/echasnovski)), author of [mini.nvim](https://github.com/nvim-mini/mini.nvim). Every letter's pixel grid was transcribed pixel-by-pixel from [`logo-2/font/*.gif`](https://github.com/nvim-mini/assets/tree/main/logo-2/font) in [nvim-mini/assets](https://github.com/nvim-mini/assets) (MIT License) — the actual generator behind the mini.nvim logo. The built-in palettes are his too, from [mini.hues](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-hues.md). See [LICENSE](LICENSE) for the full notice.
