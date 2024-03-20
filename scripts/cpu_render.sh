#!/bin/sh

#!/bin/sh

# Ubuntu Shell is none interactive
eval "$(cat ~/.bashrc | grep export)"

# Check number of arguments
if [ $# -ne 0 ]
then
    echo "This script does not take any arguments."
    exit 1
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

# Check if mesa utils is installed
if [ ! dpkg -l | grep mesa-utils]
then
    echo
    echo "Mesa-utils not installed, installing to enable gpu acceleration ..."
    sudo apt install -y mesa-utils > /dev/null 2>&1
    if [ $? -ne 0 ]
    then
        echo "Failed to install mesa-utils, exiting."
        exit 1
    fi
    echo "Mesa-utils installed successfully."
fi

# script to enable cpu graphics rendering
if [ "$GALLIUM_DRIVER" != "llvmpipe" ]
then
    export GALLIUM_DRIVER=llvmpipe
fi


echo "" >> ~/.bashrc
echo "# cpu render" >> ~/.bashrc
echo "export GALLIUM_DRIVER=llvmpipe" >> ~/.bashrc
