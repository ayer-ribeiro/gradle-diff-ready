function grantThatFileExists {
    file=$1
    if [ ! -e "$file" ]; then

        touch "$file" 
        declare -p DEFAULT_PATH DEFAULT_BASE_BRANCH DEFAULT_JAVA_HOME > $file
    fi
}

function showHelp() {
    echo "usage:"
    echo "    diff.sh [gradle task to run] [modules path to run] [--hide-skipped] [--help]"
    echo ""
    echo "    examples:"
    echo "        diff.sh testDebugUnitTest api/movies"
    echo "        diff.sh lintDebug --hide-skipped"
    echo "        diff.sh connectedAndroidTest api/movies --hide-skipped"
    echo ""
    echo "    parameters:"
    echo "        [modules path to run]:    run all modules found in the path and subpaths of \"modules path to run\""
    echo "        [gradle task to run]:     task that will be run on each module that contains diff comparing to base branch"
    echo "        [--hide-skipped]:         hide logs of skipped modules"
    echo "        [--help]:                 you already know what this parameter does"
    echo ""
    echo "setup:"
    echo "    diff.sh --set [CONFIG] [VALUE]"
    echo ""
    echo "    CONFIG Value:"
    echo "        DEFAULT_PATH:              default modules path to run"
    echo "        DEFAULT_BASE_BRANCH:       default base branch to compare"
    echo "        DEFAULT_JAVA_HOME:         default java home path"
    echo ""
    echo "    examples:"
    echo "        diff.sh --set DEFAULT_PATH api/movies"
    echo "        diff.sh --set DEFAULT_BASE_BRANCH origin/main"
    exit 0
}

export -f grantThatFileExists
export -f showHelp