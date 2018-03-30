all:

L2C = bin/ledger2beancount
TEST_DEPS = $(wildcard tests/*) $(L2C)

test: test-stamp
test-stamp: $(TEST_DEPS)
	cd tests && ./runtests
	touch $@


check: test

clean:
	rm -f test-stamp

.PHONY: all check clean test
