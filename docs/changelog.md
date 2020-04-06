# ledger2beancount releases

## 2.1 (2020-04-06)

* Handle postings with posting dates and comments but no amount
* Show transactions with only one posting (without `bucket`)
* Adding spacing between automatic declarations
* Preserve preliminary info at the top

## 2.0 (2020-02-22)

* Handle comments in `account` and `commodity` declarations
* Handle transactions with a single posting (without `bucket`)
* Handle empty metadata values
* Rewrite Emacs modeline

## 1.8 (2019-06-12)

* Add support for `apply year`
* Fix incorrect account mapping of certain accounts
* Handle fixated commodity and postings without amount
* Improve behaviour for invalid `end` without `apply`
* Improve error message when date can't be parsed
* Deal with account names consisting of a single letter
* Ensure account names don't end with a colon
* Skip ledger directives `eval`, `python`, and `value`
* Don't assume all filenames for `include` end in `.ledger`
* Support `price` directives with commodity symbols
* Support decimal commas in `price` directives
* Don't misparse balance assignment as commodity
* Ensure all beancount commodities have at least 2 characters
* Ensure all beancount metadata keys have at least 2 characters
* Don't misparse certain metadata as implicit conversion
* Avoid duplicate `commodity` directives for commodities with name collisions
* Recognise deferred postings
* Recognise `def` directive

## 1.7 (2019-04-22)

* Don't misparse account and commodity with mixed tab/space separators
* Rename account names consisting of a root name without subaccount
* Warn when non-standard root names are used
* Avoid duplicate open directives for accounts with name collisions
* Don't warn for renamed tags that won't show up in the beancount file
* Add `account_regex` option to mass rename account names
* Add man page and improve documentation

## 1.6 (2019-03-25)

* Add support for fixated prices and costs
* Handle account names that contain brackets
* Don't parse trailing tabs as part of the account name
* Escape backslashes in the narration

## 1.5 (2019-01-30)

* Replace commodities in balance assertions
* Add support for posting-level dates
* Add support for hledger features
* Add support for balance assignments
* Handle comments on the same line as the payee
* Handle comments, tags and metadata on postings with balance assertions
* Handle metadata on postings with cost or price information
* Handle simple implicit conversions

## 1.4 (2018-12-01)

* Don't parse trailing whitespace as part of the account name
* Replace commodities in lot costs
* Avoid mangling of lot cost with other lot information
* Don't require whitespace between {} and @ in lot information

## 1.3 (2018-09-29)

* Handle tags on the same line as postings correctly
* Allow (commented) beancount entries in ledger input file
* Handle amounts without leading zeroes

## 1.2 (2018-05-17)

* Updates for beancount 2.1.0:
  * Allow UTF-8 letters and digits in account names
  * Allow full-line comments in transactions
  * Allow transaction tags and links on multiple lines
* Handle posting tags on multiple lines
* Always convert posting-level tags to metadata
* Improve parsing of the transaction header

## 1.1 (2018-05-01)

* Happy International Workers' Day release!
* Handle block comments without indentation correctly
* Preserve comments for postings with lots
* Use beancount's `pushtag/poptag` for ledger's `apply tag`
* Handle `tag` directives with associated commands correctly
* Allow option `link_match` to work with `tag_as_metadata: true`
* Handle posting-level tags without indentation correctly with
  `tag_as_metadata: false`
* Ensure `payee_match` is predictable
* Preserve comments for postings with lots
* Embed an optional beancount header to the converted file to
  specify beancount options
* Convert ledger metadata keys to valid beancount metadata keys
* Add conversion notes when accounts, commodities or metadata
  keys are automatically renamed by ledger2beancount
* Add capability to ignore certain lines
* Keep whitespace intact when renaming account names
* Improve documentation on assigning payees based on transactions
* Add more test cases
* Run the test suite only if something has changed

## 1.0 (2018-03-30)

* Initial release with support for the majority of features from ledger

