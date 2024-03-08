#!/bin/sh

# Ubuntu Shell is none interactive
eval "$(cat ~/.bashrc | tail -n +10)"

# Check number of arguments
if [ $# -ne 0 ]
then
    echo "This script does not take any arguments."
    exit 1
fi

# Check if eif repo is installed
if [ ! -f /etc/apt/sources.list.d/lablinuxrepo.list ]
then
    echo "Eif repo is not installed. Needed for netgui installation."
    exit 0
fi

# Check for sudo privileges, dischard output
sudo -n true > /dev/null 2>&1

# Check if sudo privileges were granted
if [ $? -eq 0 ];
then 
    echo "You have sudo privileges"

else
    echo "You dont have sudo privileges"
    # Update sudo timestamp
    sudo -v
fi

# Update
sudo apt update > /dev/null 2>&1

# Packages to install
packages="gnome-terminal konsole netgui"

# Install packages
for p in $packages
do
    if dpkg -l | grep -q "$p";
    then
        echo "Package $p already installed"
    else
        sudo apt install -y $p > /dev/null 2>&1

        # Check if package was installed succesfully
        if [ $? -ne 0 ];
        then
            echo "Package $p failed to install"
            exit 1
        fi
    fi
done

echo "Netgui installed successfully."
echo "You can run it by typing netgui.sh in terminal."