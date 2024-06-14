#!/bin/bash

# Function to show the options and handle user selection
show_options() {
    echo -e "Select any of the options below to continue:\n"
    echo "Add user: 1"
    echo "Delete user: 2"
    echo "Change user's password: 3"
    echo "Modify user: 4"
    echo "Modify user's groups: 5"
    echo "Modify file permissions: 6"
    echo "Exit: 7"
    read -p "Enter your choice: " option_chosen
    echo -e "\n\tYou have selected option $option_chosen"
    
    case "$option_chosen" in
        1)
            add_user
            ;;
        2)
            delete_user
            ;;
        3)
            change_password
            ;;
        4)
            modify_user
            ;;
        5)
            modify_user_groups
            ;;
        6)
            modify_file_permissions
            ;;
        7)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option selected!"
            ;;
    esac
    show_options  # Prompt again after completing the action
}

# Function to add a user
add_user() {
    read -p "Enter username to add: " username
    sudo adduser "$username"
    if [ $? -eq 0 ]; then
        echo "User $username has been added."
    else
        echo "Failed to add user $username."
    fi
}

# Function to delete a user
delete_user() {
    read -p "Enter username to delete: " username
    sudo userdel "$username"
    if [ $? -eq 0 ]; then
        echo "User $username has been deleted."
    else
        echo "Failed to delete user $username."
    fi
}

# Function to change user's password
change_password() {
    read -p "Enter username to change password: " username
    sudo passwd "$username"
    if [ $? -eq 0 ]; then
        echo "Password for user $username has been changed."
    else
        echo "Failed to change password for user $username."
    fi
}

# Function to modify user
modify_user() {
    read -p "Enter username to modify: " username
    echo "Modify options for $username:"
    echo "1. Change home directory"
    echo "2. Change shell"
    read -p "Enter your choice: " modify_choice
    
    case "$modify_choice" in
        1)
            read -p "Enter new home directory: " new_home
            sudo usermod -d "$new_home" "$username"
            if [ $? -eq 0 ]; then
                echo "Home directory for user $username has been changed to $new_home."
            else
                echo "Failed to change home directory for user $username."
            fi
            ;;
        2)
            read -p "Enter new shell: " new_shell
            sudo usermod -s "$new_shell" "$username"
            if [ $? -eq 0 ]; then
                echo "Shell for user $username has been changed to $new_shell."
            else
                echo "Failed to change shell for user $username."
            fi
            ;;
        *)
            echo "Invalid modify option selected!"
            ;;
    esac
}

# Function to modify user's groups
modify_user_groups() {
    read -p "Enter username to modify groups: " username
    echo "Group modification options for $username:"
    echo "1. Add user to a group"
    echo "2. Remove user from a group"
    read -p "Enter your choice: " group_choice
    
    case "$group_choice" in
        1)
            read -p "Enter group to add user to: " group
            sudo usermod -aG "$group" "$username"
            if [ $? -eq 0 ]; then
                echo "User $username has been added to group $group."
            else
                echo "Failed to add user $username to group $group."
            fi
            ;;
        2)
            read -p "Enter group to remove user from: " group
            sudo gpasswd -d "$username" "$group"
            if [ $? -eq 0 ]; then
                echo "User $username has been removed from group $group."
            else
                echo "Failed to remove user $username from group $group."
            fi
            ;;
        *)
            echo "Invalid group modification option selected!"
            ;;
    esac
}

# Function to modify file permissions
modify_file_permissions() {
    read -p "Enter the file path to modify permissions: " file_path
    echo "Permission modification options:"
    echo "1. Change ownership"
    echo "2. Change permissions"
    read -p "Enter your choice: " perm_choice
    
    case "$perm_choice" in
        1)
            read -p "Enter new owner (user:group): " new_owner
            sudo chown "$new_owner" "$file_path"
            if [ $? -eq 0 ]; then
                echo "Ownership of $file_path has been changed to $new_owner."
            else
                echo "Failed to change ownership of $file_path."
            fi
            ;;
        2)
            read -p "Enter new permissions (e.g., 755): " new_perms
            sudo chmod "$new_perms" "$file_path"
            if [ $? -eq 0 ]; then
                echo "Permissions of $file_path have been changed to $new_perms."
            else
                echo "Failed to change permissions of $file_path."
            fi
            ;;
        *)
            echo "Invalid permission modification option selected!"
            ;;
    esac
}

# Main script starts here
echo "Welcome to the User Management Script"
show_options  # Initial call to prompt the user for options
