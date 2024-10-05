## diff-ready.sh

Run lintKotlin, detekt and testDebugUnitTest on all modules that contain diff comparing to the base branch

usage:
    diff-ready.sh [modules path to run] [--hide-skipped] [--help]

    examples:
        diff-ready.sh api/movies
        diff-ready.sh --hide-skipped
        diff-ready.sh api/movies --hide-skipped

    parameters:
        [modules path to run]:    run all modules found in the path and subpaths of "modules path to run"
        [gradle task to run]:     task that will be run on each module that contains diff comparing to base branch
        [--hide-skipped]:         hide logs of skipped modules
        [--help]:                 you already know what this parameter does

setup:
    diff.sh --set [CONFIG] [VALUE]

    CONFIG Value:
        DEFAULT_PATH:              default modules path to run
        DEFAULT_BASE_BRANCH:       default base branch to compare
        DEFAULT_JAVA_HOME:         default java home path

    examples:
        diff-ready.sh --set DEFAULT_PATH api/movies
        diff-ready.sh --set DEFAULT_BASE_BRANCH origin/main

## diff.sh

Run gradle task on all modules that contain diff comparing to the base branch

usage:
    diff.sh [gradle task to run] [modules path to run] [--hide-skipped] [--help]

    examples:
        diff.sh testDebugUnitTest api/movies
        diff.sh lintDebug --hide-skipped
        diff.sh connectedAndroidTest api/movies --hide-skipped

    parameters:
        [modules path to run]:    run all modules found in the path and subpaths of "modules path to run"
        [gradle task to run]:     task that will be run on each module that contains diff comparing to base branch
        [--hide-skipped]:         hide logs of skipped modules
        [--help]:                 you already know what this parameter does

setup:
    diff.sh --set [CONFIG] [VALUE]

    CONFIG Value:
        DEFAULT_PATH:              default modules path to run
        DEFAULT_BASE_BRANCH:       default base branch to compare
        DEFAULT_JAVA_HOME:         default java home path

    examples:
        diff.sh --set DEFAULT_PATH api/movies
        diff.sh --set DEFAULT_BASE_BRANCH origin/main
