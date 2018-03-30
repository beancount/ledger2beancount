all:

test:
	cd tests && ./runtests

check: test

.PHONY: all check test
