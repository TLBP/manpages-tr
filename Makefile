# standart kurulum:
# make clean; make; make install
#

MANDIR = /usr/share/man/tr


all: ilc
	./prepare.sh;

# hem paket içinde hem de sistemde varolan dosyaları
# sistemden silelim ve dosyaları kuralım.
install: ilc
	@cd tr; for dir in man?; do \
		if [ -d $$dir ]; then for i in $$dir/*; do \
	    		file=`basename $$i .gz`; \
			rm -f $(MANDIR)/$$dir/$$file \
		      		$(MANDIR)/$$i \
		      		$(MANDIR)/$$dir/"$$file".bz2; \
		done; fi; \
		install -d -m 755 $(MANDIR)/"$$dir"; \
		cp -a "$$dir"/* $(MANDIR)/"$$dir"; \
	done; cd -;

# hem paket içinde hem de sistemde varolan dosyaları
# sistemden silelim.
uninstall:
	@cd tr; for dir in man?; do \
		if [ -d $$dir ]; then for i in $$dir/*; do \
			rm -f $(MANDIR)/$$i; \
		done; fi; \
	done; cd -;

ilc:
	@str=`./isutf8`; if [ $$str != "yes" ]; then \
	    echo "Yerel karakter kodlamasi UTF-8 olmak zorunda"; \
	    exit 1; \
	fi

clean:
	rm -rf tr

debclean: clean
	debclean

deb-build:
	./prepare.sh;

deb-install:
	cd tr; for i in man?; do \
	    install -d $(DESTDIR)$(MANDIR)/"$$i"; \
	    cp -a "$$i"/* $(DESTDIR)$(MANDIR)/"$$i"; \
	done; cd -;

deb: ilc
	debuild

