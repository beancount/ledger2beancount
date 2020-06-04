# Usage

ledger2beancount accepts input from `stdin` or from a file and will write
the converted data to `stdout`.  You can run ledger2beancount like this
on the example provided:

```shell
ledger2beancount examples/simple.ledger > simple.beancount
```

After you convert your ledger file, you should validate the generated
beancount file with `bean-check` and fix all errors:

```shell
bean-check simple.beancount
```

You should also inspect the generated beancount file to see if it
looks correct to you.  Please note that ledger2beancount puts notes
at the beginning of the generated beancount file if it encounters
problems with the conversion.

If you believe that ledger2beancount could have produced a better
conversion or if you get an error message from ledger2beancount, please
[file a bug](https://github.com/beancount/ledger2beancount/issues) along
with a simple test case.

You can pipe the output of ledger2beancount to beancount's bean-format
if you want to use the conversion as an opportunity to reformat your
file.

