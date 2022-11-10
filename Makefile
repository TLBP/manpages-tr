MANDIR = /usr/share/man/tr

all:
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
	@LANG=C gcc -Wall -o isutf8 isutf8.c; \
	str=`./isutf8`; if [ $$str != "yes" ]; then \
	    echo "Yerel karakter kodlamasi UTF-8 olmak zorunda"; \
	    exit 1; \
	fi

clean:
	rm -dfr ./tr/*

