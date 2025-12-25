.PHONY: build build-prod clean install test test-verbose fmt

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
