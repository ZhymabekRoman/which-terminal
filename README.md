# which-terminal

## About

There is no universal way to call any GUI terminal from a command-line interface (CLI). Most of them simply call `gnome-terminal` or a virtual package from Debian-based distributions called `x-terminal-emulator`. This package, `which-terminal`, aims to fix this problem. People say that almost all distributions come with `xterm`, but my EndeavourOS doesn't have it installed by default. And `xterm` has super-limited functionality, compared to modern terminal solutions like `alacritty`, `ghostty`, `konsole`, and others. Personally, I wouldn't install `xterm`.

## Related Issues

- [pop-os/shell#131](https://github.com/pop-os/shell/issues/131)

## Terminal Resolving Priority

1. Prioritized by X11 or Wayland environment terminals
2. Prioritized by opened terminals
   - Consider `$XDG_CURRENT_DESKTOP`?

## Supported Terminals

### X11 and Wayland (Native Support)

- alacritty
- kitty
- wezterm
- ghostty
- Tilix
- Blackbox

### X11 Only

- rxvt
- urxvt
- xterm
- Gnome Terminal
- kitty
- warp
- zutty
- lxterminal
- qterminal
- terminator

### Wayland Only

- foot
- Gnome Console
