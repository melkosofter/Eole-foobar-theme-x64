# Changelog

## 1.0.1 — 2026-10-11

- Publish installation and configuration documentation in English only, including the complete guide and bundled OpenHacks notes.
- Fix double-click and context-menu cover opening when the displayed artwork comes from the cache and the track has no retrievable front cover. Use the displayed image as a fallback and handle missing art, failed saves and unavailable image viewers without crashing the panel.

## 1.0.0 — 2026-10-11

- Adapt Eole 1.2.3b24 to foobar2000 2.x x64 with JSplitter and an 18-panel layout (16 Eole script panels, MilkDrop and ESLyric).
- Replace Panel Stack Splitter refresh operations with JSplitter notifications; cache the layout signature to avoid unnecessary panel relayout.
- Replace UIHacks calls with an OpenHacks adapter and replace Shpeck with native MilkDrop x64. Supply 552 upstream presets, textures and native shader data.
- Restore the Foobar menu label and title-bar controls; fix button width arithmetic that treated a padding array as a number.
- Adapt OpenHacks 0.1.5's single UTF-16 main-window class constant from Default UI to Columns UI. No other binary bytes change; this is a local patch, not an official upstream build.
- Supply `EoleBorder.cs` and its x64 executable. Set the Windows 11 border to `DWMWA_COLOR_NONE`, color the retained top strip from Eole, and notify Columns UI of current geometry through `WM_WINDOWPOSCHANGED` after OpenHacks applies its frame. This prevents empty bottom/right areas without moving the window.
- Draw Biography's lookup chevron and lock as vectors, eliminating missing FontAwesome glyph boxes.
- Add complete installation documentation, a backup-aware installer, component hashes, build tools and upstream license/credit notices.
