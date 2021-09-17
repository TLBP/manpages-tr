# groff-1.19.1 veya üstü mevcutsa standart kurulum:
# make clean; make; make install
#
# groff-1.18.1 veya üstü ve groff-utf8 mevcutsa:
# make clean; make utf8; make install
#
# deb paketi yapmak için:
# make clean; make deb
#
MANDIR = /usr/share/man/tr
SUBDIRS = source

all: ilc
	@for subdir in $(SUBDIRS); do \
	    (cd $$subdir && $(MAKE) $@) || exit 1; \
	done

utf8: ilc
	@for subdir in $(SUBDIRS); do \
	    (cd $$subdir && $(MAKE) $@) || exit 1; \
	done

clean:
	rm -fR tr/*
	@for subdir in $(SUBDIRS); do \
	    (cd $$subdir && $(MAKE) $@) || exit 1; \
	done
	
debclean: clean
	rm -fR *stamp debian/manpages-tr; \
	rm -f ../manpages-tr_1.0.5*

deb-build:
	@for subdir in $(SUBDIRS); do \
	    (cd $$subdir && $(MAKE) $@) || exit 1; \
	done

# hem paket icinde hem de sistemde varolan dosyalari
# sistemden silelim ve dosyalari kuralim.
install:
	@cd tr; for dir in man?; do \
		if [ -d $$dir ]; then for i in $$dir/*; do \
	    		file=`basename $$i .gz`; \
			rm -f $(MANDIR)/$$dir/$$file \
		      		$(MANDIR)/$$dir/$$i \
		      		$(MANDIR)/$$dir/"$$file".bz2; \
		done; fi; \
		install -d -m 755 $(MANDIR)/"$$dir"; \
		install -m 644 "$$dir"/* $(MANDIR)/"$$dir"; \
	done; cd -;

deb-install:
	cd tr; for i in man?; do \
	    install -d $(DESTDIR)$(MANDIR)/"$$i"; \
	    cp -a "$$i"/* $(DESTDIR)$(MANDIR)/"$$i"; \
	done; cd -;

deb: ilc
	dpkg-buildpackage -rfakeroot -us -uc 

ilc: 
	@LANG=C gcc -Wall -o isutf8 isutf8.c; \
	str=`./isutf8`; if [ $$str != "yes" ]; then \
	    echo "Yerel karakter kodlamasi UTF-8 olmak zorunda"; \
	    exit 1; \
	fi
