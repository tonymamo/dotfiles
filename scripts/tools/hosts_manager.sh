#!/bin/bash -
# This is still a work in progress. I want to make this handle both custom host
# files.
# TODO:
# * Consider a lock to prevent races between add_host and rm_host. $ACTIVE_FLAG 
#   might make a good lock.
# * $HOME env variable and consequently the $HOST_DIR env variable. Potentially
#   {add,rm}_host may act on different files to {start,stop}_block. Note that
#   this won't present itself if you only use sudo. Reconsider what you want
#   $HOST_DIR to be. On a a single user machine /var/ may be a good choice.

set -u # Prevent unset variables
set -e # Stop on an error


# Put the original in the dotfiles repo, so it shows up with git status
HOST_DIR="$HOME/.hosts"

# Create HOST_DIR if doesn't exist
mkdir -p $HOST_DIR

# Actual host file to be swapped around.
HOST_FILE="/etc/hosts"

# Original host file without any of the appended blocked hosts.
# Store the original file in the etc dir so others can find it.
ORIG_FILE="$HOST_DIR/hosts.original"

# List of blocked hosts. TODO: This will be replaced by different "profiles"
BLCK_FILE="$HOST_DIR/blocked_host"

# Temporary file used when removing hosts.
BLCK_TEMP=$(mktemp -t "blocked_hosts") || $(mktemp /tmp/blocked_hosts.XXXXXXX) || exit 1

# Make sure files exist.
[[ -e $ORIG_FILE ]] || sudo touch "$ORIG_FILE"
[[ -e $BLCK_FILE ]] || sudo touch "$BLCK_FILE"

# Check to see if the block is currently active.
ACTIVE_FLAG="$HOST_DIR/.wrk_block.flag"


usage()
{
    cat <<EOF
    Usage: hosts_manager  [command] [host1 host2 ...]

    Commands:
    profiles                   list all the profiles in \$HOST_DIR
    show [profile ...]         list blocked hosts in profile
    add [profile, host ...]    add a host to be blocked
    rm [profile, host ...]     remove hosts from block
    start [profile ...]        start blocking
    stop [profile ...]         stop blocking
EOF
}

if [[ -e $ACTIVE_FLAG ]]; then
    IS_ACTIVE=0
else
    IS_ACTIVE=1
fi

add_host()
{
    local hosts=("$@")
    for host in "${hosts[@]:1}"; do
        # append host to blocked hosts list
        echo "127.0.0.1 $host" >> "$BLCK_FILE"
        echo -e "\033[0;32madded\033[0m $host"
    done
}

# todo: remove need for loop; do in one go
rm_host()
{
    local hosts=("$@")
    for host in "${hosts[@]:1}"; do
        # overwrite host list file with a copy removing a certain host
        awk -v host=$host 'NF==2 && $2!=host { print }' "$BLCK_FILE" > "$BLCK_TEMP"
        mv "$BLCK_TEMP" "$BLCK_FILE"
        echo -e "\033[0;31mremoved\033[0m $host"
    done
}

check_root()
{
    if [[ "$(whoami)" != "root" ]]; then
        echo "You don't have sufficient priviledges to run this script (try sudo.)"
        exit 1
    else
        [[ -e $HOST_FILE ]] || { echo "Can't find or access host file."; exit 1; }
    fi
}

start_block()
{
    if [[ $IS_ACTIVE -ne 0 ]]; then
        cp "$HOST_FILE" "$ORIG_FILE"
        cat "$BLCK_FILE" >> "$HOST_FILE"
        touch "$ACTIVE_FLAG"
        echo "Block started."
    else
        echo "Already blocking."
    fi
}

stop_block()
{
    if [[ $IS_ACTIVE -eq 0 ]]; then
        cp "$ORIG_FILE" "$HOST_FILE"
        [[ -e $ACTIVE_FLAG ]] && rm "$ACTIVE_FLAG"
        echo "Stopped blocking."
    else
        echo "Not blocking."
    fi
}

print_profiles()
{
    ls $HOST_DIR | cat
}
while getopts :a FLAG; do
    case $FLAG in
        \?)
            echo $FLAG
            echo $OPTARG;;
    esac
done

if [ $# -gt 0 ]; then
    case $1 in
        'show')
            awk 'NF == 2 { print $2 }; END { if (!NR) print "Empty" }' "$BLCK_FILE";;
        'add')
            [[ -z $2 ]] && { usage; exit 1; }
            add_host $@;;
        'rm' | 'remove')
            [[ -z $2 ]] && { usage; exit 1; }
            rm_host $@;;
        'start')
            check_root
            start_block $2;;
        'stop')
            check_root
            stop_block;;
        'ls' | 'list' | 'profiles')
            print_profiles;;
        *)
            usage;;
    esac
else
    usage;
fi
