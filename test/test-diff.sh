#!/bin/bash

source ./test-functions.sh
source ./common-functions.sh

testErrorCount=0

test  \
--name "Given groovy project with no changes, When run diff.sh, Then should show NO CHANGES FOUND" \
--command "./diff.sh lintDebug ./test/environment-groovy" \
--expected "Checking project modules
...

Checking :test:environment-groovy:module-a at /test/environment-groovy/module-a
NO CHANGES FOUND

Checking :test:environment-groovy:module-b at /test/environment-groovy/module-b
NO CHANGES FOUND" || ((testErrorCount++))

test  \
--name "Given kotlin project with no changes, When run diff.sh, Then should show NO CHANGES FOUND" \
--command "./diff.sh lintDebug ./test/environment-kts" \
--expected "Checking project modules
...

Checking :test:environment-kts:module-a at /test/environment-kts/module-a
NO CHANGES FOUND

Checking :test:environment-kts:module-b at /test/environment-kts/module-b
NO CHANGES FOUND"  || ((testErrorCount++))

test  \
--name "Given kotlin and groovy project with no changes, When run diff.sh, Then should show NO CHANGES FOUND" \
--command "./diff.sh lintDebug ./test/environment-mixed" \
--expected "Checking project modules
...

Checking :test:environment-mixed:module-a at /test/environment-mixed/module-a
NO CHANGES FOUND

Checking :test:environment-mixed:module-b at /test/environment-mixed/module-b
NO CHANGES FOUND"  || ((testErrorCount++))

test  \
--name "Given groovy project with no changes and hide-skipped enabled, When run diff.sh, Then should show no modules result" \
--command "./diff.sh lintDebug ./test/environment-mixed --hide-skipped" \
--expected "Checking project modules
..."  || ((testErrorCount++))


if (( testErrorCount == 1 )); then
    echo ""
    echo "$testErrorCount error found"
    exit 1
elif (( testErrorCount > 0 )); then
    echo ""
    echo "$testErrorCount errors found"
    exit 1
fi

