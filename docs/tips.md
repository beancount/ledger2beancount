
# Tips and tricks

## Pre- and post-processing

While ledger2beancount is fairly powerful and configurable, it won't
meet all needs.  In some cases, it makes more sense to pre-process the
input file or post-process the output file rather than to add more
features to ledger2beancount.

An example where pre-processing is useful are ledger transactions that
were created with [ledger's convert](https://www.ledger-cli.org/3.0/doc/ledger3.html#The-convert-command)
command, which allows the generation of transactions from CSV.

Since ledger doesn't distinguish between payee and narration, narration
information can be stored in a transaction note.  The problem with
processing such transactions is that ledger puts the note either on the
same line as the payee or the next line depending on the length of the
payee and narration information.  Furthermore, ledger2beancount doesn't
support taking narration information from transaction notes, so we have
to transform the transaction and store the information as metadata.

Let's take this CSV file as an example:

```csv
date,note,payee,amount
2021-04-21,A very long note that will be printed on the next line,Short Payee,-7.99 EUR
2021-04-21,Short note,Short Payee,-7.99 EUR
2021-04-21,Short note,A Long Payee Name that leaves no more room for the note,-7.99 EUR
```

The command `ledger convert --account Assets:Bank` produces this
output:

```ledger
2021-04-21 * Short Payee
    ;A very long note that will be printed on the next line
    Expenses:Unknown                       -7.99 EUR
    Assets:Bank

2021-04-21 * Short Payee  ;Short note
    Expenses:Unknown                       -7.99 EUR
    Assets:Bank

2021-04-21 * A Long Payee Name that leaves no more room for the note
    ;Short note
    Expenses:Unknown                       -7.99 EUR
    Assets:Bank
```

The following script takes the transaction notes (either the transaction
note on the same line as the payee or the first comment of a transaction)
and stores them as metadata with the key `narration`:

```perl
#!/usr/bin/perl

use warnings;
use strict;

my $before_posting = 1;
my $seen_note = 0;
while (<>) {
    if (/^\d/) { # Transaction header
        $before_posting = 1;
        if (/  ;/) {
            my ($header, $note) = split /  ;/;
            print "$header\n";
            print "    ; narration: $note";
            $seen_note = 1;
        } else {
            print;
            $seen_note = 0;
        }
    } elsif (/^\s+[^;\s]/) { # Posting
        $before_posting = 0;
        print;
    } elsif (/^\s+;(.*)/) { # Comment
        my $note = $1;
        if ($before_posting && !$seen_note) {
            print "    ; narration: $note\n";
            $seen_note = 1;
        } else {
            print;
        }
    } else {
        print;
    }
}
```

This changes the input file to:

```ledger
2021-04-21 * Short Payee
    ; narration: A very long note that will be printed on the next line
    Expenses:Unknown                       -7.99 EUR
    Assets:Bank

2021-04-21 * Short Payee
    ; narration: Short note
    Expenses:Unknown                       -7.99 EUR
    Assets:Bank

2021-04-21 * A Long Payee Name that leaves no more room for the note
    ; narration: Short note
    Expenses:Unknown                       -7.99 EUR
    Assets:Bank
```

Now the comment is metadata and we can use the following configuration:

```yaml
payee_split:
 - (?<payee>.*)

narration_tag: narration
```

to get the expected output:

```beancount
2021-04-21 * "Short Payee" "A very long note that will be printed on the next line"
  Expenses:Unknown                       -7.99 EUR
  Assets:Bank

2021-04-21 * "Short Payee" "Short note"
  Expenses:Unknown                       -7.99 EUR
  Assets:Bank

2021-04-21 * "A Long Payee Name that leaves no more room for the note" "Short note"
  Expenses:Unknown                       -7.99 EUR
  Assets:Bank
...
```

An example of post-processing is to change the variable type of ledger
codes from string to integer.  Using `code_tag`, the ledger code from
transactions is stored as metadata.  Since ledger codes can be
anything, they are stored as strings by default:

```beancount
2021-04-14 * "Code"
  code: "1201"
...
```

If you know that all your codes are integer, you can remove the
quotation marks to turn them from strings into integers:

```shell
perl -pi -e 's/^(\s+code: )"(\d+)"$/$1$2/' *.beancount
```

The `code` metadata is now an integer:

```beancount
2021-04-14 * "Code"
  code: 1201
...
```

