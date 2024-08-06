#!/usr/bin/env bash
# ┏┓ ╻  ┏━┓┏━╸╻┏ ┏━┓╺┳┓┏━╸
# ┣┻┓┃  ┣━┫┃  ┣┻┓┣━┫ ┃┃┣╸ 
# ┗━┛┗━╸╹ ╹┗━╸╹ ╹╹ ╹╺┻┛┗━╸
# Blackade's dotfiles. Under MIT License.
# Install script

# default install
cli_default=(
    'neovim'
    'pluton'
    'zsh'
)
gui_default=(
    'fontconfig'
)

# help
function help() {
    cat <<EOS
Usage:
    $(basename $0) <options> [additional dotfiles]

Options:
    -i --install    Install dotfiles
    -u --uninstall  Uninstall all dotfiles
    -g --gui        Install GUI dotfiles if --install specified
    -h --help       Print this message
EOS
}

# check required programs
programs=('stow')
for program in ${programs[@]}; do
    if ! command -v $program &> /dev/null; then
        echo "$program could not be found"
        exit 1
    fi
done

getopt --test && true
if [ $? -ne 4 ]; then
    echo 'getopt version should be 4'
    exit 1
fi

# parse options
LONG_OPTIONS=install,uninstall,gui,help
OPTIONS=iugh
PARSED=$(getopt --options=$OPTIONS --longoptions=$LONG_OPTIONS --name="$(basename $0)" -- "$@") || exit 1
eval set -- "$PARSED"

operation=
gui=false
while true; do
    case "$1" in
        -i|--install)
            operation=install
            shift
            ;;
        -u|--uninstall)
            operation=uninstall
            shift
            ;;
        -g|--gui)
            gui=true
            shift
            ;;
        -h|--help)
            help
            exit
            ;;
        --)
            shift
            break
            ;;
        *)
            echo 'program error'
            exit 1
            ;;
    esac
done

# show help if operation not specified
if [ -z "$operation" ]; then
    help
    exit
fi

# do the operation
if [ "$operation" = 'install' ]; then
    # install dotfiles
    for dotfile in ${cli_default[@]} $($gui && echo ${gui_default[@]}) $@; do
        echo installing $dotfile
        stow -S $dotfile
    done

    # install plugins
    ~/.local/bin/pluton
elif [ "$operation" = 'uninstall' ]; then
    # uninstall dotfiles   
    for dotfile in $(ls -d */ | sed 's/\///'); do
        echo uninstalling $dotfile
        stow -R $dotfile
    done
fi
