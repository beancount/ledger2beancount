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


FUNCTIONALITY
-------------

### Tags

Beancount currently has two limitations regarding tags:

1. they have to be on the same line as the narration ([issue
99](https://bitbucket.org/blais/beancount/issues/99)), which means the
line can get very long.  It would be good to put tags on a line on its
own before the first posting but this currently doesn't work.

2. postings can't have tags ([issue
144](https://bitbucket.org/blais/beancount/issues/144)).

Because of these limitations, ledger2beancount offers two ways to handle
tags using the `tag_as_metadata` variable:

If `tag_as_metadata` is `true`, tags will be stored as metadata with the
key `tags`.  This works both for transactions and postings.  This option
should be seen as a workaround because metadata with the key `tags` is
not seen the same by beancount as proper tags.

If `tag_as_metadata` is `false`, transaction tags will be put after the
narration as tags.  Because of the limitation in beancount, posting-level
tags are currently ignored.  If tags are rendered as tags, you can define
[regular expressions](https://perldoc.perl.org/perlre.html#Regular-Expressions)
in `link_match` to determine that a tag should be rendered as a link
instead.  For example, if you tag your trips in the format
`YYYY-MM-DD-foo`, you could use

    link_match:
      - ^\d\d\d\d-\d\d-\d\d-

to render them as links.  So the ledger transaction header

    2018-02-02 * Train Brussels airport to city
        ; :2018-02-02-brussels-fosdem:debian:

would become the following in beancount:

    2018-02-02 * "Train Brussels airport to city" ^2018-02-02-brussels-fosdem #debian


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
