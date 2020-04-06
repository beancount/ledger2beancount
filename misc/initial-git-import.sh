#!/bin/sh

# SPDX-FileCopyrightText: © 2018 Stefano Zacchiroli <zack@upsilon.cc>

# SPDX-License-Identifier: GPL-3.0-or-later

# ledger2beancount started as an ad hoc personal script. As such it was
# maintained in zack's private Ledger Git repository. It was later spun off
# as an independent project, when tbm started to heavily contribute to it. The
# script below was used to migrate the git history of ledger2beancount from
# zack's private repo to a new, independent one. It is ad hoc, uninteresting,
# and archived here just for historical reasons.

flags="--force --prune-empty"
revs="-- --all"
git_url="git@*censored*:ledger"

git clone "$git_url" ledger2beancount
cd ledger2beancount

git filter-branch $flags --subdirectory-filter bin $revs
git filter-branch $flags --tree-filter "ls | grep -v beancount | xargs rm" $revs
git filter-branch $flags --env-filter '
  export GIT_AUTHOR_NAME="Martin Michlmayr"
  export GIT_AUTHOR_EMAIL="tbm@cyrius.com"
  export GIT_COMMITTER_NAME="Stefano Zacchiroli"
  export GIT_COMMITTER_EMAIL="zack@upsilon.cc"
' -- $(git rev-list HEAD --since=2018-03-10 | tail -n 1)^..HEAD
