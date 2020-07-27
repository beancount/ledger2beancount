# Limitations

## Include files and apply directives

Ledger offers the `include` directive to include transactions from other files.  It also has the `apply` directives to apply certain transformations to transactions, such as adding a string to the account name.  When you include other files within the scope of an `apply` directive, the transformation is applied to the included transactions.

Since there is no equivalent directive in beancount for most of ledger's `apply` directives, ledger2beancount manually applies the transformation manually during conversion, i.e. the generated beancount file will have the transformation applied.  However, as ledger2beancount operates on individual files, such transformations are not applied to the file that is included in another file because there's no `apply` directive in the file.

One exception is the `apply tag` directive since that's converted to `pushtag` in beancount instead of manually applying the transformation by ledger2beancount.
