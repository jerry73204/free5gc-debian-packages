# Free5GC Dependencies Ansible Playbook

This directory contains an Ansible playbook for setting up all required dependencies to build Free5GC Debian packages.

## Files

- `install-dependencies.yml` - Main playbook that installs all dependencies
- `ansible.cfg` - Ansible configuration for local execution
- `inventory.ini` - Inventory file defining localhost

## Usage

```bash
# From this directory (will prompt for sudo password)
ansible-playbook install-dependencies.yml --ask-become-pass

# Or from the repository root
cd ansible && ansible-playbook install-dependencies.yml --ask-become-pass

# If you want to avoid password prompts, you can run with sudo:
sudo ansible-playbook install-dependencies.yml
```

## What it does

The playbook will:

1. Install base build dependencies (gcc, g++, cmake, etc.)
2. Add third-party repositories:
   - MongoDB 7.0
   - Go 1.21+ (via PPA for Ubuntu, backports for Debian)
   - Node.js 20.x
   - Yarn
3. Install packages from these repositories
4. Install makedeb if not already present
5. Verify all installations

## Requirements

- Ansible 2.9 or newer
- User with sudo privileges
- Debian 12+ or Ubuntu 22.04+

## Running with sudo

The playbook requires sudo privileges for:
- Installing packages
- Adding APT repositories
- Adding GPG keys
- Updating package lists

You'll be prompted for your sudo password when running with `--ask-become-pass`.

## Variables

The playbook uses the following variables (defined in the playbook):
- `mongodb_version`: "7.0"
- `nodejs_version`: "20"
- `go_version`: "1.21"

You can override these by passing them on the command line:
```bash
ansible-playbook install-dependencies.yml -e "go_version=1.22"
```