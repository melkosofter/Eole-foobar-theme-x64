// Eole layout for JSplitter x64. Original panel scripts: Ottodix and contributors.
window.DefinePanel('Eole x64 layout', {author: 'Eole contributors / local adaptation'});
var settingRoot = fb.ProfilePath + 'wsh-data\\eole-settings\\';
function setting(prefix, fallback) {
    var files = utils.Glob(settingRoot + prefix + '_*');
    if (!files.length) return fallback;
    var value = Number(files[0].substring(files[0].lastIndexOf('_') + 1));
    return Number.isFinite(value) ? value : fallback;
}
var previousLayout = "";
function arrange() {
    var w = window.Width, h = window.Height;
    if (w < 1 || h < 1) return;
    var layoutKey = w + ":" + h + ":" + utils.Glob(settingRoot + "*").join("|");
    if (layoutKey === previousLayout) return;
    previousLayout = layoutKey;
    var mode = setting('MAINPANEL', 0), mini = setting('LAYOUT', 0);
    var compact = setting('COMPACTTITLEBAR', 0);
    var top = compact === 0 || mini ? 64 : compact === 1 ? 36 : 50;
    var bottom = mini ? (setting('SHOWTRACKINFOSMALL', 0) ? 51 : 43) :
        !setting('MINICONTROLBAR', 1) ? 72 : setting('SHOWTRACKINFOBIG', 1) ? 54 : 47;
    var bodyHeight = Math.max(1, h - top - bottom);
    var suffix = ['LIB', 'PLAYLIST', 'BIO', 'VISU'][mode];
    var right = mini ? w : setting('NOWPLAYING' + suffix, 1) ?
        Math.min(setting('RIGHTPLAYLISTWIDTH', 210), Math.floor(w * 0.4)) : 0;
    var mainWidth = w - right;
    for (var i = 0; i < window.GetPanelCount(); ++i) window.GetPanelByIndex(i).Show(false);
    function panel(name, x, y, width, height) {
        if (width <= 0 || height <= 0) return;
        var p = window.GetPanel(name);
        if (!p) return;
        p.Move(Math.round(x), Math.round(y), Math.max(1, Math.round(width)), Math.max(1, Math.round(height)));
        p.Show(true);
    }
    panel('TitleBar', 0, 0, w, top);
    var cover = mini ? setting('COVERPANELMINI', 1) : setting('COVERPANELBIG', 1);
    var coverWidth = cover ? bottom : 0;
    panel('CoverPanel', 0, h - bottom, coverWidth, bottom);
    panel('Controls', coverWidth, h - bottom, w - coverWidth, bottom);
    if (!mini) {
        if (mode === 0) {
            var left = setting('LIBRARYFILTER', 1) ? Math.min(setting('LIBRARYFILTERWIDTH', 210), mainWidth * 0.4) : 0;
            panel(setting('LIBRARYTREE', 0) ? 'LibraryTree' : 'LibraryFilter', 0, top, left, bodyHeight);
            panel('GraphicBrowser', left, top, mainWidth - left, bodyHeight);
        } else if (mode === 1) {
            var manager = Math.min(setting('PLAYLISTPANELWIDTH', 180), mainWidth * 0.35);
            panel('SmoothPlaylistManager', 0, top, manager, bodyHeight);
            var area = mainWidth - manager, filterMode = setting('FILTERSPANEL', 1);
            var filterHeight = bodyHeight * [0, .2, .3, .4, .6, 1][filterMode];
            var enabled = [1, 2, 3].filter(function(n) { return setting('FILTER' + n, 1); });
            if (enabled.length && filterHeight) enabled.forEach(function(n, i) {
                panel('PlaylistFilter' + n, manager + area * i / enabled.length, top,
                    area / enabled.length, filterHeight);
            });
            var headerHeight = filterMode === 5 ? 0 : 32;
            panel('PlaylistHeader', manager, top + filterHeight, area, headerHeight);
            panel('BottomPlaylist', manager, top + filterHeight + headerHeight, area,
                bodyHeight - filterHeight - headerHeight);
        } else if (mode === 2) {
            var lyrics = setting('LYRICS', 1);
            var lyricsWidth = lyrics === 11 ? mainWidth : mainWidth * lyrics / 10;
            panel('Biography', 0, top, mainWidth - lyricsWidth, bodyHeight);
            panel('LyricsTitle', mainWidth - lyricsWidth, top, lyricsWidth, 28);
            panel('Lyrics', mainWidth - lyricsWidth, top + 28, lyricsWidth, bodyHeight - 28);
        } else panel('MilkDrop', 0, top, mainWidth, bodyHeight);
    }
    if (right) {
        var info = mini ? 0 : setting('TRACKINFOS' + suffix, mode >= 2 ? 1 : 0);
        var infoHeight = info ? Math.min(right + 41, bodyHeight / 2) : 0;
        var rx = mini ? 0 : mainWidth;
        panel('TrackInfo', rx, info === 2 ? top + bodyHeight - infoHeight : top, right, infoHeight);
        panel('NowPlayingPlaylist', rx, info === 1 ? top + infoHeight : top, right, bodyHeight - infoHeight);
    }
    window.Repaint();
}
function on_size() { arrange(); }
function on_notify_data(name, info) { window.SetTimeout(arrange, 0); }
function on_paint(gr) { gr.FillSolidRect(0, 0, window.Width, window.Height, 0xff1e1e1e); }
window.SetTimeout(arrange, 100);
