# Release process

* Update `$VERSION` in `bin/ledger2beancount`
* Update `docs/changelog.md`
* Update date in `docs/index.md`
* Write changes to git:

  ```shell
  git commit -S -m "changelog: timestamp 2.X release"
  ```

* Tag release:

  ```shell
  git tag 2.X -s
  ```

  Use the following format for the commit message:

  ```
  Release ledger2beancount 2.X

  <copy info from docs/changelog.md>
  ```

* Push new tags to GitHub:

  ```shell
  git push github master --tags
  ```

* Go to the [GitHub release page](https://github.com/beancount/ledger2beancount/releases/new) to create a new release:

    * Select the tag
    * Use 2.X as the release title
    * Copy release notes from `docs/changelog.md`

* Email packagers:

  ```
  Jelmer Vernooĳ <jelmer@debian.org>
  Kirill Goncharov <kdgoncharov@gmail.com>
  Taylor R Campbell <riastradh@netbsd.org>
  ```

