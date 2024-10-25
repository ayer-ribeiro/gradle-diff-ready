#!/bin/bash
DEFAULT_PATH="."
DEFAULT_BASE_BRANCH="origin/master"
DEFAULT_JAVA_HOME=$JAVA_HOME

source ./diff-functions.sh
source ./common-functions.sh

scriptConfigFile="$HOME/.script.config"
grantThatFileExists $scriptConfigFile
source $scriptConfigFile

## Handle set parameter
if [ $1 == "--set" ]; then
    eval "$2='$3'"
    declare -p DEFAULT_PATH DEFAULT_BASE_BRANCH DEFAULT_JAVA_HOME > "$HOME/.script.config"
    echo ""
    echo "Script config set"
    exit 0
fi

## Preparing parameters
mandatoryParams=()
optionalParams=()
for var in "$@"
do
    if [[ $var == --* ]]; then
        optionalParams+=("$var")
    else 
        mandatoryParams+=("$var")
    fi
done

## Handle help parameter
for param in "${optionalParams[@]}"
do
    if [ "$param" == "--help" ]; then
        showHelp
    fi
done

## Handle task parameter
task="${mandatoryParams[0]}"
if [ -z "$task" ]; then
    msgError "INVALID TASK PARAMETER"
    exit 1
fi
 
## Handle path param
pathParam="${mandatoryParams[1]}"
if [ -z "$pathParam" ]; then
    pathParam=$DEFAULT_PATH
fi

## Handle hide skipped parameter
hide_skipped=false
for param in "${optionalParams[@]}"
do
    if [ "$param" == "--hide-skipped" ]; then
        hide_skipped=true
        break
    fi
done

## Handle path to run
rootProjectPath=`git rev-parse --show-toplevel`
rootProjectPath="$rootProjectPath/"
PACKAGE=$(echo "$rootProjectPath$pathParam" | sed 's#\/\/#\/#g; s#\.\/##')

echo "Checking project modules"
echo "..."
buildGradleFiles=$(find $PACKAGE -mindepth 2 -type f \( -name "build.gradle" -o -name "build.gradle.kts" \))

MODULE_NAMES=()
for buildGradleFile in $buildGradleFiles; do
    buildGradleFile=$(echo "$buildGradleFile" | sed 's#\/\/#\/#g; s#\.\/##')
    moduleFullPath=$(dirname "$buildGradleFile")
    moduleDir="/${moduleFullPath#"$rootProjectPath"}"
    module=$(echo "$moduleDir" | tr '/' ':')

    if git diff $DEFAULT_BASE_BRANCH --quiet --exit-code -- "$moduleFullPath"; then
        if [ "$hide_skipped" = false ]; then
            echo ""
            echo "Checking $module at $moduleDir"
            msgAlert "NO CHANGES FOUND"
        fi
        continue
    else 
        echo ""
        echo "Checking $module at $moduleDir"
    fi  

    echo "$module:$task"
    ./gradlew "$module:$task" "-Dorg.gradle.java.home=$DEFAULT_JAVA_HOME" --quiet --warning-mode none
    
    if [ $? -eq 0 ]
    then
        msgError "BUILD SUCCESSFUL"
    fi
done


