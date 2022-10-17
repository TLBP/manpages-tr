MANDIR = /usr/share/man/tr

# hem paket içinde hem de sistemde varolan dosyaları
# sistemden silelim ve dosyaları kuralım.
install:
	@cd tr; for dir in man?; do \
		if [ -d $$dir ]; then for i in $$dir/*; do \
	    		file=`basename $$i .gz`; \
			rm -f $(MANDIR)/$$dir/$$file \
		      		$(MANDIR)/$$i \
		      		$(MANDIR)/$$dir/"$$file".bz2; \
		done; fi; \
		install -d -m 755 $(MANDIR)/"$$dir"; \
		install -m 644 "$$dir"/* $(MANDIR)/"$$dir"; \
	done; cd -;

# hem paket içinde hem de sistemde varolan dosyaları
# sistemden silelim.
uninstall:
	@cd tr; for dir in man?; do \
		if [ -d $$dir ]; then for i in $$dir/*; do \
			rm -f $(MANDIR)/$$i; \
		done; fi; \
	done; cd -;
