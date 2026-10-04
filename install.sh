#!/bin/sh
set -eu

repository="vineethkrishnan/homebrew-tap"
install_dir="${REGROW_INSTALL_DIR:-$HOME/.local/bin}"
version="${REGROW_VERSION:-}"

fail() {
    echo "error: $1" >&2
    exit 1
}

[ "$(uname -s)" = "Darwin" ] || fail "ReGrow runs on macOS only."
macos_major="$(sw_vers -productVersion | cut -d. -f1)"
[ "$macos_major" -ge 14 ] || fail "ReGrow needs macOS 14 or later; this Mac has $(sw_vers -productVersion)."

work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

if [ -n "${REGROW_ARCHIVE:-}" ]; then
    archive_path="$REGROW_ARCHIVE"
    checksum_path="$REGROW_ARCHIVE.sha256"
    [ -f "$archive_path" ] || fail "$archive_path does not exist."
    [ -f "$checksum_path" ] || fail "$checksum_path does not exist; it must sit next to the archive."
else
    if [ -z "$version" ]; then
        version="$(curl -fsSL "https://api.github.com/repos/$repository/releases/latest" \
            | sed -n 's/.*"tag_name": *"regrow-v\([^"]*\)".*/\1/p' | head -n 1)"
        [ -n "$version" ] || fail "could not find the latest release. Set REGROW_VERSION, for example REGROW_VERSION=0.7.0."
    fi
    archive_name="regrow-$version-macos-universal.tar.gz"
    base_url="https://github.com/$repository/releases/download/regrow-v$version"
    archive_path="$work_dir/$archive_name"
    checksum_path="$archive_path.sha256"
    echo "Downloading ReGrow $version"
    curl -fsSL -o "$archive_path" "$base_url/$archive_name" || fail "download of $base_url/$archive_name failed."
    curl -fsSL -o "$checksum_path" "$base_url/$archive_name.sha256" || fail "download of the checksum failed."
fi

expected="$(cut -d' ' -f1 < "$checksum_path")"
actual="$(shasum -a 256 "$archive_path" | cut -d' ' -f1)"
[ "$expected" = "$actual" ] || fail "checksum mismatch for $(basename "$archive_path"); nothing was installed. Download it again."

tar -xzf "$archive_path" -C "$work_dir" regrow
mkdir -p "$install_dir"
mv -f "$work_dir/regrow" "$install_dir/regrow"
chmod 755 "$install_dir/regrow"
echo "Installed $("$install_dir/regrow" --version) to $install_dir/regrow"

case ":$PATH:" in
*":$install_dir:"*) echo "Next: regrow devices" ;;
*) echo "Next: add $install_dir to your PATH, for example: echo 'export PATH=\"$install_dir:\$PATH\"' >> ~/.zshrc" ;;
esac
