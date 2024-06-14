#!/bin/bash

# Function to display the help message
show_help() {
    echo "Usage: $0 {add|delete|passwd|modify} [arguments...]"
    echo "Commands:"
    echo "  add USERNAME PASSWORD             Add a new user"
    echo "  delete USERNAME                   Delete a user"
    echo "  passwd USERNAME                   Change user password"
    echo "  modify USERNAME [options]         Modify user permissions"
}

 


# Main script logic
if [[ $# -lt 1 ]]; then
    show_help
    exit 1
fi

COMMAND=$1
shift
# Function to add a new user
add_user() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: $0 add USERNAME PASSWORD"
        exit 1
    fi

    USERNAME=$1
    PASSWORD=$2

    # Add user and set password
    useradd -m "$USERNAME"
    echo "$USERNAME:$PASSWORD" | chpasswd

    echo -e "User $USERNAME added successfully.\n"

    show_options

    exit 1
}
# Function to delete a user
delete_user() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: $0 delete USERNAME"
        exit 1
    fi

    USERNAME=$1

    # Delete user
    userdel -r "$USERNAME"

    echo "User $USERNAME deleted successfully."
}
# Function to change a user's password
change_password() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: $0 passwd USERNAME"
        exit 1
    fi

    USERNAME=$1

    # Prompt for new password
    passwd "$USERNAME"
}
# Function to modify user permissions
modify_user() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: $0 modify USERNAME [options]"
        exit 1
    fi

    USERNAME=$1
    shift

    # Modify user with provided options
    usermod "$USERNAME" "$@"

    echo "User $USERNAME modified successfully."
}

case "$COMMAND" in
    add)
        add_user "$@"
        ;;
    delete)
        delete_user "$@"
        ;;
    passwd)
        change_password "$@"
        ;;
    modify)
        modify_user "$@"
        ;;
    *)
        show_help
        exit 1
        ;;
esac

