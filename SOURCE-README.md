# Nextcloud Calendar 0.3.1 — corresponding source

This source tree contains the application source, vendored Go dependencies, QML,
licenses, tests, and the scripts used to produce the released app bundles.
The `v0.3.1-source` tag records the exact source files from the original
`nextcloud-calendar-0.3.1-source.tar.gz` release attachment, alongside the
installation bundles and documentation. The existing `v0.3.1` tag is preserved.
Vellum can build from the GitHub archive of `v0.3.1-source`.

Requirements: Go 1.25+, Qt 6 rcc, rsvg-convert, Python 3.

    ./scripts/build.sh
    CALENDAR_GOARCH=arm64 ./scripts/build.sh

The ARMv7 bundle is written to dist/nextcloud-calendar/; aarch64 is written to
dist/nextcloud-calendar-arm64/. Set GO or RCC to executable paths if necessary.
Both builds use CGO_ENABLED=0, Linux targets, trimmed paths and stripped binaries.
No credentials or runtime state are included.

Validation:

    go test -race ./...
    go vet ./...
    QT_QPA_PLATFORM=offscreen QT_QPA_PLATFORMTHEME=generic QT_QUICK_BACKEND=software qmltestrunner -input tests/qml -import tests/qml/imports
    python3 tests/lifecycle.py dist/nextcloud-calendar-arm64/backend/entry

The lifecycle command runs on an aarch64 Linux host; it is not a claim of tablet
hardware validation. Source licensing and reTaskable attribution are retained in
LICENSE, LICENSE.upstream.md, THIRD_PARTY_NOTICES.md and licenses/.
