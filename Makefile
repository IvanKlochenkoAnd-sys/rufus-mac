# Rufus for macOS Makefile

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin

all:
	@echo "Nothing to compile. Run 'make install' to install rufus-mac."

install:
	@mkdir -p $(DESTDIR)$(BINDIR)
	@cp -f rufus-mac $(DESTDIR)$(BINDIR)/rufus-mac
	@chmod +x $(DESTDIR)$(BINDIR)/rufus-mac
	@echo "rufus-mac installed to $(DESTDIR)$(BINDIR)/rufus-mac"

uninstall:
	@rm -f $(DESTDIR)$(BINDIR)/rufus-mac
	@echo "rufus-mac uninstalled from $(DESTDIR)$(BINDIR)/rufus-mac"

.PHONY: all install uninstall
