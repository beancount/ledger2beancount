[![Build Status](https://travis-ci.org/zacchiro/ledger2beancount.svg?branch=master)](https://travis-ci.org/zacchiro/ledger2beancount)

ledger2beancount
================

(set of) script(s) to automatically
convert [Ledger](https://www.ledger-cli.org/)-based textual ledgers
to [Beancount](http://furius.ca/beancount/) ones.

Conversion is based on (concrete) syntax, so that information that are not
meaningful for accounting reasons but still valuable (e.g., comments,
formatting, etc.) can be preserved.

ledger2beancount relies on some configuration data.  It will search for
the config file `ledger2beancount.yml` and if that is not found for
`$HOME/.config/ledger2beancount/config.yml`.  See the sample config
file for the variables.


AUTHORS
-------

* Stefano Zacchiroli `<zack@upsilon.cc>`
* Martin Michlmayr `<tbm@cyrius.com>`


LICENSE
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
