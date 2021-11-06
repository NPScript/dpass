# dpass - dynamic menu
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dpass.c
OBJ = $(SRC:.c=.o)

all: options dpass

options:
	@echo dpass build options:
	@echo "CFLAGS   = $(CFLAGS)"
	@echo "LDFLAGS  = $(LDFLAGS)"
	@echo "CC       = $(CC)"

.c.o:
	$(CC) -c $(CFLAGS) $<

config.h:
	cp config.def.h $@

$(OBJ): arg.h config.h config.mk drw.h

dpass: dpass.o drw.o util.o
	$(CC) -o $@ dpass.o drw.o util.o $(LDFLAGS)

clean:
	rm -f dpass $(OBJ) dpass-$(VERSION).tar.gz

dist: clean
	mkdir -p dpass-$(VERSION)
	cp LICENSE Makefile README arg.h config.def.h config.mk dpass.1\
		drw.h util.h dpass_path dpass_run $(SRC)\
		dpass-$(VERSION)
	tar -cf dpass-$(VERSION).tar dpass-$(VERSION)
	gzip dpass-$(VERSION).tar
	rm -rf dpass-$(VERSION)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	install dpass $(DESTDIR)$(PREFIX)/bin/dpass
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dpass
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < dpass.1 > $(DESTDIR)$(MANPREFIX)/man1/dpass.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/dpass.1

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/dpass\
		$(DESTDIR)$(MANPREFIX)/man1/dpass.1\

.PHONY: all options clean dist install uninstall
