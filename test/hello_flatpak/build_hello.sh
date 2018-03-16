#!/bin/bash -e

CURRENT_DIR=$(dirname $0)
REPO_DIR=$CURRENT_DIR/repo
BUILD_DIR=$CURRENT_DIR/build


GPG_HOMEDIR=$CURRENT_DIR/../gpg/verifying
GPG_KEY_ID="verification@ostree.com"

echo "GPG Homedir: $GPG_HOMEDIR"
echo "GPG Key: $GPG_KEY_ID"

# Get the ID of the key with which to sign
SIGNING_KEY=$(gpg --homedir $GPG_HOMEDIR --list-secret-keys | \
              grep -A1 ^sec | \
              tail -1 |  \
              tr -d '[:space:]')

rm -rf "$REPO_DIR" "$BUILD_DIR"

echo "Building..."
flatpak-builder -v \
                --repo=$REPO_DIR \
                --gpg-homedir=$GPG_HOMEDIR \
                --gpg-sign="$GPG_KEY_ID" \
                $BUILD_DIR \
                $CURRENT_DIR/org.ostree.Hello.manifest

echo "Outputting the flatpak bundle..."
flatpak build-bundle $REPO_DIR \
                     --gpg-sign="$GPG_KEY_ID" \
                     --gpg-homedir=$GPG_HOMEDIR \
                     ../hello.flatpak \
                     org.ostree.Hello \
                     master

echo "Generating the tar..."
tar -cf ../hello.tar $REPO_DIR

echo "Generating the tgz..."
tar -czf ../hello.tgz $REPO_DIR

echo "Done!"
