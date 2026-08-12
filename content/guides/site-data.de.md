+++
title = 'Konfiguration, Daten und Sprachen'
description = 'Einstellungen, gemeinsame Daten und UI-Texte gehören nicht in Seiteninhalte.'
weight = 40
tags = ['data', 'configuration']

[[params.references]]
title = 'Sprachen konfigurieren'
url = 'https://gohugo.io/configuration/languages/'

[[params.references]]
title = 'Mehrsprachige Websites'
url = 'https://gohugo.io/content-management/multilingual/'

[[params.references]]
title = 'Alle Übersetzungen'
url = 'https://gohugo.io/methods/page/alltranslations/'
+++

Hugo baut für jede konfigurierte Sprache eine eigene Website. Diese Seite ist
die deutsche Übersetzung von `content/guides/site-data.md`.

## Sprachen konfigurieren

`hugo.toml` definiert Label, Locale und Gewicht. Das Theme zeigt das Sprachmenü
nur, wenn `hugo.IsMultilingual` wahr ist.

## Inhalte übersetzen

Dateien mit demselben Namen und einem Sprachsuffix sind verbunden:

```text
content/guides/site-data.md
content/guides/site-data.de.md
```

Das Sprachmenü verwendet `.AllTranslations`. Fehlt eine Übersetzung, verlinkt
es auf die Startseite der Zielsprache.
