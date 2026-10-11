# Attribution, binary provenance and source links

This fork adapts Eole; it does not claim authorship of the original theme, its assets, or any third-party component. Existing file-level copyright/license notices are preserved. No single license is asserted over the entire mixed distribution.

## Theme and assets

- [Ottodix/Eole-foobar-theme](https://github.com/Ottodix/Eole-foobar-theme), upstream base commit `bb4e18c6bbc4e63945ea0d795e1a6b61958d2fbe`. Original credits: [UPSTREAM-README](docs/UPSTREAM-README.md).
- Br3tt/Falstaff: original panel code; WilB: Biography and Library Tree; TheQwertiest, marc2003 and T.P. Wang: script-host lineage.
- Biography's license remains in `themes/eole/js/biography/LICENSE.txt`.
- MilkDrop presets, textures and documentation are copied from upstream Eole's MilkDrop assets. Preset names retain their author credits. Native shaders come from MilkDrop 0.9.16, not the old Winamp shader files.

## Components

| Component | Binary source | Source / notices |
|---|---|---|
| Columns UI 3.7.0 | [v3.7.0 release](https://github.com/reupen/columns_ui/releases/tag/v3.7.0), unchanged x64 DLL | [Source v3.7.0](https://github.com/reupen/columns_ui/tree/v3.7.0), LGPL; license and copyright texts in `licenses/Columns-UI-*` |
| JSplitter 4.3.4 | [v4.3.4 release](https://github.com/dima-lur/jsplitter/releases/tag/v4.3.4), unchanged x64 DLLs | [Upstream repository](https://github.com/dima-lur/jsplitter); bundled documentation/samples preserved; SpiderMonkey-based host |
| Spider Monkey Panel x64 1.7.26.5.1 | [1.7.26.5.1 release](https://github.com/dima-lur/spider-monkey-panel-x64/releases/tag/1.7.26.5.1), unchanged DLLs | [Upstream](https://github.com/dima-lur/spider-monkey-panel-x64); original host MIT license and dependency notices in `user-components-x64/foo_spider_monkey_panel` |
| OpenHacks 0.1.5 | [v0.1.5 release](https://github.com/ttsping/foo_openhacks/releases/tag/v0.1.5), **one local UTF-16 class-name patch** | [Source v0.1.5](https://github.com/ttsping/foo_openhacks/tree/v0.1.5), MIT text in `licenses/OpenHacks-MIT.txt`; patch tool in `tools/patch-openhacks.py` |
| ESLyric 1.0.7.0 | [ESLyric releases](https://github.com/ESLyric/release/releases), unchanged x64 DLL | [Project/feedback](https://github.com/ESLyric/feedback); component remains under its author's terms |
| Playback Statistics 3.1.10 | [Official component page](https://www.foobar2000.org/components/view/foo_playcount), unchanged x64 DLL | Peter Pawlowski / foobar2000; component remains under its author's terms |
| MilkDrop 0.9.16 | [Official component page](https://www.foobar2000.org/components/view/foo_vis_milk2), unchanged x64 DLL | [Source](https://github.com/jecassis/foo_vis_milk2), MPL 2.0 and third-party notices in `licenses/MilkDrop-*` |

Source links and corresponding upstream release identifiers are provided so component code and notices can be obtained separately. Exact bundled binary SHA-256 hashes are recorded in `components-manifest.json`. Components are not relicensed by this fork. foobar2000 itself is not redistributed in the release ZIP.

## Local Windows 11 helper and build utilities

`themes/eole/tools/EoleBorder.cs` is supplied with its generated `EoleBorder.exe`; it operates only on foobar2000 Columns UI windows. Build with `tools/build-border.ps1`. The helper source and newly written standalone installation/build/patch utilities are licensed under MIT, see `licenses/LOCAL-TOOLS-MIT.txt`. This grant applies only to those new standalone files; Eole modifications and third-party code retain their applicable notices.
