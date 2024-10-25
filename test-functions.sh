source ./common-functions.sh

function echoClearString() {
    result=$(echo $1 | perl -pe 's/\x1b\[[0-9;]*m//g')
    echo $result
}

function whenRun() {
    result=$(eval $1 2>/dev/null | perl -pe 's/\x1b\[[0-9;]*m//g')
    clearResult=$(echoClearString $result)
    echo $clearResult
}

function test() {

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
    clearExpected=$(echoClearString $expected)

    if [ "$clearExpected" == "$result" ]; then
        msgSuccess "[OK] $name"
    else
        msgError "[ERROR] $name"
        msgAlert "Expected:"
        echo "$clearExpected."
        msgAlert "Actual:"
        echo "$result."

        echo "Length of expected: ${#expected}"
        echo "Length of result: ${#result}"
        exit 1
    fi
}

export -f test