#!/bin/bash

set -e

# Display banner
echo "====================================================="
echo "Free5GC Dependencies Setup"
echo "====================================================="
echo "Adding required PPAs for Free5GC dependencies"
echo

# Function to print section headers
print_section() {
  echo
  echo "====================================================="
  echo "$1"
  echo "====================================================="
}

# Detect OS and version
DISTRO=$(lsb_release -is)
CODENAME=$(lsb_release -cs)

echo "Detected: $DISTRO $CODENAME"

# 1. MongoDB 7.0 Repository
print_section "Adding MongoDB 7.0 Repository"
wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/7.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-7.0.list

# 2. Go 1.21+ Repository
print_section "Adding Go 1.21+ Repository"
add-apt-repository -y ppa:longsleep/golang-backports

# 3. Node.js 20.x Repository
print_section "Adding Node.js 20.x Repository"
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

# 4. Yarn Repository
print_section "Adding Yarn Repository"
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor > /usr/share/keyrings/yarnkey.gpg
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" > /etc/apt/sources.list.d/yarn.list

print_section "Repository Setup Complete"
echo "All required repositories have been added successfully."
echo
echo "IMPORTANT: You now need to run the following commands:"
echo
echo "  sudo apt-get update"
echo "  sudo apt-get install mongodb-org golang-1.21 nodejs yarn"
echo
echo "After installing these dependencies, you can build the Free5GC packages."
