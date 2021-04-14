
# Tips and tricks

## Pre- and post-processing

While ledger2beancount is fairly powerful and configurable, it won't
meet all needs.  In some cases, it makes more sense to pre-process the
input file or post-process the output file rather than to add more
features to ledger2beancount.

For example, let's consider an input file like this:

```ledger
2021-03-22 * Some Payee
    ;Order Number or other description
    Expenses:Unknown                                EUR 122.94
    Assets:Current:Checking
```

We want to use the payee (`Some Payee`) as the payee and use the first
comment (`Order Number...`) as the narration.  If the narration
information was on the same line as the payee, we could use
`payee_split` to split payee and narration.  However, there is no way
to access comments.

The best solution is a script that changes the comment to metadata.
A simple script like this one can be used:

```perl
#!/usr/bin/perl

use warnings;
use strict;

my $before_posting = 1;
while (<>) {
    if (/^\d/) { # Transaction header
        $before_posting = 1;
    } elsif (/^\s+[^;\s]/) { # Posting
        $before_posting = 0;
    } elsif (/^\s+;(.*)/) { # Comment
        my $note = $1;
        if ($before_posting) {
            print "    ;narration: $note\n";
            next;
        }
    }
    print;
}
```

This changes the input file to:

```ledger
2021-03-22 * Some Payee
    ;narration: Order Number or other description
    Expenses:Unknown                                EUR 122.94
    Assets:Current:Checkings
```

Now the comment is metadata and we can use the following configuration:

```yaml
payee_split:
 - (?<payee>.*)

narration_tag: narration
```

to get the expected output:

```beancount
2021-03-22 * "Some Payee" "Order Number or other description"
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

