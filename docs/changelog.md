# ledger2beancount releases

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

