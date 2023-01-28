# standart kurulum:
# make install
#
# deb paketi üretimi için hazırlık:
# Bu deponun içeriğinden manpages-tr_2.0.x.orig.tar.gz paketini üret.
# Dikkat: .git dizinini kopyalama!
# http://deb.debian.org/debian/pool/main/m/manpages-tr/
# adresinden en son sürümün manpages-tr_2.0.x-x.debian.tar.xz (.gz, .bz2, vb)
# paketini indir ve içindeki debian dizinini orig.tar.xz paketini ürettiğin
# dizine kopyala, debian/changelog dosyasını yeni sürüme göre düzenle. 
# Paketleri üretmek için: make deb

MANDIR = /usr/share/man/tr


all: ilc
	./prepare.sh;

# hem paket içinde hem de sistemde varolan dosyaları
# sistemden silelim ve dosyaları kuralım.
install: all
	@cd tr; for dir in man?; do \
		if [ -d $$dir ]; then for i in $$dir/*; do \
	    		file=`basename $$i .gz`; \
			rm -f $(MANDIR)/$$dir/$$file \
		      		$(MANDIR)/$$i \
		      		$(MANDIR)/$$dir/"$$file".bz2; \
		done; fi; \
		install -d -m 755 $(MANDIR)/"$$dir"; \
		cp -a "$$dir"/* $(MANDIR)/"$$dir"; \
	done; cd -; rm -rf tr

# hem paket içinde hem de sistemde varolan dosyaları
# sistemden silelim.
uninstall:
	@./prepare.sh; \
	cd tr; for dir in man?; do \
		if [ -d $$dir ]; then for i in $$dir/*; do \
			rm -f $(MANDIR)/$$i; \
		done; fi; \
	done; cd -; rm -rf tr

ilc:
	@str=`./isutf8`; if [ $$str != "yes" ]; then \
	    echo "Yerel karakter kodlamasi UTF-8 olmak zorunda"; \
	    exit 1; \
	fi

debclean:
	debclean

deb-build:
	./prepare.sh;

deb-install:
	cd tr; for i in man?; do \
	    install -d $(DESTDIR)$(MANDIR)/"$$i"; \
	    cp -a "$$i"/* $(DESTDIR)$(MANDIR)/"$$i"; \
	done; cd -; rm -rf tr

deb:
	debuild

