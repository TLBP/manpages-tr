#tr
SUBDIRS = tr
all:
	./manderle.sh

utf8:	
	./manderle.sh --utf8

clean:
	@for subdir in $(SUBDIRS); do \
	    (cd $$subdir && $(MAKE) $@) || exit 1; \
	done

deb:	
	./manderle.sh --debianize

deb-build: deb
	@for subdir in $(SUBDIRS); do \
	    (cd $$subdir && $(MAKE) $@) || exit 1; \
	done

