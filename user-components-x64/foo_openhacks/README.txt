OpenHacks 0.1.5 x64: local Columns UI patch.

The original DLL's single UTF-16 Default UI window-class constant
{97E27FAA-C0B3-4b8e-A693-ED7881E99FC1} was replaced with Columns UI's
{E7076D1C-A7BF-4f39-B771-BCBE88F2A2A8}. All other bytes are unchanged.
This is not an official upstream build and targets Columns UI.

Original component: https://github.com/ttsping/foo_openhacks/releases/tag/v0.1.5
Reproducible patch: tools/patch-openhacks.py at the bundle root.
The MIT license is included.
