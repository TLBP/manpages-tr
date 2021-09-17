mandirs := 1 2 3 4 5 6 7 8

clean:
	@for i in $(mandirs); do \
	    if [ -d man$$i ]; then rm -fR man$$i; fi; \
	done
	

deb-build:
	./linkata.sh
