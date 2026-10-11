# Eole x64 — complete installation guide

This is an unofficial adaptation of [Ottodix/Eole-foobar-theme](https://github.com/Ottodix/Eole-foobar-theme) for **foobar2000 2.x x64**. The tested combination is **foobar2000 2.26.1 x64 on Windows 11**. Use the original theme for a 32-bit player.

## 1. Download the bundle

Download `Eole-foobar-theme-x64-<version>-full.zip` from [Releases](https://github.com/melkosofter/Eole-foobar-theme-x64/releases/latest) and extract it into a separate folder. The archive includes the theme, x64 layout, seven component folders, their JavaScript runtimes, 552 MilkDrop presets and the window fixes. The accompanying `SHA256SUMS.txt` contains the archive checksum.

Download the player separately from [foobar2000.org](https://www.foobar2000.org/download), choosing **64-bit / x64**. The player installer is not included. The Windows 11 frame helper requires .NET Framework 4.x.

## 2. Locate and back up your profile

Export your existing layout using Preferences → Display → Columns UI → Export configuration. Importing Eole replaces the current interface layout. Close foobar2000 through File → Exit, including instances running in the system tray.

| Installation | Usual profile location |
|---|---|
| Standard foobar2000 2.x | `%APPDATA%\foobar2000-v2` |
| Portable | `<player folder>\profile` |
| Microsoft Store or custom installation | Check the actual profile; its location may differ |

You can paste `%APPDATA%\foobar2000-v2` into File Explorer's address bar. To confirm the active profile, hold Shift while opening foobar2000's File menu and choose Browse Configuration Folder before closing the player. `C:\Program Files\foobar2000` contains the player, not your user theme.

Copy the entire profile to a separate backup folder. This preserves configuration, playlists and statistics. Throughout this guide, `<profile>` means your actual profile directory.

## 3. Install the files

Choose either manual installation or the supplied script.

### Manual installation

Copy the contents of these four folders from the extracted bundle into the corresponding profile folders, merging directories:

```text
<profile>\
  themes\eole\                    Theme, scripts, images, FCL and EoleBorder
  user-components-x64\            Seven components and their dependencies
  milkdrop2\                      data, presets, textures, docs
  wsh-data\eole-settings\         THEMEVERSION_1.2.3b24
```

Do not add an extra `Eole-foobar-theme-x64` directory inside the profile. The layout must end up at `<profile>\themes\eole\columnsUI_eole_x64.fcl`.

For an existing Eole installation, retain other files in `wsh-data\eole-settings`. Back up and remove old `THEMEVERSION_*` markers from the working folder, then install only `THEMEVERSION_1.2.3b24`. Multiple markers make the setting ambiguous.

Keep both JavaScript runtime dependencies next to their components:

```text
user-components-x64\foo_uie_jsplitter\mozjs-lur-153.dll
user-components-x64\foo_spider_monkey_panel\mozjs-102.dll
```

The empty `user-components-x64\foo_uie_eslyric\enable_script_control` file enables ESLyric control from theme scripts. It is included. Use the supplied OpenHacks DLL: its window-class constant is patched for Columns UI.

### Installation script

Open PowerShell in the extracted bundle folder and run:

```powershell
.\install.ps1 -ProfilePath "$env:APPDATA\foobar2000-v2"
```

For a portable installation, use its actual profile path:

```powershell
.\install.ps1 -ProfilePath 'D:\Players\foobar2000\profile'
```

To validate the bundle without writing files:

```powershell
.\install.ps1 -ProfilePath "$env:APPDATA\foobar2000-v2" -ValidateOnly
```

The script validates hashes, requires the player to be closed, copies the supplied folders and backs up replaced files under `<profile>\eole-install-backups\<timestamp>`. It does not import another user's library, playlists, statistics or configuration. Import the FCL manually in the next step.

If Windows blocks the downloaded `.ps1`, review the script and use Properties → Unblock on that file. Manual installation is also available; changing global security settings or execution policies is unnecessary.

## 4. Select Columns UI and import the layout

1. Start foobar2000 and select **Columns UI** in the initial interface selection dialog. For an existing installation, use File → Preferences → Display, select Columns UI and restart if prompted.
2. In Preferences → Components, confirm that all seven components below are loaded. Missing JSplitter usually means the wrong profile, a 32-bit player or a missing runtime DLL.
3. In Preferences → Display → Columns UI, choose **Import configuration / Import** and select `<profile>\themes\eole\columnsUI_eole_x64.fcl`. The tab containing Import may vary by Columns UI version.
4. Confirm the import and close Preferences with OK. Restart once if the interface does not update immediately.
5. Accept the suggested cover-cache and memory settings at first launch, then adjust them for your library size.

Do not import the original x86 FCL or overwrite your configuration with an old `foo_ui_columns.dll.cfg`. Both FCL files in this fork contain the x64 layout; prefer the filename ending in `_x64`.

| Component | Bundled version |
|---|---|
| Columns UI | 3.7.0 x64 |
| JSplitter | 4.3.4 x64 |
| Spider Monkey Panel | 1.7.26.5.1 x64 |
| OpenHacks | 0.1.5 x64 with Columns UI patch |
| ESLyric | 1.0.7.0 x64 |
| Playback Statistics | 3.1.10 x64 |
| MilkDrop 2 Visualisation | 0.9.16 x64 |

## 5. Configure music and MilkDrop

Add your music folders in Preferences → Media Library and wait for scanning. Library paths are personal settings and are not supplied by the bundle.

Play a track and open **Visualization**. This embeds native MilkDrop x64; Winamp and Shpeck configuration is unnecessary. MilkDrop's preset directory should be:

```text
%fb2k_profile_path%\milkdrop2\presets\
```

This profile-relative path is already saved in the x64 FCL. `milkdrop2\data` contains shaders for the native component; do not overwrite them with old Winamp shaders. Textures are in `milkdrop2\textures`. If visualization is blank, check playback, preset paths and MilkDrop's graphics-device settings.

## 6. Header, appearance, artwork and lyrics

- **Foobar** at the upper left opens the player menu. Drag the free header area between the menu and window controls to move the window.
- The light/dark switch changes the current section's appearance; double-click applies the theme globally, following Eole's behavior.
- Fullscreen, track-information, layout and sidebar controls are restored.
- Windows 11's outer border is hidden in both themes. The retained top strip follows Eole's background color, rounded corners remain, and panel sizing removes the bottom gap and right strip.
- The arrow above the image in **Now playing** opens Biography's **Look up…** menu. Middle-click locks updates on supported sources; a lock icon replaces the arrow. These icons are drawn as vectors and do not require FontAwesome.
- Double-clicking cover art opens it in the associated image viewer. If the track has no retrievable front cover, the displayed artwork is used instead. Missing images or viewer failures do not crash the panel.
- Configure lyric sources in Preferences → Tools → ESLyric. External services may return translations or stop responding; the theme cannot guarantee source availability.
- Biographies and artist photos also depend on external services. Use the image context menu → Refresh this image after changing artwork.

## 7. Updates and rollback

Close the player and back up the profile before updating theme files and components. Reimport the FCL when the layout changes or when restoring its defaults; importing may reset your panel customizations.

For a complete rollback, close the player and restore the profile backup. For file-only rollback, copy files from the installer's backup to the same relative paths. Newly created directories are not present in that backup and must be removed separately if uninstalling the theme. Restore your previous layout by importing your exported FCL. A full profile backup is the most reliable rollback method.

## 8. Troubleshooting and limitations

| Symptom | Check |
|---|---|
| Theme does not appear | Correct profile, Columns UI selected, x64 FCL imported |
| Unknown panel or missing panels | All x64 components and runtime DLLs present; restart |
| ESLyric ActiveXObject error | ESLyric x64 and `enable_script_control` marker; restart |
| Window cannot be dragged | Bundled OpenHacks DLL and Columns UI selected |
| Border or bottom gap returns | `themes\eole\tools\EoleBorder.exe` present, .NET Framework available, file unblocked |
| Prompt to import the old theme | Keep only `THEMEVERSION_1.2.3b24`; import this fork's FCL |
| No lyrics or biography | Playback, track tags, network and component sources |
| MilkDrop is blank | Playback, x64 component, presets, native shaders and graphics settings |

Shpeck was replaced with native MilkDrop x64; other old Winamp plugins are unsupported. The new layout approximates Eole's Panel Stack Splitter structure. UIHacks' automatic minimum/maximum window-size constraints and automatic shrinking in mini mode are not implemented; resize the window manually. The patched OpenHacks DLL targets Columns UI rather than Default UI. Some DWM appearance attributes are unavailable on older Windows versions.

## Sources and attribution

See the [overview](../README.md), [changelog](../CHANGELOG.md), [third-party notices](../THIRD-PARTY-NOTICES.md) and [upstream description](UPSTREAM-README.md). Upstream repository history and credits are preserved.

`tools/build-layout.py` reproduces the FCL; `tools/build-border.ps1` builds the frame helper; `tools/patch-openhacks.py` reproduces the patch from the original 0.1.5 DLL. `components-manifest.json` records versions, architecture and SHA-256 hashes for all nine DLLs across the seven components.
