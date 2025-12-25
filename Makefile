.PHONY: build build-prod clean install test test-verbose fmt \
        pkg-arch pkg-deb pkg-rpm clean-pkg

build:
	v which-terminal.v -o which-terminal

build-prod:
	v -prod -fast-math which-terminal.v -o which-terminal
	strip which-terminal

test:
	v test .

test-verbose:
	v -stats test .

fmt:
	v fmt -w .

clean:
	rm -f which-terminal

install: build-prod
	install -m 755 which-terminal /usr/local/bin/which-terminal

# Package building targets
pkg-arch:
	@echo "Building Arch Linux package..."
	makepkg -cf

pkg-deb:
	@echo "Building Debian/Ubuntu package..."
	dpkg-buildpackage -us -uc -b

pkg-rpm:
	@echo "Building RPM package..."
	rpmbuild -ba which-terminal.spec

clean-pkg:
	@echo "Cleaning package build artifacts..."
	rm -f *.pkg.tar.zst
	rm -f ../*.deb ../*.buildinfo ../*.changes
	rm -rf debian/.debhelper debian/which-terminal debian/files
	rm -f *.rpm
