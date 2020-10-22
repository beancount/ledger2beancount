
While ledger2beancount is pretty portable, the test suite makes use of some functionality which might not be available on all platforms out of the box.

## Required

* The test suite assumes a UTF-8 environment.
* The test suite uses the `-V` (`--version-sort`) option of `sort` in order to compare versions.  This option is not available in all implementations of sort.  Therefore, sort from [GNU coreutils](https://www.gnu.org/software/coreutils/) is required.  This is provided as `gsort` on some platforms.  You can set the `SORT` environment variable to specify the binary for sort.
* The tool `mktemp` is called to create temporary files.  If this is not provided by the platform, GNU coreutils can be installed.

## Optional

* If `ledger`, `hledger`, and/or `beancount` are installed, these tools will be used to validate input (ledger and hledger) and output files (beancount).

