#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only
set -euo pipefail
cd -- "$(dirname -- "$0")/.."
: "${QMLSCENE:=qmlscene}"
command -v "$QMLSCENE" >/dev/null || { echo 'Set QMLSCENE to Qt 6 qmlscene.' >&2; exit 1; }
mkdir -p docs/screenshots
stage=$(mktemp -d examples/.screenshots.XXXXXX)
trap 'rm -rf -- "$stage"' EXIT
export QT_QPA_PLATFORM=offscreen QT_QPA_PLATFORMTHEME=generic QT_QUICK_BACKEND=software
for profile in rm1-rm2 paper-pro paper-pro-move; do
  color=false; move=false
  [[ "$profile" == rm1-rm2 ]] || color=true
  [[ "$profile" != paper-pro-move ]] || move=true
  screens='day week month tasks editor settings'
  [[ "$profile" != paper-pro-move ]] || screens="$screens week-landscape"
  for screen in $screens; do
    view=$screen; editor=false; settings=false; landscape=false
    case "$screen" in
      editor) view=day; editor=true ;;
      settings) view=week; settings=true ;;
      week-landscape) view=week; landscape=true ;;
    esac
    cat > "$stage/capture.qml" <<QML
import QtQuick
import ".."
Demo {demoView:"$view";capturePath:"docs/screenshots/$profile-$screen.png";colorPreview:$color;movePreview:$move;landscapePreview:$landscape;editorPreview:$editor;settingsPreview:$settings}
QML
    "$QMLSCENE" -I tests/qml/imports "$stage/capture.qml"
  done
done
printf 'Rendered three fresh screenshot sets (19 images).\n'
