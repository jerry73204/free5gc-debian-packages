# Maintainer: Hsiang-Jui Lin <jerry73204@gmail.com>

pkgbase=free5gc
pkgname=(
    'free5gc'
    'free5gc-upf'
    'free5gc-webconsole'
    'gtp5g-dkms'
)
pkgver=4.0.1
pkgrel=1
pkgdesc="Open source 5G core network"
arch=('amd64')
url="https://free5gc.org/"
license=('Apache')
depends=(
    'mongodb-org'
    'libyaml-cpp0.7'
    'libmnl0'
)
makedepends=(
    'libyaml-cpp-dev'
    'libmnl-dev'
    'git'
    'golang-go>=1.21.8'
    'gcc'
    'g++'
    'cmake'
    'autoconf'
    'libtool'
    'pkg-config'
    'libmnl-dev'
    'libyaml-dev'
    'nodejs'
    'npm'
    'yarn'
)
source=(
    "git+https://github.com/free5gc/free5gc.git#tag=v${pkgver}"
    "git+https://github.com/free5gc/gtp5g.git#branch=v0.9.14"
    "git+https://github.com/free5gc/go-gtp5gnl.git"
    "free5gc-nf.service"
    "free5gc-upf.service"
    "gtp5g.service"
    "free5gc-webconsole.service"
    "dkms.conf.in"
)
sha256sums=(
    'SKIP'
    'SKIP'
    'SKIP'
    'SKIP'
    'SKIP'
    'SKIP'
    'SKIP'
    'SKIP'
)

prepare() {
    cd "${srcdir}/free5gc"
    git submodule init
    git submodule update --recursive
}

build() {
    # Build gtp5g kernel module
    cd "${srcdir}/gtp5g"
    make clean
    make

    # Build free5gc
    cd "${srcdir}/free5gc"
    make

    # Build WebConsole
    make webconsole

    # Build gtp5g-tunnel utility
    cd "${srcdir}/go-gtp5gnl"
    mkdir -p bin
    cd cmd/gogtp5g-tunnel
    go build -o "${srcdir}/go-gtp5gnl/bin/gtp5g-tunnel" .
}

package_free5gc() {
    provides=('free5gc')
    conflicts=('free5gc')

    # Create directory structure
    mkdir -p "${pkgdir}/usr/bin"
    mkdir -p "${pkgdir}/etc/free5gc"
    mkdir -p "${pkgdir}/usr/share/free5gc"
    mkdir -p "${pkgdir}/usr/lib/systemd/system"

    # Install all NFs except UPF (which goes in its own package)
    cd "${srcdir}/free5gc"
    for nf in amf ausf nrf nssf pcf smf udm udr n3iwf chf tngf nef; do
        install -Dm755 "bin/${nf}" "${pkgdir}/usr/bin/free5gc-${nf}"
    done

    # Install configuration
    cp -r config/* "${pkgdir}/etc/free5gc/"

    # Install systemd service files for each NF
    for nf in amf ausf nrf nssf pcf smf udm udr n3iwf chf tngf nef; do
        install -Dm644 "${srcdir}/free5gc-nf.service" "${pkgdir}/usr/lib/systemd/system/free5gc-${nf}.service"
        sed -i "s/%i/${nf}/g" "${pkgdir}/usr/lib/systemd/system/free5gc-${nf}.service"
    done

    # Install scripts
    install -Dm755 "${srcdir}/free5gc/reload_host_config.sh" "${pkgdir}/usr/share/free5gc/reload_host_config.sh"

    # Install certificates
    cp -r cert "${pkgdir}/etc/free5gc/"
}

package_free5gc-upf() {
    pkgdesc="User Plane Function for free5gc"
    depends=('free5gc' 'gtp5g-dkms')
    conflicts=('free5gc-upf')
    provides=('free5gc-upf')

    mkdir -p "${pkgdir}/usr/bin"
    mkdir -p "${pkgdir}/etc/free5gc"
    mkdir -p "${pkgdir}/usr/lib/systemd/system"

    # Install UPF binary
    cd "${srcdir}/free5gc"
    install -Dm755 "bin/upf" "${pkgdir}/usr/bin/free5gc-upf"

    # Install gtp5g-tunnel utility
    install -Dm755 "${srcdir}/go-gtp5gnl/bin/gtp5g-tunnel" "${pkgdir}/usr/bin/gtp5g-tunnel"

    # Install UPF config
    install -Dm644 "config/upfcfg.yaml" "${pkgdir}/etc/free5gc/config/upfcfg.yaml"

    # Install systemd service files for UPF and gtp5g
    install -Dm644 "${srcdir}/free5gc-upf.service" "${pkgdir}/usr/lib/systemd/system/free5gc-upf.service"
    install -Dm644 "${srcdir}/gtp5g.service" "${pkgdir}/usr/lib/systemd/system/gtp5g.service"
}

package_free5gc-webconsole() {
    pkgdesc="Web console for free5gc"
    depends=('free5gc' 'nodejs')
    conflicts=('free5gc-webconsole')
    provides=('free5gc-webconsole')

    mkdir -p "${pkgdir}/usr/bin"
    mkdir -p "${pkgdir}/etc/free5gc"
    mkdir -p "${pkgdir}/usr/share/free5gc-webconsole"
    mkdir -p "${pkgdir}/usr/lib/systemd/system"

    # Install webconsole binary and frontend files
    cd "${srcdir}/free5gc"
    install -Dm755 "webconsole/bin/webconsole" "${pkgdir}/usr/bin/free5gc-webconsole"
    cp -r "webconsole/public" "${pkgdir}/usr/share/free5gc-webconsole/"

    # Install webconsole config
    install -Dm644 "config/webuicfg.yaml" "${pkgdir}/etc/free5gc/webuicfg.yaml"

    # Install systemd service file for webconsole
    install -Dm644 "${srcdir}/free5gc-webconsole.service" "${pkgdir}/usr/lib/systemd/system/free5gc-webconsole.service"
}

package_gtp5g-dkms() {
    pkgdesc="GTP5G kernel module for free5gc (DKMS version)"
    depends=('dkms')
    conflicts=('gtp5g-dkms')
    provides=('gtp5g-dkms')

    cd "${srcdir}/gtp5g"

    # Create directories
    mkdir -p "${pkgdir}/usr/src/gtp5g-${pkgver}"

    # Copy all source files
    cp -r . "${pkgdir}/usr/src/gtp5g-${pkgver}/"

    # Install and configure dkms.conf from template
    install -Dm644 "${srcdir}/dkms.conf.in" "${pkgdir}/usr/src/gtp5g-${pkgver}/dkms.conf"
    sed -i "s/@VERSION@/${pkgver}/g" "${pkgdir}/usr/src/gtp5g-${pkgver}/dkms.conf"
}
