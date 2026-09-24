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
$ pixogram -o logo.png "track:#bfe3ff" "ec:#dcd2a0"
```

## Usage

```
pixogram [-o FILE] [-b BG] [-s SCALE] TEXT[:COLOR] ...
```

- No `-o`: prints ASCII block art to stdout (good for pasting into a code comment — no color needed).
- `-o FILE`: writes a PNG instead (needs ImageMagick's `magick`).
- `-b COLOR`: background color, hex (default `#00182A`).
- `-s SCALE`: PNG upscale factor per grid cell (default `15`, the same mini.nvim uses for their own README — `15 * 7 = 105px` tall).
- Each text argument can carry its own `:COLOR` for PNG mode (default `#D9D8AA`). Multiple arguments are just concatenated — no gap between them — because every glyph already carries its own trailing blank column.
- Only `a-z`, `0-9`, and space exist. Any other character renders as a blank cell.
- **Styled letter (2 colors in one glyph):** for a single letter, `LETTER:COLOR1,COLOR2` paints part of that glyph one color and the rest another — the same treatment mini.nvim gives the "n" in their logo. Only works one character at a time, and only for letters with a style defined in the script (currently: `o`, `n`). It's not automatic or "smart" — it's an optional `style[]` table you add to by hand when you want that effect on a new letter.

  ```
  pixogram -o logo.png "mini:#B3DAF9" "n:#A6E1E2,#B8E1C1" "vim:#D9D8AA"
  ```

  (mini.nvim's own logo also has a "." after "mini" — `pixogram` has no `.` glyph, so it's left out here.)

## Install

```
make install               # installs to ~/.local/bin/pixogram
make install PREFIX=/usr   # or another prefix
make uninstall
```

Just needs POSIX `sh` (tested with `dash`), `awk`, and, for `-o`, `magick` (ImageMagick 7).

## Credits

All credit for the font and the technique goes to **[Evgeni Chasnovski](https://github.com/echasnovski)** ([@echasnovski](https://github.com/echasnovski)), author of [mini.nvim](https://github.com/nvim-mini/mini.nvim). Every letter's pixel grid was transcribed pixel-by-pixel from the [`logo-2/font/*.gif`](https://github.com/nvim-mini/assets/tree/main/logo-2/font) files in the [nvim-mini/assets](https://github.com/nvim-mini/assets) repo (MIT License), which is the actual generator behind the mini.nvim logo (`logo-2/generate.lua`). The default colors (`#00182A` background, `#D9D8AA` letter) come from there too.

`pixogram` wouldn't exist without that work — it's essentially a reimplementation of the same idea in POSIX `sh` + `awk`, to generate arbitrary text instead of just mini.nvim's own modules. See [LICENSE](LICENSE) for the full copyright notice.
