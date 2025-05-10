# Free5GC Debian Packages

This repository contains makedeb PKGBUILD files for building Free5GC as Debian packages.

## Package Structure

The build creates four packages:

1. `free5gc` - Core network functions (AMF, SMF, NRF, etc.)
2. `free5gc-upf` - User Plane Function and related utilities
3. `free5gc-webconsole` - Web-based management console
4. `gtp5g-dkms` - GTP5G kernel module (using DKMS for kernel integration)

## Requirements

- Debian 12+ or Ubuntu 22.04+
- Linux Kernel 5.4+
- Go 1.21.8+
- MongoDB 7.0+
- Node.js and Yarn (for webconsole)

## Build Dependencies

Before building, install the required dependencies:

```bash
sudo apt update
sudo apt install git golang gcc g++ cmake autoconf libtool pkg-config \
    libmnl-dev libyaml-dev nodejs npm dkms mongodb
```

## Building the Packages

1. Install makedeb if you haven't already:

```bash
# Install makedeb
bash -ci "$(wget -qO - 'https://shlink.makedeb.org/install')"
```

2. Clone this repository:

```bash
git clone https://github.com/yourusername/free5gc-debian-packages.git
cd free5gc-debian-packages
```

3. Build the packages:

```bash
makedeb -s
```

This will generate four .deb packages in the parent directory:
- `free5gc_4.0.1-1_amd64.deb`
- `free5gc-upf_4.0.1-1_amd64.deb`
- `free5gc-webconsole_4.0.1-1_amd64.deb`
- `gtp5g-dkms_4.0.1-1_amd64.deb`

## Installation

Install the packages in the following order:

```bash
sudo apt install ./gtp5g-dkms_4.0.1-1_amd64.deb
sudo apt install ./free5gc_4.0.1-1_amd64.deb
sudo apt install ./free5gc-upf_4.0.1-1_amd64.deb
sudo apt install ./free5gc-webconsole_4.0.1-1_amd64.deb
```

## Configuration

The configuration files are located in `/etc/free5gc/`. Modify them according to your network setup before starting the services.

## Starting the Services

After installation, you can start all Free5GC services using systemd:

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