# ledger2beancount releases

## 1.2 (unreleased)

* Allow full-line comments in transactions (requires beancount > 2.0.0).

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
* Keep whitespace intact when renaming account names.
* Improve documentation on assigning payees based on transactions
* Add more test cases
* Run the test suite only if something has changed

## 1.0 (2018-03-30)

* Initial release with support for the majority of features from ledger

