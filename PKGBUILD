# Maintainer: Your Name <youremail@domain.com>
pkgname=aliyundrive-webdav
pkgver=1.8.2
pkgrel=1
pkgdesc="阿里云盘 WebDAV 服务"
arch=('x86_64')
provides=('aliyundrive-webdav')
url="https://github.com/messense/aliyundrive-webdav/"
license=('MIT')
depends=('gcc-libs')
makedepends=('cargo')
#options=('!lto')
source=("https://github.com/messense/$pkgname/archive/v$pkgver.tar.gz")
sha256sums=('2288dedb872cbf792dbd17b270793dd6deebbd278288040a3d51ad94d962105e')

# template start; name=rust; version=1;
prepare() {
	cd "$pkgname-$pkgver"
	cargo fetch --locked --target "$CARCH-unknown-linux-gnu"
}

build() {
	cd "$pkgname-$pkgver"
	CFLAGS+=" -ffat-lto-objects"
	cargo build --frozen --release --all-features
}
# template end;
package() {
	cd "$pkgname-$pkgver"
	install -Dm755 "target/release/${pkgname}" -t "${pkgdir}/usr/bin/"
	install -Dm644 "LICENSE" -t "${pkgdir}/usr/share/licenses/${pkgname}/"
	install -Dm644 "systemd.service" -T "${pkgdir}/usr/lib/systemd/system/$pkgname.service"
}
