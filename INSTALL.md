# Install Nextcloud Calendar

These instructions cover Windows, macOS, Linux, Vellum and reManager. You do not
need Go, Qt development tools, or a compiler for the manual installation.

## 1. Choose the right build

| Your tablet | Download / installer choice |
| --- | --- |
| reMarkable 1 | `armv7` |
| reMarkable 2 | `armv7` |
| reMarkable Paper Pro | `aarch64` |
| reMarkable Paper Pro Move | `aarch64`, then enable **Paper Pro Move** in the app's Settings |

The build matches the **tablet**, not your computer. An Apple Silicon Mac still
uses `armv7` when installing onto RM1/RM2. An Intel/AMD Windows PC still uses
`aarch64` for Paper Pro/Move.

Download from the project's [Releases page](https://github.com/Ampleforth/reMarkable-nextcloudCalendar/releases/latest).
Use the archive whose name ends in your tablet architecture and the matching
`SHA256SUMS` from that same release. ZIP is convenient on Windows; either ZIP or
`.tar.gz` works on macOS/Linux. Use the named architecture-specific install archive;
the separate `nextcloud-calendar-VERSION-source.tar.gz` is for Vellum and developers.
Keep all files from the extracted archive together.

## 2. Prepare the tablet — all methods

1. Sync or back up your notebooks before changing the tablet setup.
2. **Paper Pro / Move:** enable Developer Mode if it is not already enabled.
   Follow [reMarkable's official instructions](https://developer.remarkable.com/documentation/developer-mode).
   **Enabling it performs a factory reset**, so finish the backup first. RM1/RM2
   do not need this Developer Mode step.
3. Find the SSH username, password and connection address on the tablet. On the
   documented firmware these are under **Settings → General → Help → About →
   Copyrights and Licenses**; menu grouping can vary by firmware. The username is
   normally `root`. Enter passwords yourself when SSH or reManager prompts.
4. For initial setup, connect the tablet directly to your computer with a USB
   data cable and keep it awake and unlocked. USB networking normally uses
   `10.11.99.1`; use the address actually shown by your tablet/setup. Wi-Fi SSH
   must already be enabled before using its Wi-Fi address instead.
5. Install and activate **XOVI, Qt resource rebuilder, and AppLoad** for your
   tablet/firmware. The easiest cross-platform route is reManager, below.
   Use ARM32 components on RM1/RM2 and ARM64 on Paper Pro/Move. Follow the
   [XOVI](https://github.com/asivery/xovi) and
   [AppLoad](https://github.com/asivery/rm-appload) compatibility instructions.
6. Confirm that AppLoad opens on the tablet. This installer updates the calendar
   app; it does not replace firmware or install XOVI itself.
7. Close Nextcloud Calendar and other AppLoad apps before installing/updating.
   Existing account settings, caches, captures and display preferences are retained.

## 3A. Windows 10/11 — manual installation

1. Download the matching ZIP and `SHA256SUMS` into Downloads.
2. Right-click the ZIP → **Extract All**. Open the extracted folder; it should
   contain `Install.ps1`, `install-device.sh`, this guide and your architecture's
   `nextcloud-calendar` directory.
3. Open **PowerShell** or Windows Terminal in PowerShell mode. Change into that
   extracted folder. For example, substitute the actual version/folder name:

   ```powershell
   cd "$HOME\Downloads\reMarkable-nextcloudCalendar-v0.3.1-armv7"
   ```

4. Check that the OpenSSH client is available:

   ```powershell
   ssh -V
   ```

   If it is missing, open **Windows PowerShell as Administrator**, install only
   the client, then close that administrator window and open a normal PowerShell:

   ```powershell
   Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
   ```

   This is Microsoft's [OpenSSH client installation method](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse).
   Do not install an SSH server on your PC for this task.
5. Verify the downloaded ZIP before installing. Run this against the ZIP, not the
   extracted directory, and compare the result to that filename's line in
   `SHA256SUMS`:

   ```powershell
   Get-FileHash "$HOME\Downloads\reMarkable-nextcloudCalendar-v0.3.1-armv7.zip" -Algorithm SHA256
   ```

6. Test access to your tablet, substituting its address:

   ```powershell
   ssh root@10.11.99.1
   ```

   Confirm the new host key only for the tablet you intended to connect to.
   Type its SSH password at the prompt; password characters do not appear.
   When you reach the tablet shell, type `exit` to return to your computer.
7. Install the app. For RM1/RM2:

   ```powershell
   Unblock-File .\Install.ps1
   .\Install.ps1 -Architecture armv7 -Target root@10.11.99.1
   ```

   For Paper Pro/Move, run from the extracted aarch64 folder instead:

   ```powershell
   Unblock-File .\Install.ps1
   .\Install.ps1 -Architecture aarch64 -Target root@10.11.99.1
   ```

   If Windows says script execution is disabled, invoke this script for the
   current process rather than changing the system-wide policy:

   ```powershell
   powershell.exe -ExecutionPolicy Bypass -File .\Install.ps1 -Architecture armv7 -Target root@10.11.99.1
   ```

   Substitute `aarch64` for Paper Pro/Move. Only run the script extracted from the
   verified project download.
8. Wait for **Installed Nextcloud Calendar** and the backup path. If it reports
   the app is open, close it on the tablet and rerun the same installer.
9. Continue with **Open the app and connect Nextcloud**, below.

## 3B. macOS — manual installation

1. Download the matching `.tar.gz` archive and `SHA256SUMS` into Downloads.
2. Open **Terminal** (Applications → Utilities → Terminal):

   ```sh
   cd ~/Downloads
   shasum -a 256 reMarkable-nextcloudCalendar-v0.3.1-armv7.tar.gz
   ```

   Compare the result to its line in `SHA256SUMS`. For Paper Pro/Move, substitute
   the aarch64 archive name in every command.
3. Extract it and enter the extracted directory:

   ```sh
   tar -xzf reMarkable-nextcloudCalendar-v0.3.1-armv7.tar.gz
   cd reMarkable-nextcloudCalendar-v0.3.1-armv7
   ```

4. Confirm SSH is available, then test the tablet connection:

   ```sh
   ssh -V
   ssh root@10.11.99.1
   ```

   Verify that this is your tablet, enter its SSH password, then type `exit`.
   macOS includes the needed SSH, SCP and tar tools.
5. Run the installer for RM1/RM2:

   ```sh
   bash ./install.sh armv7 root@10.11.99.1
   ```

   Or, from the extracted aarch64 directory, for Paper Pro/Move:

   ```sh
   bash ./install.sh aarch64 root@10.11.99.1
   ```

6. Wait for success and the backup path, then continue below. Use your tablet's
   actual Wi-Fi IP instead of the USB example only if Wi-Fi SSH is enabled.

## 3C. Linux — manual installation

1. Download the matching `.tar.gz` archive and `SHA256SUMS` into Downloads.
2. Open a terminal. Confirm the required tools exist:

   ```sh
   ssh -V
   command -v scp tar
   ```

   If OpenSSH is missing, install the client package for your distribution:

   | Distribution | Command |
   | --- | --- |
   | Debian / Ubuntu | `sudo apt install openssh-client` |
   | Fedora | `sudo dnf install openssh-clients` |
   | Arch | `sudo pacman -S openssh` |

3. Verify the archive's hash against `SHA256SUMS`:

   ```sh
   cd ~/Downloads
   sha256sum reMarkable-nextcloudCalendar-v0.3.1-armv7.tar.gz
   ```

   Substitute `aarch64` in the filename for Paper Pro/Move.
4. Extract and enter the directory:

   ```sh
   tar -xzf reMarkable-nextcloudCalendar-v0.3.1-armv7.tar.gz
   cd reMarkable-nextcloudCalendar-v0.3.1-armv7
   ```

5. Test SSH to the tablet, enter its password, and return with `exit`:

   ```sh
   ssh root@10.11.99.1
   ```

6. Install for RM1/RM2:

   ```sh
   bash ./install.sh armv7 root@10.11.99.1
   ```

   Or use the aarch64 directory and command for Paper Pro/Move:

   ```sh
   bash ./install.sh aarch64 root@10.11.99.1
   ```

   Run this installer as your ordinary computer user; it connects as root on the
   tablet. No laptop `sudo` is required for the installer itself.
7. Wait for success and note the backup path. Continue below.

## 3D. reManager — Windows, macOS or Linux

1. Install [reManager](https://github.com/rmitchellscott/reManager/releases/latest)
   for your computer. Its [official installation page](https://github.com/rmitchellscott/reManager#installation)
   includes Linux Flatpak/binaries, macOS downloads/Homebrew, and Windows downloads.
   Choose the download for your **computer's** operating system and CPU.
2. Launch reManager, connect the awake tablet over USB, and add/select its
   connection using the tablet's address, root username and SSH password.
3. Follow reManager's setup to install Vellum if needed. Install/enable XOVI,
   Qt resource rebuilder and AppLoad for your tablet/firmware; allow dependencies.
4. Refresh the package list and search for **Nextcloud Calendar** / `nextcloud-calendar`.
5. Check the displayed version and supported architecture before installing.
   The catalogue may lag this project's GitHub release. If **0.3.1** is not yet
   offered for your architecture, use the matching manual download above for
   these features; do not assume an older package contains them.
6. If the current version is available, install/update it and accept required
   dependencies. Reload XOVI/AppLoad when reManager prompts.
7. Open the app on the tablet, then follow account setup below.

reManager is a Vellum frontend; catalogue availability is controlled by the
[Vellum package repository](https://github.com/vellum-dev/vellum). This project's
Vellum recipe builds the app from its versioned source archive for each
architecture. The app ID and package name remain unchanged after the repository rename.

## 3E. Vellum — tablet terminal

1. If Vellum is not installed, set it up through reManager as above or follow
   the [official Vellum installation guide](https://github.com/vellum-dev/vellum-cli#installation).
2. Connect to the tablet using SSH or open reManager's terminal.
3. Update the package index and check the available calendar version:

   ```sh
   /home/root/.vellum/bin/vellum update
   /home/root/.vellum/bin/vellum search nextcloud-calendar
   ```

4. If the current version is available for your tablet, install or upgrade it:

   ```sh
   /home/root/.vellum/bin/vellum add nextcloud-calendar
   ```

   For an installed Vellum package, an ordinary Vellum upgrade also updates it
   once the catalogue provides the newer version. If the catalogue is older,
   use the manual download for 0.3.1 instead of expecting new features from it.
5. Allow dependencies, follow any XOVI reload prompt, then open the app.
6. If switching from a manual install to Vellum, close the app and keep a backup
   first; both methods use the same app/data directories. Do not mix installers
   while the app is running.

## 4. Open the app and connect Nextcloud

1. Close any other AppLoad app. In AppLoad, use **Reload** so it sees the new bundle.
2. Open **Nextcloud Calendar**. If the launcher still shows an old icon, close it,
   reload AppLoad again, and reopen it.
3. In Nextcloud on your computer/browser, open **Settings → Security → Devices &
   sessions** and create a dedicated app password for this tablet.
4. In the tablet app, open Settings. Enter the **HTTPS server base URL** (for
   example `https://cloud.example.com`), username and app password. Do not paste
   an individual calendar's CalDAV resource URL into the base-URL field.
5. Tap **Save & sync**. Choose the calendars/task lists to display.
6. In Settings, select your 12/24-hour time format and **Start of week**. The day
   can be Sunday, Monday, or any other weekday.
7. On Paper Pro/Move, select colors under **Calendar & task list colors**.
   On Move, enable **Paper Pro Move** to use the portrait weekly overview and
   landscape seven-day timeline. This setting is available only in the aarch64 build.
8. Tap **Sync** after saving edits to upload them. Offline edits remain on the
   tablet until a successful sync. A blank saved-password field retains it only
   for the same server and username; switching accounts requires resolving pending edits.

Times default to UTC. To change timezone, close the app and add a `timezone`
entry with an IANA name, such as `America/Phoenix`, in the tablet's private
`/home/root/.config/nextcloud-calendar/config.json`. Keep that file private with
permissions `600`, then reopen the app. Do not upload it to GitHub.

## 5. Enable Lasso to Task and the main-screen shortcut

These optional hooks use private reMarkable UI resources. **Capture targets
firmware 3.27.x; the launcher hook targets exactly 3.27.3.0.** Check your firmware
before enabling them. The core calendar app can be used without either hook.
Do not enable reTaskable's capture hook alongside this app's capture hook: both
patch the same selection handlers.

1. Confirm that XOVI's Qt resource rebuilder is working and close the calendar app.
2. Open the tablet terminal using SSH or reManager. Check firmware:

   ```sh
   cat /usr/share/remarkable/update.conf
   ```

3. On supported 3.27.x firmware, enable handwriting capture:

   ```sh
   cp /home/root/xovi/exthome/appload/nextcloud-calendar/xovi/nextcloudCalendarSend.qmd /home/root/xovi/exthome/qt-resource-rebuilder/
   ```

4. On exactly 3.27.3.0, optionally enable the Meeting Notes icon shortcut:

   ```sh
   cp /home/root/xovi/exthome/appload/nextcloud-calendar/xovi/nextcloudCalendarLauncher.qmd /home/root/xovi/exthome/qt-resource-rebuilder/
   ```

5. The hooks use native QML local-file access. Your XOVI/xochitl environment must
   allow `QML_XHR_ALLOW_FILE_READ=1` and `QML_XHR_ALLOW_FILE_WRITE=1`. If these are
   not already enabled, a writable systemd setup can add an app-specific override
   from the tablet terminal:

   ```sh
   mkdir -p /etc/systemd/system/xochitl.service.d
   cat > /etc/systemd/system/xochitl.service.d/nextcloud-calendar-xhr.conf <<'CONFIG'
   [Service]
   Environment=QML_XHR_ALLOW_FILE_READ=1
   Environment=QML_XHR_ALLOW_FILE_WRITE=1
   CONFIG
   systemctl daemon-reload
   ```

   If that filename already exists, back it up before replacing it. If the
   filesystem is read-only, stop and use your XOVI setup's supported environment
   configuration rather than remounting/replacing system files. This setting
   enables file access for native QML in xochitl; only use trusted hooks. It takes
   effect when xochitl/XOVI is restarted.
6. Reload XOVI using reManager's supported reload procedure or your existing
   XOVI startup/reload setup. This closes the tablet UI briefly; keep it awake.
7. For captures: lasso handwriting in a notebook, tap the added checkmark, review
   recognized text, and Create. Wi-Fi plus a signed-in reMarkable account are
   needed for online recognition; manual typing is offered when unavailable.
8. Return to the calendar. The **Pending Task Imports** button appears to the
   left of Tasks only when captures are waiting. Tap it and review each item.
   **Save** creates a queued task; **Discard** skips that import; both advance.
   **Cancel** stops and retains remaining imports. The editor shows progress
   such as **Lasso Task 1 of 3**. Finally tap Sync to upload saved tasks.
9. For the main-screen icon: in Settings, enable **Repurpose Meeting Notes Calendar
   Icon to open Nextcloud Calendar**. Disable it to restore the original action.
   This preference persists and applies without another reload after hook setup.

The original notebooks are not changed. Captures retain notebook/page metadata
in task Description. Discard dismisses the import; it does not securely erase the
spool file or delete a Nextcloud task.

## 6. Update, back up, restore, or uninstall

**Update:** download the matching architecture from the new release, verify its
checksum, close the app, and repeat the same installer. The installer checks CPU
architecture and backs up the old app/cache before replacement. Account settings
and pending edits remain in the private data directory.

**Backup:** keep the path printed by the installer under
`/home/root/.local/share/nextcloud-calendar/backups/`. Copy private backups to a
safe location if you need an off-tablet copy; they can contain calendar contents.

**Restore:** close the app, move the current
`/home/root/xovi/exthome/appload/nextcloud-calendar` directory aside, and copy the
backup's `bundle` directory back to that location as `nextcloud-calendar`.
Restore a saved state only if you intend to replace current cached/pending data.
Reload AppLoad. Restore hooks separately if you changed them.

**Remove optional hooks:** delete only `nextcloudCalendarSend.qmd` and/or
`nextcloudCalendarLauncher.qmd` from the resource-rebuilder directory and reload
XOVI. Leave other apps' QMD files and the hashtab alone.

**Uninstall a manual app:** close it and remove only its AppLoad bundle directory;
remove the two hooks if enabled, then reload XOVI/AppLoad. Leaving the private
configuration/data directories preserves your settings and captures for reinstall.
For a Vellum installation, remove the package using Vellum/reManager instead.
Do not delete the private directories unless you also intend to delete pending edits.

## Troubleshooting

- **No connection:** keep the tablet awake/unlocked, use a data cable and the
  actual address, and confirm Developer Mode where required. USB access is a
  useful first test before Wi-Fi SSH.
- **Wrong architecture:** use the tablet/build table; your computer CPU does not
  choose the app architecture.
- **SCP/SFTP error:** the installers retry legacy SCP (`scp -O`) if a standard
  transfer fails. If both fail, update the OpenSSH client or use reManager's file transfer.
- **App is open:** close it on the tablet, then rerun the installer.
- **Missing Start of week / new buttons:** check the installed `VERSION` file and
  catalogue version, reload AppLoad, and reopen the updated app.
- **Missing Move toggle:** it is available only in the aarch64 build.
- **Move stays in portrait:** the layout responds to the orientation reported by
  your firmware/AppLoad. Verify their rotation support; physical Move testing is
  still pending. Selecting Month or Day keeps that view when rotating.
- **Color missing:** RM1/RM2 intentionally remain monochrome. Unknown device
  identities also default to grayscale.
- **No import button:** it is hidden at zero. Confirm compatible hook setup and
  local-file permissions, finish a capture, then return to the app.
- **Sync conflict:** inspect Pending changes in Settings. Resolve the local change
  rather than expecting an unconditional server overwrite.
- **Unrecognized app password:** regenerate a dedicated Nextcloud app password;
  do not use or publish your primary account password.

For upstream help, use the linked XOVI, AppLoad, Vellum and reManager documentation
for their respective components. For this app, report the version, tablet model,
firmware and error message without attaching credentials or private cache files.
