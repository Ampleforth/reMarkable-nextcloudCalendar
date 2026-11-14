#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only
set -euo pipefail
cd -- "$(dirname -- "$0")"
if [[ $# != 2 || -z "$2" || "$2" == -* ]]; then
    echo 'Usage: ./install.sh armv7|aarch64 SSH_ALIAS_OR_ROOT_AT_TABLET_ADDRESS' >&2
    exit 2
fi
case "$1" in armv7) expected=armv7l ;; aarch64) expected=aarch64 ;; *) echo 'Choose armv7 or aarch64.' >&2; exit 2 ;; esac
bundle="$1/nextcloud-calendar"
target=$2
[[ -x "$bundle/backend/entry" && -s "$bundle/resources.rcc" && -f install-device.sh ]] || { echo 'Extract the complete matching download first.' >&2; exit 1; }
[[ $(cat "$bundle/architecture") == "$expected" ]] || { echo 'Bundle architecture mismatch.' >&2; exit 1; }
for tool in ssh scp tar; do command -v "$tool" >/dev/null || { echo "Install $tool first." >&2; exit 1; }; done
local_stage=$(mktemp -d)
trap 'rm -rf -- "$local_stage"' EXIT
COPYFILE_DISABLE=1 tar -czf "$local_stage/app.tar.gz" -C "$1" nextcloud-calendar
remote_stage=$(ssh "$target" 'mktemp -d /home/root/calendar-install.XXXXXX')
[[ "$remote_stage" =~ ^/home/root/calendar-install\.[A-Za-z0-9]+$ ]] || { echo 'Could not establish a clean SSH connection.' >&2; exit 1; }
if ! scp "$local_stage/app.tar.gz" install-device.sh "$target:$remote_stage/"; then
    echo 'Retrying with legacy SCP for tablet SSH compatibility.'
    scp -O "$local_stage/app.tar.gz" install-device.sh "$target:$remote_stage/"
fi
ssh "$target" sh "$remote_stage/install-device.sh" "$remote_stage/app.tar.gz" "$expected"
