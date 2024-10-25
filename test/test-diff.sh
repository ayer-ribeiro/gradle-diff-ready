#!/bin/bash

#./diff.sh environment-groovy

source ./test-functions.sh
source ./common-functions.sh

test  \
--name "Given groovy project with no changes, When run diff.sh, Then should show NO CHANGES FOUND" \
--command "./diff.sh ./environment-groovy" \
--expected "Checking project modules
...

Checking :test:environment-groovy at /test/environment-groovy
NO CHANGES FOUND

Checking :test:environment-groovy:module-a at /test/environment-groovy/module-a
NO CHANGES FOUND

Checking :test:environment-groovy:module-b at /test/environment-groovy/module-b
NO CHANGES FOUND"

test  \
--name "Given kotlin project with no changes, When run diff.sh, Then should show NO CHANGES FOUND" \
--command "./diff.sh ./environment-kts" \
--expected "Checking project modules
...

Checking :test:environment-groovy at /test/environment-groovy
NO CHANGES FOUND

Checking :test:environment-groovy:module-a at /test/environment-groovy/module-a
NO CHANGES FOUND

Checking :test:environment-groovy:module-b at /test/environment-groovy/module-b
NO CHANGES FOUND"


test  \
--name "Given kotlin and groovy project with no changes, When run diff.sh, Then should show NO CHANGES FOUND" \
--command "./diff.sh ./environment-mixed" \
--expected "Checking project modules
...

Checking :test:environment-groovy at /test/environment-groovy
NO CHANGES FOUND

Checking :test:environment-groovy:module-a at /test/environment-groovy/module-a
NO CHANGES FOUND

Checking :test:environment-groovy:module-b at /test/environment-groovy/module-b
NO CHANGES FOUND"


