# Beancount compatibility

The syntax of beancount is quite stable but it's expected to become
slightly less restrictive as some missing features are implemented (such
as posting-level tags).

ledger2beancount aims to be compatible with the latest official release
of beancount, but some functionality may require an unreleased version of
beancount.  You can install the latest development version of beancount
directly from the beancount repository:

```shell
pip3 install git+https://github.com/beancount/beancount/
```

Currently, there are no features that require an unreleased version of
beancount.

ledger2beancount is largely compatible with Beancount 2.0.  If you
use the following features, you need Beancount 2.1:

* UTF-8 letters and digits in account names
* Full-line comments in transactions
* Transaction tags on multiple lines

