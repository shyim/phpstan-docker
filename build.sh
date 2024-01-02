#!/usr/bin/env bash

set -eo pipefail

version=$1
arch=$2
params=$3

if [ -z "$version" ]; then
  echo "Usage: $0 <version> <arch>"
  exit 1
fi

if [ -z "$arch" ]; then
  echo "Usage: $0 <version> <arch>"
  exit 1
fi

echo "Building version $version"

rm -rf rootfs
mkdir rootfs

if [[ ! -d db ]]; then
  git clone -b ubuntu-23.10-php https://github.com/shyim/chisel-releases.git db
fi

chisel cut --arch=$arch --release ./db --root rootfs/ php8.2-cli_base php8.2-common_all-cli php8.2-common_phar-cli php8.2-mbstring_cli php8.2-xml_dom-cli dash_bins

docker build --platform "linux/${arch}" --build-arg PHPSTAN_VERSION=${version} -t "shyim/phpstan:${version}-${arch}" .

if [[ "$params" == "--push" ]]; then
  docker push "shyim/phpstan:${version}-${arch}"
fi
