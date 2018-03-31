ledger2beancount
================

ledger2beancount is a script to automatically convert
[Ledger](https://www.ledger-cli.org/)-based textual ledgers to
[Beancount](http://furius.ca/beancount/) ones.

Conversion is based on (concrete) syntax, so that information that are not
meaningful for accounting reasons but still valuable (e.g., comments,
formatting, etc.) can be preserved.

The syntax of beancount is expected to become slightly less restrictive
as some missing features are implemented (such as UTF-8 for account names
and tags on a posting-level).  ledger2beancount aims to be compatible with
the latest official release of beancount.


Installation
------------

ledger2beancount is a Perl script and relies on the following Perl
modules:

* Carp::Assert
* Config::Onion
* Date::Calc
* DateTime::Format::Strptime
* File::BaseDir
* Getopt::Long::Descriptive
* YAML::XS

If you use Debian, you can install the dependencies with this command:

    sudo apt install libcarp-assert-perl libconfig-onion-perl \
        libdate-calc-perl libfile-basedir-perl libyaml-libyaml-perl \
        libgetopt-long-descriptive-perl libdatetime-format-strptime-perl

ledger2beancount itself consists of one script.  You can clone the
repository and run the script directly or copy it to `$HOME/bin` or
a similar location:

    git clone https://github.com/zacchiro/ledger2beancount/
    ./bin/ledger2beancount examples/simple.ledger

### Arch Linux

ledger2beancount is available on [AUR](https://aur.archlinux.org/packages/ledger2beancount/):

```
yaourt -S ledger2beancount
```


Configuration
-------------

ledger2beancount can use a configuration file.  It will search for
the config file `ledger2beancount.yml` and if that is not found for
`$HOME/.config/ledger2beancount/config.yml`.  You can also pass an
alternative config file via `--config/-c`.  The file must end in `.yml`
or `.yaml`.  See the sample config file for the variables you can use.

While the configuration file is optional, you may have to define a
number of variables for ledger2beancount to work correctly with your
ledger files:

* `ledger_indent` sets the indentation level used in your ledger file
  (by default `4`).
* `date_format` has to be configured if you don't use the date format
  `YYYY-MM-DD`.
* `decimal_comma` has to be set to `true` if you use commas as the
  decimal separator (for example, `10,12 EUR` meaning 10 Euro and
  12 cents).
* `commodity_map` defines mappings from ledger to beancount commodities.
  You have to set this if you use commodity codes like `€` or `£` (to
  map them to `EUR` and `GBP`, respectively).

Other variables can be set to use various functionality offered by
ledger2beancount.  Please read the [section on features](#features)
to learn about these variables.


Usage
-----

ledger2beancount accepts input from `stdin` or from a file and will write
the converted data to `stdout`.  You can run ledger2beancount like this
on the example provided:

    ledger2beancount examples/simple.ledger > simple.beancount

After you convert your ledger file, you should validate the generated
beancount file with `bean-check` and fix all errors:

    bean-check simple.beancount

You should also inspect the generated beancount file to see if it
looks correct to you.  Please note that ledger2beancount puts notes
at the beginning of the generated beancount file if it encounters
problems with the conversion.

If you believe that ledger2beancount could have produced a better
conversion or if you get an error message from ledger2beancount, please
[file a bug](https://github.com/zacchiro/ledger2beancount/issues) along
with a simple test case.


Features
--------

ledger2beancount supports most of the syntax from ledger.  It also offers
some features to improve the conversion from ledger to beancount.

If you're new to beancount, we suggest you read this section in parallel
to the [illustrated ledger file provided](../examples/illustrated.ledger).
This example ledger file explains differences between ledger and beancount,
shows how ledger syntax is converted to beancount and describes how you
can use the features described in this section to improve the conversion
from ledger to beancount.  The illustrated example uses the same
subsections as this section, so it's easy to follow in parallel.

You can convert the illustrated ledger file to beancount like this:

    ledger2beancount --config examples/illustrated.yml examples/illustrated.ledger

But please be aware that it doesn't pass `bean-check`.  See the comments in
the file as to why.

Note on **regular expressions**: many of the features described below require
you to specify regular expressions in ledger2beancount configuration file. The
expected syntax (and semantics) for all such values is that of
[Perl regular expressions](https://perldoc.perl.org/perlre.html#Regular-Expressions).


### Accounts

ledger2beancount will convert ledger account declarations to beancount
`open` statements using the `account_open_date` variable as the opening
date.  The `note` is used as the `description`.

Unlike ledger, beancount requires declarations for all account names.
If an account was not declared in your ledger file but used,
ledger2beancount will automatically create an `open` statement in
beancount.  You can turn this off by setting `automatic_declarations`
to `false`.  This is useful if you have include files and run
ledger2beancount several times since duplicate `open` statements for
the same account will result in an error from beancount.

ledger2beancount replaces ledger account names with valid beancount
accounts and therefore performs the following transformations
automatically:

1. Replaces space and other invalid characters with dash
   (`Liabilities:Credit Card` becomes `Liabilities:Credit-Card`)
2. Replaces account names starting with lower case letters with
   upper case letters (`Assets:test` becomes `Assets:Test`)
3. Strips accents and umlauts because they are currently not
   supported in beancount ([issue
   161](https://bitbucket.org/blais/beancount/issues/161)).
4. Ensures the first letter is a letter or number by replacing
   a non-letter first character with an `X`.

While these transformations lead to valid beancount account names,
they might not be what you desire.  Therefore, you can add account
mappings to `account_map` to map the transformed account names to
something different.  The mapping will work on your ledger account
names and on the account names after the transformation.

Unlike ledger, beancount expects all account names to start with one
of five account types (`Assets`, `Liabilities`, `Equity`, `Expenses`,
and `Income`, although this can be configured).  If you use more than
five account types, you will have to rename them.  Currently,
ledger2beancount doesn't have an option to map the account types.

Ledger's `apply account` and `alias` directives are supported.  The
mapping of account names described above is done after these directives.


### Amounts

In ledger, amounts can be placed after the amount.  This is converted
to beancount with the the amount first, followed by the commodity.

If you use commas as the decimal separator (i.e. values like `10,12`,
using the ledger option `--decimal-comma`) you have to set the
`decimal_comma` option to `true`.  Please note that commas are not
supported as the decimal separator in beancount at the moment ([issue
204](https://bitbucket.org/blais/beancount/issues/204)) so your
amounts are converted not to use comma as the decimal separator.

Commas as separators for thousands (e.g. `1,000,000`) are supported by
beancount.


### Commodities

Like accounts, ledger2beancount will convert ledger commodity
declarations to beancount.  The `note` is converted to `name`.  As with
account names, ledger2beancount will create `commodity` statements for
all commodities used in your ledger file (if `automatic_declarations`
is `true`).

ledger2beancount will automatically convert commodities to valid
beancount commodities.  This involves replacing all invalid characters
with a dash (a character allowed in beancount commodities but not in
ledger commodities), stripping quoted commodities, making the commodity
uppercase and limiting it to 24 characters.  Furthermore, the first
character will be replaced with an `X` if it's not a letter and the
same will be done for the last character if it's not a letter or digit.

If you require a mapping between ledger and beancount commodities, you
can use `commodity_map`.  You can use your ledger commodity names or
the names after the transformation in the map to perform a mapping to
another commodity name.

Commodity symbols (like `$`, `€` and `£`) are supported and converted to
their respective commodity codes (like `USD`, `EUR`, `GBP`).  Update
`commodity_map` if you use other symbols.


### Flags

ledger2beancount supports both transaction flags ([transaction
state](https://www.ledger-cli.org/3.0/doc/ledger3.html#Transaction-state))
and account flags ([state
flags](https://www.ledger-cli.org/3.0/doc/ledger3.html#State-flags)).


### Dates

ledger supports a wide range of date formats whereas beancount requires
all dates in the format `YYYY-MM-DD` (ISO 8601).  The variable
`date_format` has to be set if you don't use ISO 8601 for the dates in
your ledger file.  `date_format` uses the same format as the ledger
options `--input-date-format` and `--date-format` (see `man 1 date`).

Ledger allows dates without a year if the year is declared using the `Y`
or `year` directive.  If `date_format_no_year` is set, ledger2beancount
can convert such dates to `YYYY-MM-DD`.

While ledger2beancount itself doesn't read your ledger config file, the
script `ledger2beancount-ledger-config` can be used to parse your ledger
config file (`~/.ledgerrc`) or your ledger file (ledger files may contain
ledger options) to output the correct config option for ledger2beancount.


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
several features to determine the payee from the transaction itself.

You can set `payee_split` and define a list of regular expressions which
allow you to split ledger's payee field into payee and narration.  You
have to use regular expressions with the named capture groups `payee`
and `narration`.  For example, given the ledger transaction header

    2018-03-18 * Supermarket (Tesco)

and the configuration

    payee_split:
      - (?<narration>.*?)\s+\((?<payee>Tesco)\)

ledger2beancount will create this beancount transaction header:

    2018-03-18 * "Tesco" "Supermarket"

In other words, `payee_split` allows you to split the ledger payee
into payee and narration in beancount.  `payee_split` is a list of
regular expressions and ledger2beancount stops when a match is
found.

Furthermore, you can use `payee_match` to match based on the ledger
payee field and assign payees according to the match.  This variable
is a hash consisting of regular expressions and the corresponding
payees.  For example, if your ledger contains a transaction like:

    2018-03-18 * Oyster card top-up

you can use

    payee_match:
      ^Oyster card top-up: Transport for London

to match the line and assign the payee `Transport for London`:

    2018-03-18 * "Transport for London" "Oyster card top-up"

Unlike `payee_split`, the full payee field from ledger is used as the
narration in beancount.  Again, ledger2beancount stops after the first
match.  Beancount comes with a plugin called `fix_payees` which
offers a similar functionality to `payee_match`: it renames payees
based on a set of rules which allow you to match account names,
payees and the narration.  The difference is that ledger2beancount's
`payee_match` will write the matched payee to the beancount file
whereas the `fix_payees` plugin leaves your input file intact and
assigns the new payee within beancount.

Please note that the `payee_match` is done after `payee_split` and
`payee_match` is evaluated even if `payee_split` matched.  This allows
you to remove some information from the narration using `payee_split`
while overriding the found payee using `payee_match`.

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

Ledger's `apply tag` directive is supported.  However, tags are ignored
when `tag_as_metadata` is `true`.

Note that tags can be defined in ledger using a `tag` directive.  This
is not required in beancount and there's no equivalent directive so
all `tag` directives are skipped.


### Links

Beancount differentiates between tags and links whereas ledger doesn't.
Links can be used in beancount to link several transactions together.
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
ledger2beancount therefore treats them as regular costs (or, rather,
as regular prices).


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
and stocks).  Since most currency codes consist of 3 characters (`EUR`,
`GBP`, `USD`, etc), the script makes a simple conversion (`10.00 EUR @ 0.90
GBP`) if both commodities consist of 3 characters.  Otherwise it
associates a cost (`1 LU0274208692 {48.67 EUR}`).  Since some 3 character
symbols might be commodities instead of currencies (e.g. `ETH` and `BTH`), the
`currency_is_commodity` variable can be used to treat them as commodities
and associate a cost in conversions.  Similarly, `commodity_is_currency`
can be used to configure commodities that should be treated as currencies
in the sense that no cost is retained.  This is useful if you, for
example, track miles or hotel points that are sometimes redeemed for a
cash value.  Both of these variables expect beancount commodities, i.e.
after transformation and mapping.  (Note that beancount itself uses the
terms "commodity" and "currency" interchangeably.)


### Balance assertions

Ledger balance assertions are converted to beancount `balance` statements.
Please note that beancount evaluates balance assertions at the beginning of
the day whereas ledger evaluates them at the end of the transaction.
Therefore, we schedule the balance assertion for the day *after* the
original transaction.  This assumes that there are no other transactions
on the same day that change the balance again for this account.


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


### Virtual postings

Ledger's concept of [virtual postings](https://www.ledger-cli.org/3.0/doc/ledger3.html#Virtual-postings)
does not exist in beancount.  Ledger has two types of virtual postings:
those in parentheses (`(Budget:Food)`) which don't have to balance and
those in brackets (`[Budget:Food]`) which have to balance.  The former
violate the accounting equation and can't be converted to beancount.
The latter can be converted by making them into "real" accounts.
ledger2beancount will do this if the `convert_virtual` option is set to
`true`.  By default, ledger2beancount will simply skip all virtual
postings.

If you set `convert_virtual` to `true`, be aware that all account names
have to start with one of five assets classes (`Assets`, etc).  This is
often not the case for virtual postings, so you will have to rename or
map these account names.


### Inline math

Very simple inline math is supported in postings.  Specifically, basic
multiplications and divisions are supported, such as shown in the
following transactions:

    2018-03-26 * Simple inline math
        Assets:Test1            1 GBP @ (1/1.14 EUR)
        Assets:Test2                       -0.88 EUR

    2018-03-26 * Simple inline math
        Assets:Test1                     (1 * 3 GBP)
        Assets:Test2                          -3 GBP

Support for more complex inline math would require substantial changes
to the parser.


Unsupported features in beancount
---------------------------------

The following features are not supported in beancount and therefore
commented out during the conversion from ledger to beancount:

* Automated transactions
* Commodity conversion (`C AMOUNT1 = AMOUNT2`)
* Commodity format (`D AMOUNT`)
* Commodity pricing: ignore pricing (`N SYMBOL`)
* Timeclock support (`I`, `i`, `O`, `o`, `b`, `h`)
* Periodic transactions


Unsupported features in ledger2beancount
----------------------------------------

The following ledger features are currently not supported by
ledger2beancount:

* Balance assignments are currently not supported but would be
  easy to add by using beancount's `pad`.
* Fixated prices (`=$10` syntax and the `fixed` directive)
* The `define` directive

Contributions [are welcome!](CONTRIBUTING.md)


Bugs and Contributions
----------------------

If you find any bugs in ledger2beancount or believe the conversion from
ledger to beancount could be improved, please [open an
issue](https://github.com/zacchiro/ledger2beancount/issues).  Please
include a small test case so we can reproduce the problem.

See [the contributing guide](CONTRIBUTING.md) for more information on
how to contribute to ledger2beancount.

