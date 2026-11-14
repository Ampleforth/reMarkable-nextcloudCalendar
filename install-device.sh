#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-only
set -eu
archive=$1
expected=$2
case "$archive" in /home/root/calendar-install.*/app.tar.gz) ;; *) echo 'Invalid staging path.' >&2; exit 2 ;; esac
case "$expected" in armv7l|aarch64) ;; *) exit 2 ;; esac
test "$(id -u)" = 0 || { echo 'Connect as root.' >&2; exit 1; }
test "$(uname -m)" = "$expected" || { echo 'Wrong architecture for this tablet.' >&2; exit 1; }
test -f /home/root/xovi/extensions.d/appload.so || { echo 'Install working XOVI and AppLoad first.' >&2; exit 1; }
for pid in $(pidof entry 2>/dev/null || true); do
    case "$(readlink /proc/$pid/exe)" in */nextcloud-calendar/backend/entry) echo 'Close Nextcloud Calendar, then retry.' >&2; exit 1 ;; esac
done
stage=${archive%/app.tar.gz}
tar -xzf "$archive" -C "$stage"
bundle="$stage/nextcloud-calendar"
test -f "$bundle/backend/entry"
chmod 755 "$bundle/backend/entry"
test -x "$bundle/backend/entry"
test -s "$bundle/resources.rcc"
test -s "$bundle/manifest.json"
test "$(cat "$bundle/architecture")" = "$expected"
root=/home/root/xovi/exthome/appload
backup=/home/root/.local/share/nextcloud-calendar/backups/$(date +%Y%m%d-%H%M%S)-$$
mkdir -p "$root" "$backup" /home/root/.local/share/nextcloud-calendar/intake
chmod 700 "$backup" /home/root/.local/share/nextcloud-calendar/intake
if [ -f /home/root/.local/share/nextcloud-calendar/state.json ]; then
    cp -p /home/root/.local/share/nextcloud-calendar/state.json "$backup/state.json"
fi
if [ -d "$root/nextcloud-calendar" ]; then mv "$root/nextcloud-calendar" "$backup/bundle"; fi
if ! mv "$bundle" "$root/nextcloud-calendar"; then
    if [ -d "$backup/bundle" ]; then mv "$backup/bundle" "$root/nextcloud-calendar"; fi
    exit 1
fi
icon_target="icon-$(date +%Y%m%d-%H%M%S)-$$.png"
mv "$root/nextcloud-calendar/icon.png" "$root/nextcloud-calendar/$icon_target"
ln -s "$icon_target" "$root/nextcloud-calendar/icon.png"
printf 'Installed Nextcloud Calendar %s (%s).\n' "$(cat "$root/nextcloud-calendar/VERSION")" "$expected"
printf 'Backup: %s\n' "$backup"
printf 'Close other AppLoad apps, tap AppLoad Reload, and open Nextcloud Calendar.\n'
printf 'See INSTALL.md to enable the optional lasso and home-screen shortcut hooks.\n'
rm -f "$archive" "$stage/install-device.sh"
rmdir "$stage"
