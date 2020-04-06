# SPDX-FileCopyrightText: © 2016 Stefano Zacchiroli <zack@upsilon.cc>
# SPDX-FileCopyrightText: © 2018 Martin Michlmayr <tbm@cyrius.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

all: test docs

L2C = bin/ledger2beancount
TEST_DEPS = $(wildcard tests/*) $(L2C)

test: test-stamp
test-stamp: $(TEST_DEPS)
	cd tests && ./runtests
	touch $@

check: test

docs/ledger2beancount.1: docs/ledger2beancount.1.scd
	scdoc < $< > $@

docs/ledger2beancount.5: docs/ledger2beancount.5.scd
	scdoc < $< > $@

docs/manual.pdf: docs/manual.md
	pandoc -f markdown+definition_lists $< -o $@

pdf: docs/manual.pdf

man: docs/ledger2beancount.1 docs/ledger2beancount.5

docs: pdf man

clean:
	rm -f test-stamp docs/ledger2beancount.1 docs/ledger2beancount.5 docs/manual.pdf

.PHONY: all check clean test pdf man docs
