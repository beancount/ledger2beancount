ledger2beancount(1)

; SPDX-FileCopyrightText: © 2019 Martin Michlmayr <tbm@cyrius.com>

; SPDX-License-Identifier: GPL-3.0-or-later

# NAME

ledger2beancount - ledger to beancount converter

# SYNOPSIS

*ledger2beancount* [options] _input.ledger_ > _output.beancount_

*cat* _input.ledger_ | *ledger2beancount* [options] > _output.beancount_

# DESCRIPTION

*ledger2beancount* is a script to automatically convert
*ledger*(1)-based textual ledgers to *beancount* files.

Conversion is based on (concrete) syntax, so that information that is
not meaningful for accounting reasons but still valuable (e.g.,
comments, formatting, etc.) can be preserved.

# OPTIONS

*-c, --config*
	Specify a configuration file.  The options of the configuration
	file are described in *ledger2beancount*(5) and the
	*ledger2beancount* manual.

*-h, --help*
	Show help message and quit.

# USAGE

*ledger2beancount* accepts input from _stdin_ or from a file and will
write the converted data to _stdout_.  You can run *ledger2beancount*
like this on the example provided:

	*ledger2beancount* _examples/simple.ledger_ > _simple.beancount_

After you convert your *ledger*(1) file, you should validate the
generated beancount file with *bean-check*(1) and fix all errors:

	*bean-check* _simple.beancount_

You should also inspect the generated *beancount* file to see if it
looks correct to you.  Please note that *ledger2beancount* puts notes at
the beginning of the generated *beancount* file if it encounters
problems with the conversion.

# FILES

_$PWD/ledger2beancount.yml_
	The configuration file for the current directory.

_$HOME/.config/ledger2beancount/config.yml_
	The default configuration file.

# BUGS

If you find any bugs in *ledger2beancount* or believe the conversion
from *ledger* to *beancount* could be improved, please open an issue on
GitHub:
	https://github.com/beancount/ledger2beancount/issues

Please include a small test case so we can reproduce the problem.

# AUTHORS

Stefano Zacchiroli and Martin Michlmayr

# SEE ALSO

*ledger2beancount*(5), *ledger*(1), *bean-check*(1)

The full documentation for *ledger2beancount* can be found in its manual.

