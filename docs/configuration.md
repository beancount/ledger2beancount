# Configuration

ledger2beancount can use a configuration file.  It will search for
the config file `ledger2beancount.yml` in the current working directory.
If that file is not found, it will look for
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

Additionally, these options are useful to configure beancount:

* `operating_currencies`: a list of the currencies you frequently use.
* `beancount_header`: a file which is embedded at the beginning of
   the converted beancount file which can include beancount `option`
   statements, `plugin` directives, `query` information and more.

Other variables can be set to use various functionality offered by
ledger2beancount.  All variables are described below.  Please read
the [user guide](guide.md) to learn how to use these variables to
configure ledger2beancount for your needs.

## Input options

The following options may be needed for ledger2beancount to interpret
your ledger files correctly.

date_format

:   The date format used in your ledger file (default: `%Y-%m-%d`).

date_format_no_year

:   The date format for dates without the year when ledger's `Y`/`year`
    directive is used (default: `%m-%d`).

ledger_indent

:   Sets the indentation level used in your ledger file (default: `4`).

decimal_comma

:   Parses amounts with the decimal comma (e.g. `10,00 EUR`).  Set this
    option to `true` if you use option `--decimal-comma` in ledger.

hledger

:   Tells ledger2beancount whether to attempt to parse hledger-specific
    features.

## Other options

beancount_indent

:   Sets the indentation level for the generated beancount file (default: `2`).

operating_currencies

:   A list of frequently used currencies.  This is used by fava, the web
    UI for beancount.

automatic_declarations

:   Emit account and commodity declarations. (Default: `true`)

    Note: the declarations done in ledger via `account` and
    `commodity` declarations are always converted.  If this option
    is `true`, declarations are created for those which have not
    been explicitly declared in ledger but used.

account_open_date

:   The date used to open accounts (default: `1970-01-01`).

commodities_date

:   The date used to create commodities (default: `1970-01-01`).

beancount_header

:   Specifies a file which serves as a beancount "header", i.e. it's put
    at the beginning of the converted beancount file.  You can use such
    a header to specify options for beancount, such as `option "title"`,
    define `plugin` directives or beancount `query` information.

ignore_marker

:   Specifies a marker that tells ledger2beancount to ignore a line if the
    marker is found.

keep_marker

:   Specifies a marker that tells ledger2beancount to take a line from the
    input that is commented out, uncomment it and display it in the output.

convert_virtual

:   Specifies whether virtual postings should be converted.  If set to
    `true`, virtual postings in brackets will be made into real accounts.
    (Virtual postings in parentheses are always ignored, regardless of this
    option.)

account_map

:   Specifies a hash of account names to be mapped to other account names.

account_regex

:   Specifies a hash of regular expressions to replace account names.

commodity_map

:   Specifies a mapping of ledger commodities to beancount commodities.

metadata_map

:   Specifies a mapping of ledger metadata keys to corresponding beancount keys.

payee_tag

:   Specify a metadata tag (after the mapping done by `metadata_map`) used to set the payee.

payer_tag

:   Specify a metadata tag (after the mapping done by `metadata_map`) used to set the payee.

payee_split

:   Specifies a list of regular expressions to split ledger's payee field
    into payee and narration.  You have to use the named capture groups
    `payee` and `narration`.

payee_match

:   Specifies a list of regular expressions and corresponding payees.  The
    whole ledger payee becomes the narration and the matched payee from the
    regular expression becomes the payee.

postdate_tag

:   Specifies the metadata tag to be used to store posting dates. (Use the
    empty string if you don't want the metadata to be added to beancount.)

auxdate_tag

:   Specifies the metadata tag to be used to store auxiliary dates (also
    known as effective dates; or `date2` in hledger). (Use the empty
    string if you don't want the metadata to be added to beancount.)

code_tag

:   Specifies the metadata tag to be used to store transaction codes.
    (Use the empty string if you don't want the metadata to be added to
    beancount.)

link_match

:   Specifies a list of regular expressions that will cause a tag to be
    rendered as a link.

link_tags

:   Specifies a list of metadata tags whose values should be converted to
    beancount links instead of metadata.  Tags are case insensitive and
    values must not contain whitespace.

currency_is_commodity

:   Specifies a list of commodities that should be treated as commodities
    rather than currencies even though they consist of 3 characters (which
    is usually a characteristic of a currency).  Expects beancount
    commodities (i.e. after transformation and mapping).

commodity_is_currency

:   Specifies a list of commodities that should be treated as currencies
    (in the sense that cost is not retained).  Expects beancount
    commodities (i.e. after transformation and mapping).

