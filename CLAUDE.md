# pixogram

figlet, but in mini.nvim's single-block pixel-art logo style. See README.md for what it does and how to use it. This file is build/design context, not user docs — keep the two from overlapping.

**Language:** commits, code comments, and docs are English-only.

**History:** no manual changelog here. `git log --oneline` (and commit bodies) is the record of what was tried, what broke, and why things are the way they are. Read it before assuming context; write commit messages assuming the same.

## How it's built

Single POSIX `sh` file (`pixogram`), no external font — every glyph is a hand-authored 4x7 grid (`font[ch,row]` in the embedded `awk` program), transcribed pixel-by-pixel from `nvim-mini/assets` `logo-2/font/*.gif` (see README Credits). `awk` does layout/lookup since POSIX `sh` has no arrays; `magick` (ImageMagick 7) is only invoked for `-o` PNG output.

To add a letter: dump its real GIF (if extending from the same source) or hand-draw a 4x7 grid of `0`/`1` per row, add it as a `font[ch,row]` entry. To add a 2-color styled letter: add a `style[ch,row]` entry (which "on" pixels go to the 2nd color) — see `o` and `n` in the script for the pattern. Styled letters are hardcoded per-letter by design, not a general rule — mini.nvim itself only ever does this for one letter in its whole font.

### Palette color math

Real `mini.hues` values, not invented (see README Credits and `resolve_palette()` in the script). `mini.hues` places its 8 named hues (red/orange/yellow/green/cyan/azure/blue/purple) at fixed 45° steps around the OKLCH hue wheel (`H.make_hues` in `mini.nvim`'s `lua/mini/hues.lua`). `spring`/`summer`/`autumn`'s two accents are each a true complementary pair (180° apart) from that wheel, one different pair per palette, so `accent1` reads as a clearly different color across all 4 palettes. `mini`'s accents (cyan+green, 45° apart) are the real logo's own, not picked by this rule — don't "fix" them to be complementary.

Each palette also has a light-mode variant (`-l`), transcribed from the same `colors/*.lua` files' light-mode branch (bg/fg flip light, accents switch to their darker light-mode hex).

`assets/example-mini-nvim.png` demonstrates the styled-letter feature on real mini.nvim brand colors (`mini:#B3DAF9 n:#A6E1E2,#B8E1C1 vim:#D9D8AA`) — kept as a rendered check that the mechanism still works, not something every logo needs.

### ImageMagick gotchas hit while building this

- `-opaque` silently collapses to grayscale on a bilevel-origin image (e.g. from a P1 PBM) in this build — any fill color gets quantized to black/white, losing the actual color. Fix: recolor via a 2-stop (or 3-stop, for styled letters) `-clut` gradient instead of `-fill`/`-opaque`.
- Alpha-based compositing (`-alpha set` + transparent gradient stop) for the styled-letter 2-color split didn't work reliably (alpha channel gets set uniformly opaque regardless of the base image's own value, so a transparency-based clut painted everything one color). Fix: skip alpha — build a 3-level grayscale PGM (P2: 0=bg, 128=color1, 255=color2) and `-clut` against a literal 3-pixel `xc:bg xc:color1 xc:color2 +append` image instead.
