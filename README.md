[![Build Status](https://travis-ci.org/beancount/ledger2beancount.svg?branch=master)](https://travis-ci.org/beancount/ledger2beancount)


# ledger2beancount

A script to automatically convert [Ledger](https://www.ledger-cli.org/)-based
textual ledgers to [Beancount](http://furius.ca/beancount/) ones.

Conversion is based on (concrete) syntax, so that information that is not
meaningful for accounting reasons but still valuable (e.g., comments,
formatting, etc.) can be preserved.


## Usage

ledger2beancount accepts input from `stdin` or from a file and will write
the converted data to `stdout`.  You can run ledger2beancount like this:

    ledger2beancount test.ledger > test.beancount


## Installation

Please see [the installation information](docs/installation.md) for
dependencies and installation instructions.

## Documentation

ledger2beancount comes with extensive documentation.  You can also [read
the documentation online](https://ledger2beancount.readthedocs.io/)
thanks to Read the Docs.

## Features

The majority of features from ledger are supported by ledger2beancount.  Here
is an overview of fully supported, partly supported and unsupported features.
Please refer to [the user guide](docs/guide.md) for more details on how to
use ledger2beancount and to configure it to your needs.

### Fully supported

* Accounts
  * Account declarations (`account ...`)
  * Conversion of invalid account names
  * Mapping of account names
  * Directive `apply account`
  * Account aliases (`alias`)
* Balance assignments
* Balance assertions
* Comments
  * Comments in and outside of transactions
  * Directives `comment` and `test`
* Commodities
  * Commodity declarations (`commodity ...`)
  * Commodity symbols like `$`, `£` and `€`
  * Commodities placed in front and after the amount
  * Conversion of invalid commodities
  * Mapping of commodities
* Directives
  * `bucket` / `A`
  * `include`
  * `Year` / `Y`, `apply year`
* Flags
  * State flags (posting flags)
  * Transaction state (transaction flags)
* Inline math
* Lots
  * Lot dates
  * Lot notes
  * Per unit and total costs and prices
  * Conversion of ledger price to beancount cost
* Metadata
* Payees
  * Obtain payee from metadata
  * Split payee into payee and narration
  * Assign payee based on narration
* Tags
  * Directive `apply tag`
  * Mapping `#tags` to `^links`

### Partly supported

* Amounts
  * Decimal comma (not supported in beancount)
* Dates
  * Dates on posting-level (no equivalence in beancount)
  * Auxiliary dates (no equivalence in beancount)
  * Effective dates (no equivalence in beancount)
* Deferred postings (no equivalence in beancount)
* Directives
  * `eval`: skipped (not supported in beancount)
  * `import`: skipped (not supported in beancount)
  * `payee`: skipped (not needed in beancount)
  * `python`: skipped (not supported in beancount)
  * `tag`: skipped (not needed in beancount)
  * `value`: skipped (not supported in beancount)
* Fixated prices (`=$10` and the `fixed` directive)
* Lot value expressions (no equivalence in beancount)
* Tags and links on posting-level (not supported by beancount)
* Transaction codes: stored as metadata (no equivalence in beancount)
* Virtual postings: can be skipped or converted to real postings
* Virtual posting costs: recognised but skipped (no equivalence in beancount)

### Not supported

* Amounts without commodities
* Automated transactions
* Directives
  * `assert`
  * `C` (commodity equivalences)
  * `check`
  * `D`
  * `define` and `def`
  * `expr`
  * `N`
  * Timeclock (`I`, `i`, `O`, `o`, `b`, `h`)
* Periodic transactions


## Authors

* Stefano Zacchiroli `<zack@upsilon.cc>`
* Martin Michlmayr `<tbm@cyrius.com>`


## License

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

    SPDX-License-Identifier: GPL-3.0-or-later
