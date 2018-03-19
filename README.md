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


Features
--------

Note on **regular expressions**: many of the features described below require
you to specify regular expressions in ledger2beancount configuration file. The
expected syntax (and semantics) for all such values is that of
[Perl regular expressions](https://perldoc.perl.org/perlre.html#Regular-Expressions).


### Narration

The ledger payee information, which is generally used as free-form text
to describe the transaction, is stored in beancount's narration field
and properly quoted.


### Payees

Ledger has limited support for payees.  A `payee` metadata key can be set
but this also overrides the free-form text to describe the transaction.
In ledger2beancount, we offer several features to determine the payee.

You can set `payee_split` and define a list of regular expressions which
allow you to split ledger's payee field into payee and narration.  You
have to use regular expressions with the named capture groups `payee`
and `narration`.  For example, given the ledger transaction

    2018-03-18 * Supermarket (Tesco)

and the configuration

    payee_split:
      - (?<narration>.*?)\s+\((?<payee>Tesco)\)

ledger2beancount will create this beancount transaction:

    2018-03-18 * "Tesco" "Supermarket"

In other words, `payee_split` allows you to split the ledger payee
into payee and narration in beancount.

`payee_split` is a list of regular expressions and we stop when we
find a match.

Furthermore, you can use `payee_match` to match based on the ledger
payee field and assign payees according to the match.  This variable
is a hash consisting of a regular expressions and the corresponding
payees.  For example, if your ledger contains a transaction like:

    2018-03-18 * Oyster card top-up

you can use

    payee_split:
      ^Oyster card top-up: Transport for London

to match the line and assign the payee `Transport for London`:

    2018-03-18 * "Transport for London" "Oyster card top-up"

Unlike `payee_split`, the full payee field from ledger is used as the
narration in beancount.  Again, we stop after the first match.

Please note that the `payee_match` is done after `payee_split` and we run
`payee_match` even if `payee_split` matched.  This allows you to remove
some information from the narration using `payee_split` while overriding
the found payee using `payee_match`.

Finally, metadata describing a payee or payer will be used to set the
payee.  The tags used for that information can be specified in
`payee_tag` and `payer_tag`.


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
tags are currently ignored.


### Links

Beancount differentiates between tags and links whereas ledger doesn't.
ledger2beancount offers two mechanisms to convert ledger tags and
metadata to links.

First, you can define a list of metadata tags in `link_tags` whose
value should be converted to a beancount link instead of metadata.  For
example:

    link_tags:
      - Invoice

with the ledger input

    2018-03-19 * Invoice 4
        ; Invoice:: 4

will be converted to

    2018-03-19 * Invoice 4 ^4

instead of

    2018-03-19 * Invoice 4 #4

Tags are case insensitive.  Be aware that the metadata must not contain
whitespace.

Since posting-level links are currently not allowed in beancount, they
are stored as metadata.

Second, you can define regular expressions in `link_match` to determine
that a tag should be rendered as a link instead.  For example, if you
tag your trips in the format `YYYY-MM-DD-foo`, you could use

    link_match:
      - ^\d\d\d\d-\d\d-\d\d-

to render them as links.  So the ledger transaction header

    2018-02-02 * Train Brussels airport to city
        ; :2018-02-02-brussels-fosdem:debian:

would become the following in beancount:

    2018-02-02 * "Train Brussels airport to city" ^2018-02-02-brussels-fosdem #debian


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
