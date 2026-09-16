# Indicators (translated)

Omarchy's indicators widget with its strings read from a translation
catalog instead of written into the QML. Drop-in replacement: install it and it
takes the built-in widget's place in the bar, keeping its position and settings.

```bash
omarchy plugin add https://github.com/sbelcl/omarchy-indicators-l10n.git --enable
```

Removing it puts the built-in back. Translated: the tooltips on the notification, night light, screen recording, stay-awake and dictation indicators.

Each indicator is loaded through its own `Loader`, so an id in the parent cannot reach it; every indicator that shows a tooltip carries its own catalog loader. Upstream loads them from `../indicators/`, a path that points outside a flat plugin folder, so this build loads them from `indicators/` — the same rewrite Omarchy's own `omarchy plugin clone` performs.

## Where the words come from

```
~/.config/omarchy/locales/<language>.json    e.g. sl.json, ru.json
```

A plain map of English string to translation, watched, so editing it changes
the widget without a restart. No catalog at all reads as English, which is the
source of every key.
[omarchy-language](https://github.com/sbelcl/omarchy-language) ships and
installs the catalogs; this plugin does not require it.

**Stays English:** The reminder indicator, which has no text of its own.

## Why this is a fork

Every string is a QML literal, and there is no hook for one plugin to reach
another's. `manifest.json` declares `omarchy.clonedFrom: "omarchy.indicators"`, which
the shell uses to route the built-in's IPC here, hand this its slot in the bar,
and restore the built-in when this is removed.

If [omacom/omarchy#7284](https://github.com/omacom/omarchy/issues/7284) lands a
translation layer upstream, delete this plugin rather than maintain it.

## Keeping it current

A copy of Omarchy **4.0.4**, so upstream fixes do not reach it on their own.
`upstream.diff` records every line this build changes. To re-sync after a
release:

```bash
cp /usr/share/omarchy/shell/plugins/bar/widgets/Indicators.qml .
cp /usr/share/omarchy/shell/plugins/bar/indicators/*.qml indicators/
patch -p0 < upstream.diff
omarchy plugin validate .
```

## License

MIT, as upstream. Derived from [Omarchy](https://github.com/omacom/omarchy).
