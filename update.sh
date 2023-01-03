#!/bin/bash
# set -x
set -e
function update_pkg() {
	PKG_NAME=$1
	NEW_VER=$(echo "$2" | sed 's/^[^.0-9]*//')
	OLD_VER=$(cat $PKG_NAME/PKGBUILD | grep ^pkgver | awk -F = '{print $2}')
	case $(vercmp $NEW_VER $OLD_VER) in
	0)
		echo "$PKG_NAME : latest with upstream"
		;;
	-1)
		echo "$PKG_NAME : invalid new version"
		echo "OLD_VER : $OLD_VER"
		echo "NEW_VER : $NEW_VER"
		;;
	1)
		pushd $PKG_NAME
		sed "s/^pkgver=.*$/pkgver=${NEW_VER}/" -i PKGBUILD
		sed "s/^pkgrel=.*$/pkgrel=1/" -i PKGBUILD
		updpkgsums
		popd
		git add .
		git commit
		aurpublish $PKG_NAME
		;;
	esac
}

function check_ver() {
	nvchecker --logger both -c nvchecker.toml | tee nvchecker.log
	nvtake -c nvchecker.toml --all
	git add .
	if git diff --exit-code >/dev/null; then
		git commit -m "nvchecker update"
	fi

}

check_ver

grep '"event": "updated"' nvchecker.log | while read line; do
	PKG_NAME=$(echo $line | jq -r '.name')
	PKG_VER=$(echo $line | jq -r '.version')
	update_pkg $PKG_NAME $PKG_VER
done
