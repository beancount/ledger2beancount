[![Build Status](https://travis-ci.org/zacchiro/ledger2beancount.svg?branch=master)](https://travis-ci.org/zacchiro/ledger2beancount)


ledger2beancount
================

A script to automatically convert [Ledger](https://www.ledger-cli.org/)-based
textual ledgers to [Beancount](http://furius.ca/beancount/) ones.

Conversion is based on (concrete) syntax, so that information that are not
meaningful for accounting reasons but still valuable (e.g., comments,
formatting, etc.) can be preserved.

ledger2beancount relies on some configuration data.  It will search for
the config file `ledger2beancount.yml` and if that is not found for
`$HOME/.config/ledger2beancount/config.yml`.  See the sample config
file for the variables.


Dependencies
------------

ledger2beancount uses several Perl modules:

* Carp::Assert
* Config::Onion
* Date::Calc
* File::BaseDir
* YAML::XS

If you use Debian, you can install them with:

    sudo apt install libcarp-assert-perl libconfig-onion-perl \
        libdate-calc-perl libfile-basedir-perl libyaml-libyaml-perl


Features
--------

Note on **regular expressions**: many of the features described below require
you to specify regular expressions in ledger2beancount configuration file. The
expected syntax (and semantics) for all such values is that of
[Perl regular expressions](https://perldoc.perl.org/perlre.html#Regular-Expressions).


### Accounts

ledger2beancount will convert ledger account declarations to beancount
`open` statements using the `account_open_date` variable as the opening
date.  The `note` is used as the `description`.

ledger2beancount replaces ledger account names with valid beancount
accounts and therefore performs the following three transformations
automatically:

1. Replaces space with dash (`Liabilities:Credit Card` becomes
   `Liabilities:Credit-Card`)
2. Replaces account names starting with lower case letters with
   upper case letters (`Assets:test` becomes `Assets:Test`)
3. Moves digits from the beginning of the account name to the
   end (`Assets:99Ranch` becomes `Assets:Ranch99`)

While these transformations lead to valid beancount account names,
they might not be what you desire.  Therefore, you can add account
mappings to `account_map` to map the transformed account names to
something different.


### Commodities

Like accounts, ledger2beancount will convert ledger commodity
declarations to beancount.  The `note` is converted to `name`.

ledger2beancount will automatically convert commodities to valid
beancount commodities.  This involves replacing all invalid characters
with a dash (a character allowed in beancount commodities but not in
ledger commodities), stripping quoted commodities, making the commodity
uppercase and limiting it to 24 characters.

If you require a mapping between ledger and beancount commodities, you
can use `commodity_map`.  You can use your ledger commodity names or
the names after the transformation in the map to perform a mapping to
another commodity name.

Commodity symbols (like $, € and £) are not supported.


### Flags

ledger2beancount supports both transaction flags ([transaction
state](https://www.ledger-cli.org/3.0/doc/ledger3.html#Transaction-state))
and account flags ([state
flags](https://www.ledger-cli.org/3.0/doc/ledger3.html#State-flags)).


### Dates

ledger supports a wide range of date formats whereas beancount requires
all dates in the format YYYY-MM-DD (ISO 8601).  The regular expression
from the config variable `date_match` is used to match the date from the
ledger file.  You can adapt it to your needs but make sure that your
regular expression contains the named capture groups `year`, `month` and
`day`.

Ledger allows dates without a year if the year is declared using the `Y`
or `year` directive.  If `date_match_no_year` is set (with the capture
groups `month` and `day`), ledger2beancount can convert such dates to
YYYY-MM-DD.


### Auxiliary dates

Beancount currently doesn't support ledger's [auxiliary dates (or effective
dates)](https://www.ledger-cli.org/3.0/doc/ledger3.html#Auxiliary-dates)
(but there is a proposal to support this functionality in a different way),
so these are stored as metadata according to the `auxdate_tag` variable.
Unset the variable if you don't want auxiliary dates to be stored as
metadata.  Account and posting-level auxiliary dates are supported.


### Transaction codes

Beancount doesn't support ledger's [transaction
codes](https://www.ledger-cli.org/3.0/doc/ledger3.html#Codes).  These are
therefore stored as metatags if `code_tag` is set.


### Narration

The ledger payee information, which is generally used as free-form text
to describe the transaction, is stored in beancount's narration field
and properly quoted.


### Payees

Ledger has limited support for payees.  A `payee` metadata key can be set
but this also overrides the free-form text to describe the transaction.
Payees can also be declared explicitly in ledger but this is not required
by beancount, so such declarations are ignored (they are preserved as
comments).

Since ledger has limited support for payees, ledger2beancount offers
several features to determine the payee from on the transaction.

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
is a hash consisting of regular expressions and the corresponding
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


### Metadata

Account and posting metadata are converted to beancount syntax.  Metadata
keys used in ledger can be converted to different keys in beancount using
`metadata_map`.  Metadata can also be converted to links (see below).

ledger2beancount also supports
[typed metadata](https://www.ledger-cli.org/3.0/doc/ledger3.html#Typed-metadata)
(i.e. `key::` instead of `key:`) and doesn't quote the values accordingly,
but you should make sure the values are valid in beancount.


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
not treated the same way by beancount as proper tags.

If `tag_as_metadata` is `false`, transaction tags will be put after the
narration as tags.  Because of the limitation in beancount, posting-level
tags are currently ignored.


### Links

Beancount differentiates between tags and links whereas ledger doesn't.
ledger2beancount offers two mechanisms to convert ledger tags and
metadata to links.

First, you can define a list of metadata tags in `link_tags` whose
values should be converted to beancount links instead of metadata.  For
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
any whitespace.

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


### Comments

Comments are supported.  Since beancount currently [doesn't allow
full-line comments within
transactions](https://bitbucket.org/blais/beancount/issues/143), these
are stored as metadata.


### Virtual costs

Beancount does not have a concept of [virtual
costs](https://www.ledger-cli.org/3.0/doc/ledger3.html#Virtual-posting-costs)
([issue 248](https://bitbucket.org/blais/beancount/issues/248)).
ledger2beancount therefore treats them as regular costs.


### Lots

Lot costs and prices are supported, including per-unit and total lot
costs.  Lot dates and lot notes are converted to beancount.

The behaviour of ledger and beancount is different when it comes to
costs.  In ledger, the statement

    Assets:Test          10.00 EUR @ 0.90 GBP

creates the lot `10.00 EUR {0.90 GBP}`.  In beancount, this is not the
case and a cost is only associated if done so explicitly:

    Assets:Test          10.00 EUR {0.90 GBP}

This makes automatic conversion tricky because some statements should be
simple conversions without associating a cost whereas it's vital to
preserve the cost in other conversions.

Generally, it doesn't make sense to preserve the cost for currency
conversion (as opposed to conversions involving commodities like shares
and stocks).  Since most currency codes consist of 3 characters (EUR,
GBP, USD, etc), the script makes a simple conversion (`10.00 EUR @ 0.90
GBP`) if both commodities consist of 3 characters.  Otherwise it
associates a cost (`1 LU0274208692 {48.67 EUR}`).  Since some 3 character
symbols might be commodities instead of currencies (e.g. ETH and BTH), the
`currency_is_commodity` variable can be used to treat them as commodities
and associate a cost in conversions.  Similarly, `commodity_is_currency`
can be used to configure commodities that should be treated as currencies
in the sense that no cost is retained.  This is useful if you, for
example, track miles or hotel points, that are sometimes redeemed for a
cash value.  (Note that beancount itself uses the terms "commodity" and
"currency" interchangeably.)


### Balance assertions

Ledger balance assertions are converted to beancount `balance` statements.


### Automated transactions

Ledger's [automated
transactions](https://www.ledger-cli.org/3.0/doc/ledger3.html#Automated-Transactions)
are not supported in beancount.  They are added as comments to the
beancount file.


### Periodic transactions

Ledger's [periodic
transactions](https://www.ledger-cli.org/3.0/doc/ledger3.html#Periodic-Transactions)
are not supported in beancount.  They are added as comments to the
beancount file.


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
