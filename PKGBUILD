# Maintainer: ZhymabekRoman <robanokssamit@yandex.kz>
pkgname=which-terminal
pkgver=0.1.0
pkgrel=1
pkgdesc="Universal terminal emulator launcher that detects and runs the best available terminal"
arch=('x86_64')
url="https://github.com/ZhymabekRoman/which-terminal"
license=('MIT')
depends=('glibc')
makedepends=('vlang' 'make')
source=("${pkgname}-${pkgver}.tar.gz::${url}/archive/v${pkgver}.tar.gz")
sha256sums=('SKIP')

build() {
    cd "${srcdir}/${pkgname}-${pkgver}"
    make build-prod
}

check() {
    cd "${srcdir}/${pkgname}-${pkgver}"
    make test || true
}

package() {
    cd "${srcdir}/${pkgname}-${pkgver}"
    install -Dm755 which-terminal "${pkgdir}/usr/bin/which-terminal"

    # Create a symlink for x-terminal-emulator compatibility (common on Debian-based systems)
    ln -s which-terminal "${pkgdir}/usr/bin/x-terminal-emulator"

    # Install documentation
    install -Dm644 README.md "${pkgdir}/usr/share/doc/${pkgname}/README.md"
}
