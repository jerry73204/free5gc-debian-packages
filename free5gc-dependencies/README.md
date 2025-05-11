# Free5GC Dependencies Meta-Package

This directory contains the files needed to build a meta-package that automatically sets up all repositories required for Free5GC.

## What This Package Does

When installed, this package will:

1. Add the following repositories:
   - MongoDB 7.0
   - Go 1.21+ (via PPA)
   - Node.js 20.x
   - Yarn

2. Include basic dependencies in the package:
   - Development tools (gcc, g++, cmake, etc.)
   - Required libraries (libmnl-dev, libyaml-dev, etc.)
   - Common utilities (curl, wget, etc.)

## Building the Package

```bash
# Navigate to the meta-package directory
cd free5gc-dependencies

# Build the package using makedeb
makedeb -s
```

This will create a `.deb` package in the parent directory, named something like `free5gc-dependencies_1.0.0-1_all.deb`.

## Installing the Package

After building the package, you can install it with:

```bash
sudo apt install ../free5gc-dependencies_1.0.0-1_all.deb
```

## After Installation

After installing the meta-package, you need to manually update the package lists and install the additional dependencies:

```bash
# Update package lists to include the newly added repositories
sudo apt-get update

# Install the required dependencies from the added repositories
sudo apt-get install mongodb-org golang-1.21 nodejs yarn
```

Once all dependencies are installed, you can proceed to build the main Free5GC packages:

```bash
# Navigate to the free5gc directory
cd ../free5gc

# Build the Free5GC packages
makedeb -s
```

## Removal

To remove the dependencies meta-package:

```bash
sudo apt remove free5gc-dependencies
```

Note that this will not remove the repositories or dependencies that were installed. To completely remove all added repositories, you would need to manually remove the relevant files from `/etc/apt/sources.list.d/`.