#!/bin/bash
set -e

if [ $# -lt 2 ]; then
    echo "usage: $0 <deb-file> <output-dir>"
    exit 1
fi

DEB_FILE="$1"
OUTPUT_DIR="$2"
WORK_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$WORK_DIR"
}
trap cleanup EXIT

PKG_NAME=$(dpkg-deb -f "$DEB_FILE" Package)
PKG_VERSION=$(dpkg-deb -f "$DEB_FILE" Version | sed 's/[:-]/_/g' | cut -d'+' -f1)

echo "converting $PKG_NAME v$PKG_VERSION..."

cd "$WORK_DIR"
ar x "$DEB_FILE"

if [ -f data.tar.xz ]; then
    tar xf data.tar.xz
elif [ -f data.tar.zst ]; then
    tar xf data.tar.zst
elif [ -f data.tar.gz ]; then
    tar xf data.tar.gz
else
    echo "error: no data.tar found"
    exit 1
fi

mkdir -p build/bin

for dir in usr/bin usr/local/bin bin usr/sbin sbin; do
    if [ -d "$dir" ]; then
        find "$dir" -maxdepth 1 -type f -executable -exec cp {} build/bin/ \;
    fi
done

if [ -z "$(ls -A build/bin 2>/dev/null)" ]; then
    echo "warning: no binaries found in $PKG_NAME, skipping"
    exit 0
fi

cat > build/info << EOF
name = $PKG_NAME
version = $PKG_VERSION
EOF

mkdir -p "$OUTPUT_DIR"
OUTPUT_FILE="$OUTPUT_DIR/$PKG_NAME.pls"

cd build
tar cf - . | zstd -3 -o "$OUTPUT_FILE"

echo "created $OUTPUT_FILE"
