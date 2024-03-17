#!/bin/bash
# set -x
# set -e
function user_exists() { id "$1" &>/dev/null; }

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
		if user_exists makepkg; then
			echo "run makepkg as user makepkg"
			su makepkg -c "updpkgsums"
			su makepkg -c "makepkg --printsrcinfo > .SRCINFO"
		else
			updpkgsums
			makepkg --printsrcinfo > .SRCINFO
		fi
		popd
		git add $PKG_NAME
		git commit -m "update $PKG_NAME from $OLD_VER to $NEW_VER"
		;;
	esac
 	aurpublish $PKG_NAME -s

}

# use nvchecker to check new versions
if [[ -f key.toml ]]; then
	nvchecker --logger both -c nvchecker.toml -k key.toml | tee nvchecker.log
else
	nvchecker --logger both -c nvchecker.toml | tee nvchecker.log
fi

# update pkgbuilds
grep '"event": "updated"' nvchecker.log | while read line; do
	PKG_NAME=$(echo $line | jq -r '.name')
	PKG_VER=$(echo $line | jq -r '.version')
	update_pkg $PKG_NAME $PKG_VER
done

# commit nvchecker changes
nvtake -c nvchecker.toml --all
git commit -am "nvchecker update" || echo "nothing to update"

