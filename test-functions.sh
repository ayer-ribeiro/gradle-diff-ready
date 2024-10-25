source ./common-functions.sh

function echoClearString() {
    echo $(eval "echo \"$1\"" 2>/dev/null) | sed 's/\x1B\[[0-9;]*[JKmsu]//g'
}

function whenRun() {
    local runResult
    local clearedResult
    runResult=$(eval "$1" 2>/dev/null)
    clearedResult=$(echoClearString "$runResult")
    echo $clearedResult
}

function handleTestResult() {
    local expected
    local actual

    expected=$1
    actual=$2

    if [ "$expected" == "$actual" ]; then
        msgSuccess "[OK] $name"
    else
        msgError "[ERROR] $name"
        msgAlert "Expected:"
        echo "$expected"
        msgAlert "Actual:"
        echo "$actual."

        echo "Length of expected: ${#expected}"
        echo "Length of actual: ${#actual}"
        return 1
    fi  
}

function test() {
    local result
    local clearedExpected
    options=$(getopt -o n:c:e: --long name:,command:,expected: -- "$@")

    eval set -- "$options"

    while true; do
        case "$1" in
            -n | --name) name="$2"; shift 2 ;;
            -c | --command) command="$2"; shift 2 ;;
            -e | --expected) expected="$2"; shift 2 ;;
            --) shift; break ;;
            *) echo "Invalid option $1"; exit 1 ;;
        esac
    done

    result=$(whenRun "$command")
    clearedExpected=$(echoClearString "$expected")
    handleTestResult "$clearedExpected" "$result"
}

export -f test