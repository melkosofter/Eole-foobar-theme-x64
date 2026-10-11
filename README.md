# Eole foobar2000 theme — x64 edition

An unofficial **64-bit adaptation** of [Ottodix/Eole-foobar-theme](https://github.com/Ottodix/Eole-foobar-theme), preserving upstream history and credits. For **foobar2000 2.x x64**, using Columns UI and JSplitter. Tested with foobar2000 **2.26.1 x64 on Windows 11**.

**[Download the complete x64 bundle](https://github.com/melkosofter/Eole-foobar-theme-x64/releases/latest)** · **[Complete installation guide](docs/INSTALLATION.md)**

The bundle contains the theme, x64 layout, all seven component folders, MilkDrop shaders/textures and **552 presets**, and the Windows 11 frame helper. The player itself is downloaded separately from [foobar2000.org](https://www.foobar2000.org/download). This is a theme distribution, not a copy of a user's profile.

## What changed

| Original implementation | x64 edition |
|---|---|
| Panel Stack Splitter | JSplitter with `Eole_x64_layout.js` |
| UIHacks | OpenHacks x64 adapter; local Columns UI window-class patch |
| Shpeck / Winamp visualization plugins | Native MilkDrop x64 panel embedded in Visualization |
| Original ESLyric integration | ESLyric x64 and script-control marker |
| Legacy title bar | Restored Foobar label, header buttons and mouse drag area |
| Windows 11 window edges | Rounded corners, hidden outer border, theme-colored top strip; corrected child-panel sizing |
| Biography lookup icon | Vector chevron and lock; no FontAwesome installation needed for these icons |

**Shpeck was replaced, not ported. Old Winamp plugins are not loaded.**

## Components included

| Component | Version | Upstream |
|---|---|---|
| Columns UI | 3.7.0 | [reupen/columns_ui](https://github.com/reupen/columns_ui) |
| JSplitter | 4.3.4 | [dima-lur/jsplitter](https://github.com/dima-lur/jsplitter) |
| Spider Monkey Panel x64 | 1.7.26.5.1 | [dima-lur/spider-monkey-panel-x64](https://github.com/dima-lur/spider-monkey-panel-x64) |
| OpenHacks | 0.1.5, locally patched for Columns UI | [ttsping/foo_openhacks](https://github.com/ttsping/foo_openhacks) |
| ESLyric | 1.0.7.0 | [ESLyric/release](https://github.com/ESLyric/release/releases) |
| Playback Statistics | 3.1.10 | [Component page](https://www.foobar2000.org/components/view/foo_playcount) |
| MilkDrop 2 Visualisation | 0.9.16 | [jecassis/foo_vis_milk2](https://github.com/jecassis/foo_vis_milk2) |

`components-manifest.json` records exact binary hashes and architecture. Both JavaScript engine DLLs are included next to their components.

## Installation

1. Install **foobar2000 x64**. Close every running foobar2000 instance and back up your profile.
2. Extract the complete release ZIP. Your profile is normally `%APPDATA%\foobar2000-v2`; a portable installation normally uses `<foobar directory>\profile`. **Do not copy the theme into Program Files.**
3. Copy `themes`, `user-components-x64`, `milkdrop2` and the supplied `wsh-data` into that profile, merging folders. For an existing Eole installation, retain other settings but replace any `THEMEVERSION_*` marker with the supplied `THEMEVERSION_1.2.3b24`.
4. Start foobar2000, select **Columns UI** in Preferences → Display (restart if prompted).
5. Preferences → Display → Columns UI → Import configuration: import `<profile>\themes\eole\columnsUI_eole_x64.fcl`.
6. Add music folders in Preferences → Media Library. Play a track and open **Visualization** to use native MilkDrop. Its preset directory should be `%fb2k_profile_path%\milkdrop2\presets\`.

Alternatively run `install.ps1 -ProfilePath '<your profile>'` in PowerShell for step 3. It validates hashes, copies only the supplied folders and saves backups before replacements. It does **not** import Columns UI settings or start the player. See [the full guide](docs/INSTALLATION.md) for commands, troubleshooting and rollback.

## Limits and maintenance

- The new layout approximates the original Panel Stack Splitter layout. Mini mode works as a layout, but automatic shrinking/minimum-size constraints from UIHacks are not implemented.
- The patched OpenHacks binary targets **Columns UI**, not Default UI. Replacing it with the upstream binary removes the custom caption drag integration.
- Windows 11 frame integration needs .NET Framework 4.x. `EoleBorder.exe` runs briefly at startup/theme changes and exits; no resident service or global system setting is added. On older Windows, the DWM color attributes may be unavailable.
- Lyrics, artist images and biographies depend on external services; availability varies. ESLyric sources can be configured through its preferences.
- Do not reinstall old x86 components, UIHacks, Panel Stack Splitter or Shpeck alongside this bundle.

## Build and attribution

The frame helper source is included in `themes/eole/tools/EoleBorder.cs`; rebuild with `tools/build-border.ps1`. `tools/build-layout.py` reproduces the x64 FCL. `tools/patch-openhacks.py` reproduces the narrowly scoped binary patch with a SHA-256 guard. Changes are listed in [CHANGELOG.md](CHANGELOG.md).

Original theme and panels: **Ottodix and Eole contributors**, **Br3tt/Falstaff**, **WilB** (Library Tree and Biography). Original JavaScript panel lineage: **TheQwertiest/Yuri Shutenko**, **marc2003**, **T.P. Wang**. x64 JS hosts: **dima-lur**. Window integration: **ttsping/OpenHacks**. Native visualization: **Jimmy Cassis and MilkDrop/Winamp contributors**. Component authors retain their copyrights and licenses; see [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md), bundled license texts and [the upstream README](docs/UPSTREAM-README.md).
