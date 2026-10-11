// Eole Windows 11 frame integration. No resident process or system settings.
using System;
using System.Diagnostics;
using System.Globalization;
using System.Runtime.InteropServices;
using System.Text;

internal static class EoleBorder
{
    private const int BorderColor = 34;
    private const string ColumnsClass = "{E7076D1C-A7BF-4f39-B771-BCBE88F2A2A8}";
    private delegate bool EnumProc(IntPtr hwnd, IntPtr param);
    [DllImport("user32.dll")] private static extern bool EnumWindows(EnumProc callback, IntPtr param);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] private static extern int GetClassName(IntPtr hwnd, StringBuilder name, int size);
    [DllImport("user32.dll")] private static extern uint GetWindowThreadProcessId(IntPtr hwnd, out uint pid);
    [DllImport("dwmapi.dll")] private static extern int DwmSetWindowAttribute(IntPtr hwnd, int attribute, ref uint value, int size);
    [DllImport("dwmapi.dll")] private static extern int DwmGetWindowAttribute(IntPtr hwnd, int attribute, out uint value, int size);
    [StructLayout(LayoutKind.Sequential)] private struct Rect { public int Left, Top, Right, Bottom; }
    [StructLayout(LayoutKind.Sequential)] private struct WindowPos { public IntPtr Hwnd, After; public int X, Y, Width, Height; public uint Flags; }
    [DllImport("user32.dll")] private static extern bool GetWindowRect(IntPtr hwnd, out Rect rect);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] private static extern IntPtr SendMessage(IntPtr hwnd, uint message, IntPtr wParam, ref WindowPos position);

    [STAThread] private static int Main(string[] args)
    {
        uint rgb;
        if (args.Length != 1 || !uint.TryParse(args[0], NumberStyles.HexNumber, CultureInfo.InvariantCulture, out rgb) || rgb > 0xFFFFFF) return 2;
        uint colorRef = ((rgb & 255) << 16) | (rgb & 0xFF00) | ((rgb >> 16) & 255);
        int result = 3;
        EnumWindows(delegate(IntPtr hwnd, IntPtr param) {
            var name = new StringBuilder(128);
            GetClassName(hwnd, name, name.Capacity);
            if (name.ToString() != ColumnsClass) return true;
            uint pid;
            GetWindowThreadProcessId(hwnd, out pid);
            try {
                using (var process = Process.GetProcessById((int)pid)) {
                    if (!string.Equals(process.ProcessName, "foobar2000", StringComparison.OrdinalIgnoreCase)) return true;
                    uint observed;
                    uint noBorder = 0xFFFFFFFE; // DWMWA_COLOR_NONE preserves rounded corners.
                    int hr = DwmSetWindowAttribute(hwnd, BorderColor, ref noBorder, 4);
                    // The retained resize strip above a custom caption uses this color.
                    DwmSetWindowAttribute(hwnd, 35, ref colorRef, 4);
                    // Columns UI resizes its children on WM_WINDOWPOSCHANGED,
                    // whereas OpenHacks only sends WM_SIZE after changing the frame.
                    // Notify it using existing geometry; do not move or resize the window.
                    Rect bounds;
                    if (GetWindowRect(hwnd, out bounds)) {
                        var position = new WindowPos { Hwnd = hwnd, X = bounds.Left, Y = bounds.Top,
                            Width = bounds.Right - bounds.Left, Height = bounds.Bottom - bounds.Top,
                            Flags = 0x16 };
                        SendMessage(hwnd, 0x47, IntPtr.Zero, ref position);
                    }
                    result = hr == 0 && DwmGetWindowAttribute(hwnd, BorderColor, out observed, 4) == 0 && observed == noBorder ? 0 : 4;
                }
            } catch { result = 5; }
            return true;
        }, IntPtr.Zero);
        return result;
    }
}
