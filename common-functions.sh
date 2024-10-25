function msgError() {
    echo -e "\033[1;91m$1\033[m" >&2
}

function msgSuccess() {
    echo -e "\033[1;92m$1\033[m"
}

function msgAlert() {
    echo -e "\033[1;93m$1\033[m"
}

export -f msgError
export -f msgSuccess
export -f msgAlert