#!/bin/bash
DEFAULT_PATH="."
DEFAULT_BASE_BRANCH="origin/master"
DEFAULT_JAVA_HOME=$JAVA_HOME

file="$HOME/.script.config"
# Check if the file exists
if [ ! -e "$file" ]; then

    touch "$file" 
    declare -p DEFAULT_PATH DEFAULT_BASE_BRANCH DEFAULT_JAVA_HOME > "$HOME/.script.config"
fi

source $file
## Handle set parameter
if [ "$1" == "--set" ]; then
    eval "$2='$3'"
    declare -p DEFAULT_PATH DEFAULT_BASE_BRANCH DEFAULT_JAVA_HOME > "$HOME/.script.config"
    echo ""
    echo "Script config set"
    exit 0
fi

## Preparing params
ESSENTIAL_PARAMS=()
UNORDERED_PARAMS=()
for var in "$@"
do
    if [[ $var == --* ]]; then
        UNORDERED_PARAMS+=("$var")
    else 
        ESSENTIAL_PARAMS+=("$var")
    fi
done

## Handle path param
PATH_PARAM="${ESSENTIAL_PARAMS[0]}"
# Check if PATH_PARAM is null or empty
if [ -z "$PATH_PARAM" ]; then
    PATH_PARAM=$DEFAULT_PATH
fi

## Handle hide skipped param
hide_skipped=false
for param in "${UNORDERED_PARAMS[@]}"
do
    if [ "$param" == "--hide-skipped" ]; then
        hide_skipped=true
        break
    fi
done

## Handle help param
for param in "${UNORDERED_PARAMS[@]}"
do
    if [ "$param" == "--help" ]; then
        echo "usage:"
        echo "    diff-ready.sh [modules path to run] [--hide-skipped] [--help]"
        echo ""
        echo "    examples:"
        echo "        diff-ready.sh api/movies"
        echo "        diff-ready.sh --hide-skipped"
        echo "        diff-ready.sh api/movies --hide-skipped"
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
        exit 0
    fi
done

ROOT_PROJECT_PATH=`git rev-parse --show-toplevel`
ROOT_PROJECT_PATH="$ROOT_PROJECT_PATH/"
PACKAGE=$(echo "$ROOT_PROJECT_PATH$PATH_PARAM" | sed 's#\/\/#\/#g; s#\.\/##')

echo "Checking project modules"
echo "..."
BUILD_GRADLE_FILES=$(find $PACKAGE -type f -name "build.gradle.kts")

MODULE_NAMES=()
for FILE in $BUILD_GRADLE_FILES; do
    FILE=$(echo "$FILE" | sed 's#\/\/#\/#g; s#\.\/##')
    MODULE_FULL_DIR=$(dirname "$FILE")
    MODULE_DIR="/${MODULE_FULL_DIR#"$ROOT_PROJECT_PATH"}"
    MODULE=$(echo "$MODULE_DIR" | tr '/' ':')

    if git diff $DEFAULT_BASE_BRANCH --quiet --exit-code -- "$MODULE_FULL_DIR"; then
        if [ "$hide_skipped" = false ]; then
            echo ""
            echo "Checking $MODULE at $MODULE_FULL_DIR"
            echo -e "\033[1;93mNO CHANGES FOUND\033[m"
        fi
        continue
    else 
        echo ""
        echo "Checking $MODULE at $MODULE_FULL_DIR"
    fi


    echo ""
    echo "$MODULE:lintKotlin"
    $ROOT_PROJECT_PATH/gradlew "$MODULE:lintKotlin" "-Dorg.gradle.java.home=$DEFAULT_JAVA_HOME" --quiet --warning-mode none
    if [ $? -eq 0 ]
    then
        echo -e "\033[1;92mBUILD SUCCESSFUL\033[m"
    fi

    echo ""
    echo "$MODULE:detekt"
    $ROOT_PROJECT_PATH/gradlew "$MODULE:detekt" "-Dorg.gradle.java.home=$DEFAULT_JAVA_HOME" --quiet --warning-mode none
    if [ $? -eq 0 ]
    then
        echo -e "\033[1;92mBUILD SUCCESSFUL\033[m"
    fi

    echo ""
    echo "$MODULE:testDebugUnitTest"
    $ROOT_PROJECT_PATH/gradlew "$MODULE:testDebugUnitTest" "-Dorg.gradle.java.home=$DEFAULT_JAVA_HOME" --quiet --warning-mode none
    if [ $? -eq 0 ]
    then
        echo -e "\033[1;92mBUILD SUCCESSFUL\033[m"
    fi
done
