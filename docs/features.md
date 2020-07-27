# Features

The majority of features from [ledger](https://ledger-cli.org/) and [hledger](https://hledger.org/) are supported by ledger2beancount.

## Fully supported

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
    * Transaction state (transaction flags)
* Inline maths
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

## Partly supported

* Amounts
    * Decimal comma (not supported in beancount)
* Dates
    * Dates on posting-level (no equivalence in beancount)
    * Auxiliary dates (no equivalence in beancount)
    * Effective dates (no equivalence in beancount)
* Deferred postings (no equivalence in beancount)
* Directives
    * `define` and `def` (no functions)
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

## Unsupported in beancount

The following features are not supported in beancount and therefore
commented out during the conversion from ledger to beancount:

* Amounts without commodities
* Automated transactions
* Checks and assertions (`check` and `assert`)
* Commodity conversion (`C AMOUNT1 = AMOUNT2`)
* Commodity format (`D AMOUNT`)
* Commodity pricing: ignore pricing (`N SYMBOL`)
* Timeclock support (`I`, `i`, `O`, `o`, `b`, `h`)
* Periodic transactions

## Supported features from hledger

The following syntax from [hledger](https://hledger.org/) is supported if the `hledger` configuration variable is set:

* Account aliases can be regular expressions
* Amounts
    * All digit group marks (space, comma, and period) are supported
    * Number format can be specified via `commodity` and `D` directives
* Narration: support for `payee | note` format
* Posting dates: `date` and `date2`
* Tags: `tag1:, tag2:, tag2: info`
* Balance assertions
    * Sub-account balance assertions: recognised but not supported in beancount
    * Total balance assertions: recognised but no equivalent in beancount
* Directives
    * `end aliases`

