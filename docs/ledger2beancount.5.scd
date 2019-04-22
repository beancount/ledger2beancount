ledger2beancount(5)

# NAME

ledger2beancount - configuration file for *ledger2beancount*(1)

# INPUT OPTIONS

The following options may be needed for *ledger2beancount* to interpret
your *ledger* files correctly.

*date_format* <string>
	The date format used in your *ledger* file (default: *%Y-%m-%d*).

*date_format_no_year* <string>
	The date format for dates without the year when *ledger*'s
	*Y*/*year* directive is used (default: *%m-%d*).

*ledger_indent* <int>
	Sets the indentation level used in your ledger file (default: *4*).

*decimal_comma* true|false
	Parses amounts with the decimal comma (e.g. *10,00 EUR*).  Set
	this option to *true* if you use option *--decimal-comma* in
	*ledger*.

*hledger* true|false
	Tells *ledger2beancount* whether to attempt to parse
	*hledger*(1)-specific features.

# OTHER OPTIONS

*beancount_indent* <int>
	Sets the indentation level for the generated beancount file
	(default: *2*).

*operating_currencies*
	A list of frequently used currencies.  This is used by
	*fava*, the web UI for beancount.

*automatic_declarations* true|false
	Emit account and commodity declarations. (Default: *true*)

	Note: the declarations done in ledger via *account* and
	*commodity* declarations are always converted.  If this option
	is *true*, declarations are created for those which have not
	been explicitly declared in *ledger* but used.

*account_open_date* <string>
	The date used to open accounts (default: *1970-01-01*).

*commodities_date* <string>
	The date used to create commodities (default: *1970-01-01*).

*beancount_header* <file>
	Specifies a file which serves as a beancount "header", i.e. it's
	put at the beginning of the converted beancount file.  You can
	use such a header to specify options for beancount, such as
	*option "title"*, define *plugin* directives or beancount *query*
	information.

*ignore_marker* <string>
	Specifies a marker that tells *ledger2beancount*(1) to ignore
	a line if the marker is found.

*keep_marker* <string>
	Specifies a marker that tells *ledger2beancount*(1) to take
	a line from the input that is commented out, uncomment it and
	display it in the output.

*convert_virtual* true|false
	Specifies whether virtual postings should be converted.  If set
	to *true*, virtual postings in brackets will be made into real
	accounts.  (Virtual postings in parentheses are always ignored,
	regardless of this option.)

*account_map*
	Specifies a hash of account names to be mapped to other account
	names.

*account_regex*
	Specifies a hash of regular expressions to replace account
	names.

*commodity_map*
	Specifies a mapping of *ledger* commodities to beancount
	commodities.

*metadata_map*
	Specifies a mapping of *ledger* metadata keys to corresponding
	*beancount* keys.

*payee_tag* and *payer_tag*
	Specify a metadata tag (after the mapping done by *metadata_map*)
	used to set the payee.

*payee_split*
	Specifies a list of regular expressions to split *ledger*'s payee
	field into payee and narration.  You have to use the named capture
	groups *payee* and *narration*.

*payee_match*
	Specifies a list of regular expressions and corresponding payees.
	The whole *ledger* payee becomes the narration and the matched
	payee from the regular expression becomes the payee.

*postdate_tag* <string>
	Specifies the metadata tag to be used to store posting
	dates. (Use the empty string if you don't want the metadata
	to be added to beancount.)

*auxdate_tag* <string>
	Specifies the metadata tag to be used to store auxiliary dates
	(also known as effective dates; or *date2* in *hledger*).
	(Use the empty string if you don't want the metadata
	to be added to beancount.)

*code_tag* <string>
	Specifies the metadata tag to be used to store transaction
	codes. (Use the empty string if you don't want the metadata
	to be added to beancount.)

*link_match*
	Specifies a list of regular expressions that will cause a tag
	to be rendered as a link.

*link_tags*
	Specifies a list of metadata tags whose values should be
	converted to *beancount* links instead of metadata.
	Tags are case insensitive and values must not contain whitespace.

*currency_is_commodity*
	Specifies a list of commodities that should be treated as
	commodities rather than currencies even though they consist
	of 3 characters (which is usually a characteristic of a
	currency).  Expects beancount commodities (i.e. after
	transformation and mapping).

*commodity_is_currency*
	Specifies a list of commodities that should be treated as
	currencies (in the sense that cost is not retained).
	Expects beancount commodities (i.e. after transformation
	and mapping).

# AUTHORS

Stefano Zacchiroli and Martin Michlmayr

# SEE ALSO

*ledger2beancount*(1), *ledger*(1), *hledger*(1)

The full documentation for *ledger2beancount* can be found in its manual.

