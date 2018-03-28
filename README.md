[![Build Status](https://travis-ci.org/zacchiro/ledger2beancount.svg?branch=master)](https://travis-ci.org/zacchiro/ledger2beancount)


ledger2beancount
================

A script to automatically convert [Ledger](https://www.ledger-cli.org/)-based
textual ledgers to [Beancount](http://furius.ca/beancount/) ones.

Conversion is based on (concrete) syntax, so that information that are not
meaningful for accounting reasons but still valuable (e.g., comments,
formatting, etc.) can be preserved.

The syntax of beancount is expected to become slightly less restrictive
as some missing features are implemented (such as UTF-8 for account names
and tags on a posting-level).  ledger2beancount aims to be compatible with
the latest official release of beancount.

Please [read the manual](docs/manual.md) on how to install, configure and
use ledger2beancount.  The supported features are documented in the
manual, too.


Usage
-----

ledger2beancount accepts input from `stdin` or from a file and will write
the converted data to `stdout`.  You can run ledger2beancount like this:

    ledger2beancount test.ledger > test.beancount

Afterwards, please validate your file with `bean-check` and fix all errors:

    bean-check test.beancount

If you believe that ledger2beancount could have produced a better
conversion or if you get an error message from ledger2beancount, please
[file a bug](https://github.com/zacchiro/ledger2beancount/issues) along
with a simple test case.


Dependencies
------------

ledger2beancount uses several Perl modules:

* Carp::Assert
* Config::Onion
* Date::Calc
* File::BaseDir
* Getopt::Long::Descriptive
* YAML::XS

If you use Debian, you can install them with:

    sudo apt install libcarp-assert-perl libconfig-onion-perl \
        libdate-calc-perl libfile-basedir-perl libyaml-libyaml-perl \
        libgetopt-long-descriptive-perl


Authors
-------

* Stefano Zacchiroli `<zack@upsilon.cc>`
* Martin Michlmayr `<tbm@cyrius.com>`


License
-------

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
