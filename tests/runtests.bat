
:: SPDX-FileCopyrightText: © 2018 Martin Michlmayr <tbm@cyrius.com>

:: SPDX-License-Identifier: GPL-3.0-or-later

setlocal enableDelayedExpansion

:: Set UTF-8 locale
chcp 65001

:: Convert ledger files
set error=0
for /r %%i in (*.ledger) do (
    echo Converting %%i...
    set ledger=%%i
    set beancount=!ledger:.ledger=.beancount!
    set yml=!ledger:.ledger=.yml!
    if exist !yml! (
        set config=!yml!
    ) else (
        set config=ledger2beancount.yml
    )
    perl ..\bin\ledger2beancount --config !config! %%i > temp
    diff --strip-trailing-cr -urN !beancount! temp
    if errorlevel 1 set error=1
    del temp
)
if "%error%"=="1" (
    echo One or more conversions had unexpected results
    exit /b 1
)

:: Validate beancount files
for /r %%i in (*.beancount) do (
    echo Validating %%i...
    bean-check %%i
)

