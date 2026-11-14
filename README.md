# reMarkable Nextcloud Calendar

## Features

- **reMarkable device support:** RM1 and RM2 use the ARMv7 build; Paper Pro and Paper Pro Move use the aarch64 build.
- **reTaskable “Lasso to Task”:** select handwriting in a notebook and queue it for conversion into Nextcloud tasks. Review imports one by one, save or discard each, and keep unfinished captures for later.
- **Launch from the main reMarkable UI:** repurpose the Meeting Notes calendar icon to open Nextcloud Calendar. A Settings toggle restores the original action when disabled.
- **Choose your first day of the week:** the **Start of week** dropdown in Settings accepts any weekday—Sunday, Monday, Wednesday, or whichever you prefer—and applies it to month and week views.
- **Paper Pro and Paper Pro Move color:** select an individual color for each calendar or task list. Events and tasks use matching accents, and calendar/list selectors show matching colored circles. RM1/RM2 keep the grayscale appearance.
- **Paper Pro Move layouts:** enable **Paper Pro Move** in the aarch64 Settings screen for a readable portrait weekly overview. Rotate to landscape for the full seven-day timeline. Day, month, tasks and editors fit the narrower screen too.
- **Calendar and task management:** day/week/month views, all-day events, overlapping appointments, event/task creation and editing, task completion, scheduled/due dates, priorities, and calendar/list filtering.
- **Pending import count:** **3 Pending Task Imports** or **1 Pending Task Import** reflects the actual waiting queue, updates automatically, and disappears at zero. On color devices it is light red with black text and outline. Import sits to the left of Tasks; Tasks stays at the far right.
- **Offline work and direct Nextcloud sync:** cache data on the tablet, queue edits offline, and upload with Sync. Conflicts are shown instead of silently overwriting server changes. Settings include 12/24-hour time and a masked app-password field.

**[Download the latest version](https://github.com/Ampleforth/reMarkable-nextcloudCalendar/releases/latest)** · **[Step-by-step installation](INSTALL.md)** · **[Credits and licenses](CREDITS.md)**

## Supported devices

| Device | Build | Appearance |
| --- | --- | --- |
| reMarkable 1 | `armv7` | Grayscale |
| reMarkable 2 | `armv7` | Grayscale |
| reMarkable Paper Pro | `aarch64` | Color accents |
| reMarkable Paper Pro Move | `aarch64` | Color accents; optional Move layout |

XOVI and AppLoad must match your device and firmware. The standalone RM2 app has been tested on the tablet. Paper Pro/Move builds and layouts have passed off-device checks; physical color-device and rotation validation is still pending. Optional notebook/launcher hooks are firmware-specific; see the installation guide.

## RM1 / RM2 screenshots

Fresh screenshots of the ARMv7 interface, rendered at **1404 × 1872** using fictional data.

| Day | Week |
| --- | --- |
| ![RM1/RM2 day](images/rm1-rm2-day.png) | ![RM1/RM2 week](images/rm1-rm2-week.png) |

| Month | Tasks |
| --- | --- |
| ![RM1/RM2 month](images/rm1-rm2-month.png) | ![RM1/RM2 tasks](images/rm1-rm2-tasks.png) |

| Event editor | Settings |
| --- | --- |
| ![RM1/RM2 event editor](images/rm1-rm2-editor.png) | ![RM1/RM2 Settings](images/rm1-rm2-settings.png) |

## Paper Pro screenshots

Fresh aarch64 color-interface screenshots at the full **1620 × 2160** Paper Pro resolution. These are UI renders, not photographs of color hardware.

| Day | Week |
| --- | --- |
| ![Paper Pro day](images/paper-pro-day.png) | ![Paper Pro week](images/paper-pro-week.png) |

| Month | Tasks |
| --- | --- |
| ![Paper Pro month](images/paper-pro-month.png) | ![Paper Pro tasks](images/paper-pro-tasks.png) |

| Event editor | Settings |
| --- | --- |
| ![Paper Pro event editor](images/paper-pro-editor.png) | ![Paper Pro Settings](images/paper-pro-settings.png) |

## Paper Pro Move screenshots

Fresh Move-layout screenshots at **954 × 1696** in portrait and **1696 × 954** in landscape, using fictional data.

| Day | Portrait weekly overview |
| --- | --- |
| ![Move day](images/paper-pro-move-day.png) | ![Move portrait week](images/paper-pro-move-week.png) |

![Move landscape full-week timeline](images/paper-pro-move-week-landscape.png)

| Month | Tasks |
| --- | --- |
| ![Move month](images/paper-pro-move-month.png) | ![Move tasks](images/paper-pro-move-tasks.png) |

| Event editor | Settings |
| --- | --- |
| ![Move event editor](images/paper-pro-move-editor.png) | ![Move Settings](images/paper-pro-move-settings.png) |

Open any image to view its original resolution.

## Install and connect

Use **[INSTALL.md](INSTALL.md)** for complete Windows, macOS, Linux, Vellum and reManager instructions. No compiler is required for manual installation. This repository contains installation bundles and packaging metadata; matching application source is supplied as a separate download on the same release.

After installation, open **AppLoad → Nextcloud Calendar → Settings**, enter your Nextcloud HTTPS base URL, username and app password, then **Save & sync**. Select the calendars/task lists you want to see.

## Credits

The idea was inspired by **[Nicko Guyer’s reMarkable Calendar](https://github.com/nguyer/remarkable-calendar)**.

Major thanks to **[jdkruzr](https://github.com/jdkruzr)** for the **Lasso to Task** functionality we “stole” **(with permission)** from his **[reTaskable project](https://github.com/jdkruzr/reTaskable)**. Their non-destructive handwriting recognition and capture dialog made this integration possible. Thanks also to the XOVI, AppLoad and Vellum/reManager projects. Full attribution and licenses are in [CREDITS.md](CREDITS.md).

## Limits and privacy

Sync is manual. Recurring events and meeting invitations are viewable but read-only. Captured tasks retain notebook/page information in Description; jump-back navigation is not included. Calendar colors are local display preferences, not changes to Nextcloud's own colors.

Credentials, caches and captures stay on your tablet and are not distributed. The app password is stored locally with restrictive permissions, without encryption; it is never loaded back into the UI. Use a dedicated Nextcloud app password. See the installation guide for backup, recovery and uninstall steps.
