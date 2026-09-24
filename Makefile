PREFIX ?= $(HOME)/.local
BINDIR := $(PREFIX)/bin

.PHONY: install uninstall test

install:
	install -Dm755 pixogram $(BINDIR)/pixogram

uninstall:
	rm -f $(BINDIR)/pixogram

test:
	dash -n pixogram
	./pixogram "test" >/dev/null
