# AGENTS.md - Project Specification

## Project Name
**which-terminal**

## Project Purpose

`which-terminal` is a universal terminal emulator launcher designed to solve the terminal fragmentation problem across different Linux distributions and desktop environments.

## The Problem

There is no universal way to call any GUI terminal from a command-line interface (CLI). Different distributions and desktop environments use different approaches:

- Debian-based systems rely on a virtual package called `x-terminal-emulator`
- Many scripts hardcode `gnome-terminal` or `xterm`
- Not all distributions ship with `xterm` by default (e.g., EndeavourOS)
- `xterm` has limited functionality compared to modern terminals like `alacritty`, `ghostty`, `konsole`, `kitty`, and `wezterm`

This fragmentation makes it difficult to write portable scripts and applications that need to launch terminal emulators.

## The Solution

`which-terminal` provides an intelligent terminal launcher that:

1. **Detects the display server** - Automatically identifies whether the system is running X11 or Wayland
2. **Prioritizes running terminals** - Checks for already-running terminal processes first
3. **Falls back to installed terminals** - Searches for installed terminal emulators in priority order
4. **Handles different terminal syntaxes** - Automatically adds the `-e` flag for terminals that require it
5. **Provides compatibility** - Can be symlinked as `x-terminal-emulator` for Debian-style compatibility

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
- warp
- zutty
- lxterminal
- qterminal
- terminator

### Wayland Only
- foot
- Gnome Console (kgx)

## Use Cases

1. **Script portability** - Write scripts that work across different distributions without hardcoding terminal names
2. **Desktop environment integration** - Integrate with window managers and desktop environments that need to launch terminals
3. **Application launchers** - Use in application launchers that need to run commands in a terminal
4. **Replacement for x-terminal-emulator** - Drop-in replacement for Debian's virtual package system

## Technical Details

- **Language:** V (Vlang)
- **Architecture Support:** x86_64
- **Target Platforms:** Linux (X11 and Wayland)
- **Dependencies:** None at runtime (statically compiled)
- **License:** MIT

## Terminal Detection Logic

1. Check `$WAYLAND_DISPLAY` environment variable
2. Check `$DISPLAY` environment variable
3. Based on detected display server, use appropriate terminal priority list
4. First, check for running terminal processes using `pgrep`
5. If no running terminals found, check for installed terminal commands
6. Execute the first found terminal with appropriate arguments

## Command Line Usage

```bash
# Launch the best available terminal
which-terminal

# Launch terminal and execute a command
which-terminal bash
which-terminal htop
which-terminal ssh user@host
```

## Package Building

Packages are automatically built via CI/CD for:
- **Arch Linux** (.pkg.tar.zst)
- **Debian/Ubuntu** (.deb)
- **Fedora/CentOS/RedHat** (.rpm)

All packages target **x86_64 architecture only** and are available as GitHub release artifacts.

## Integration Examples

### Shell Script
```bash
#!/bin/bash
# Launch a command in a new terminal window
which-terminal -- my-command --with-args
```

### Desktop Entry
```desktop
[Desktop Entry]
Name=My Application
Exec=which-terminal -e myapp
Terminal=false
Type=Application
```

## Project Information

- **Maintainer:** ZhymabekRoman <robanokssamit@yandex.kz>
- **Repository:** https://github.com/ZhymabekRoman/which-terminal
- **Issue Tracker:** https://github.com/ZhymabekRoman/which-terminal/issues

## Related Issues

This project addresses issues like:
- [pop-os/shell#131](https://github.com/pop-os/shell/issues/131) - Terminal launcher problems in tiling window managers

## Future Enhancements

Potential future improvements:
- Consider `$XDG_CURRENT_DESKTOP` for desktop environment-specific priorities
- Configuration file support for custom terminal priorities
- User-specific terminal preferences
- Terminal feature detection (true color, ligatures, etc.)
