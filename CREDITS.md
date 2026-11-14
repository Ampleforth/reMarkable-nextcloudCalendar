# Credits and licenses

Nextcloud Calendar is licensed under **GNU GPL version 3 only**. See [LICENSE](LICENSE).

The idea for this app was inspired by **[Nicko Guyer’s reMarkable Calendar](https://github.com/nguyer/remarkable-calendar)**.

Major thanks to **[jdkruzr](https://github.com/jdkruzr)** for the **Lasso to Task**
functionality we “stole” **(with permission)** from his
**[reTaskable project](https://github.com/jdkruzr/reTaskable)**.

## reTaskable — jdkruzr

The optional handwriting lasso capture hook is adapted from
[jdkruzr's reTaskable](https://github.com/jdkruzr/reTaskable),
`app/xovi/retaskableSend.qmd`, commit
`90fa23d2bb3ffad1f89dc045bc2c983174124667`, under GPL-3.0-only.
Credit to jdkruzr for the original non-destructive handwriting capture, recognition
dialog and source-note metadata. Nextcloud Calendar adds its own review queue,
progress, duplicate prevention and Discard behavior.

The full upstream license is in each bundle's
`licenses/reTaskable-GPL-3.0-only.txt`.

## Other work

- The toolbar includes adapted MIT-licensed code from Nicko Guyer’s reMarkable Calendar; its notice is retained in each bundle's `LICENSE.upstream.md`.
- [Go](https://go.dev/) — BSD-style license, included in `licenses/Go-BSD-3-Clause.txt`.
- [emersion/go-ical](https://github.com/emersion/go-ical) — MIT, included in `licenses/go-ical-MIT.txt`.
- [teambition/rrule-go](https://github.com/teambition/rrule-go) — MIT, included in `licenses/rrule-go-MIT.txt`.
- [XOVI](https://github.com/asivery/xovi), [AppLoad](https://github.com/asivery/rm-appload), [Vellum](https://github.com/vellum-dev/vellum), and [reManager](https://github.com/rmitchellscott/reManager) provide the surrounding community platform. They are separate projects with their own licenses.

The complete corresponding application source for each distributed version is
available in the matching `nextcloud-calendar-VERSION-source.tar.gz` download on
[GitHub Releases](https://github.com/Ampleforth/reMarkable-nextcloudCalendar/releases).
The Vellum recipe compiles that source; it does not repackage the prebuilt app.

This is an independent community project, not affiliated with reMarkable or
Nextcloud. Their names and marks belong to their respective owners.
