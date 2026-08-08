---
paths: "**/foot.nix,**/qt.nix,**/bat.nix,**/yazi.nix,modules/*theme*.nix"
---

# Theming hazards — colours and syntax themes

- **ANSI carries base16; base24 is only reachable as hex.** `foot.nix` renders
  the standard base16 slot mapping from `desktop.colors16` (the `base0*` subset
  of `desktop.colors`), so a program asking for *the base16 theme* now gets
  what it asserts — ANSI 9 is base09. The corollary is that `base10`–`base17`
  cannot travel through ANSI at all: a consumer wanting one reads
  `desktop.colors` and hands over hex, which is why `qt.nix` does. The reason
  `bat.nix` and `filemanager/yazi.nix` share `desktop.syntaxTheme` is
  unchanged: syntect takes a tmTheme, not ANSI.
- **`reset` is a value that only survives being drawn.** yazi's status bar
  reads colours back and transposes them. Check whether anything reads a colour
  back before choosing one.

## Where the options are declared

- `modules/tmtheme.nix` — provider/consumer split: declares `desktop.syntaxTheme`
  in `core`, read by `bat.nix` and `yazi.nix`.
