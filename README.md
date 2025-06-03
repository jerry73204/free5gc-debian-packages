# Free5GC Debian Packages

This repository contains makedeb PKGBUILD files for building Free5GC as Debian packages.

## Package Structure

The repository contains:

1. **ansible/**: Ansible playbook and configuration for setting up dependencies
2. **free5gc/**: Core Free5GC packages (NFs, UPF, WebConsole, and GTP5G kernel module)

## System Requirements

- Debian 12+ or Ubuntu 22.04+
- Linux Kernel 5.4+

## Installation Guide

### Step 1: Install Dependencies

Use the provided Ansible playbook to set up all required repositories and dependencies:

```bash
# Install Ansible if not already installed
sudo apt update && sudo apt install -y ansible

# Run the dependency installation playbook (will prompt for sudo password)
cd ansible
ansible-playbook install-dependencies.yml --ask-become-pass
```

The playbook will:
- Add all necessary repositories (MongoDB, Go, Node.js, Yarn)
- Install basic build dependencies
- Install MongoDB, Go 1.21+, Node.js, and Yarn
- Verify all installations
- Install makedeb if not already present

### Step 2: Build Free5GC Packages

After installing all dependencies, build the Free5GC packages:

```bash
# Navigate to the free5gc directory
cd ../free5gc

# Build the packages
makedeb -s
```

This will generate four `.deb` packages in the parent directory:
- `free5gc_*.deb` - Core network functions (AMF, SMF, NRF, etc.)
- `free5gc-upf_*.deb` - User Plane Function and related utilities
- `free5gc-webconsole_*.deb` - Web-based management console
- `gtp5g-dkms_*.deb` - GTP5G kernel module (using DKMS)

### Step 3: Install Free5GC Packages

Install the packages in the following order:

```bash
# Install the GTP5G kernel module
sudo apt install ../gtp5g-dkms_*.deb

# Install the core network functions
sudo apt install ../free5gc_*.deb

# Install the User Plane Function
sudo apt install ../free5gc-upf_*.deb

# Install the web console
sudo apt install ../free5gc-webconsole_*.deb
```

## Configuration

The configuration files are located in `/etc/free5gc/`. Modify them according to your network setup before starting the services.

## Starting the Services

After installation, start the Free5GC services using systemd:

```bash
# Load GTP5G kernel module
sudo systemctl enable --now gtp5g

# Start core network functions
sudo systemctl enable --now free5gc-nrf
sudo systemctl enable --now free5gc-amf
sudo systemctl enable --now free5gc-smf
sudo systemctl enable --now free5gc-upf
# Add other NFs as needed

# Start web console
sudo systemctl enable --now free5gc-webconsole
```

The web console is accessible at `http://localhost:5000` by default.

## License

Free5GC is licensed under the Apache License 2.0.

## Acknowledgments

- [Free5GC Project](https://github.com/free5gc/free5gc)
- [makedeb](https://makedeb.org/)
