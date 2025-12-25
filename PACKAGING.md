# Packaging Documentation

This directory contains packaging files for `which-terminal` across multiple Linux distributions, all targeting x86_64 architecture.

## Automated Package Building (CI/CD)

Packages are automatically built via GitHub Actions CI/CD when you push a version tag:

```bash
git tag v0.1.0
git push origin v0.1.0
```

This will trigger the workflow to build:
- **Arch Linux** package (.pkg.tar.zst)
- **Debian/Ubuntu** package (.deb)
- **Fedora/CentOS/RedHat** package (.rpm)

All packages will be automatically attached to the GitHub release.

## Manual Building (Local Development)

For local testing and development, the Makefile includes convenient targets:

```bash
# Build Arch Linux package
make pkg-arch

# Build Debian/Ubuntu package
make pkg-deb

# Build RPM package (Fedora/CentOS/RedHat)
make pkg-rpm

# Clean all package build artifacts
make clean-pkg
```

## Package Files

### Arch Linux

**File:** `PKGBUILD`

Manual build:
```bash
make pkg-arch
# or manually:
makepkg -cf
```

### Debian/Ubuntu

**Directory:** `debian/`

Package contents:
- `debian/control` - Package metadata and dependencies
- `debian/rules` - Build instructions
- `debian/changelog` - Version history
- `debian/compat` - debhelper compatibility level
- `debian/copyright` - License information

Manual build:
```bash
make pkg-deb
# or manually:
dpkg-buildpackage -us -uc -b
```

The resulting `.deb` file will be created in the parent directory.

### Fedora/CentOS/RedHat

**File:** `which-terminal.spec`

Manual build:
```bash
make pkg-rpm
# or manually:
rpmbuild -ba which-terminal.spec
```

Or using mock for a clean build environment:
```bash
mock -r fedora-39-x86_64 which-terminal.spec
```

## Notes

- All packages are configured for **x86_64 architecture only**
- Packages provide both `which-terminal` and `x-terminal-emulator` binaries (symlinked)
- The `x-terminal-emulator` symlink provides compatibility with Debian's alternatives system
- Maintainer: ZhymabekRoman <robanokssamit@yandex.kz>
- CI/CD workflow: `.github/workflows/package.yml`

## Prerequisites (for manual building)

### Arch Linux
- `vlang` (V compiler)
- `base-devel`

### Debian/Ubuntu
- `debhelper`
- `vlang`
- `build-essential`

### Fedora/CentOS/RedHat
- `rpm-build`
- `vlang`
- `gcc`
- `make`

## Version Management

When releasing a new version:

1. Update version numbers in:
   - `PKGBUILD` (pkgver)
   - `debian/changelog` (add new entry)
   - `which-terminal.spec` (Version and %changelog)

2. Create and push a git tag:
   ```bash
   git tag v0.1.0
   git push origin v0.1.0
   ```

3. GitHub Actions will automatically build all packages and create a release
