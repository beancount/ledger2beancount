all:

.PHONY: test
test:
	cd tests && ./runtests

check: test

