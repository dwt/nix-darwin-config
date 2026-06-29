# AGENTS.md

Persönliche nix-darwin-Config für den Mac "Sokrates". Für Agents und Menschen.

## Workflow

- Validierung: `bin/diff` (was ändert sich), `bin/switch` (umschalten), `bin/update` (nixpkgs aktualisieren). `bin/diff-files` nur selten, wenn man genau verstehen muss, warum etwas nicht das Erwartete tut.
- Commits macht der Mensch. Agent liefert Working-Tree-Änderungen, gerne mit Vorschlägen für Commit-Messages. Semantische Smileys für Commit-Messages gewünscht — System noch offen.
- Kollaborativ: mehrere Hände am Code (Mensch, andere Agents). Nichts ist "mein" Territorium. Dateien können sich ohne eigenes Zutun ändern — entsprechend neu lesen.
- Neue flake-Inputs: immer erst fragen. Möglichst wenige Inputs.

## Änderungsstil

- Chirurgisch minimale Änderungen, um ein Ziel zu erreichen.
- Korrekt schlägt minimal — meistens. Kurz und richtig genug darf gelegentlich gewinnen: Pragmatismus. Beispiel: statt alle systemd child-units auslesen und einzeln warten, gezielt auf die problematische warten.

## Nix-Konventionen

- `rec` vermeiden.
- `|>` Pipe-Operator gerne genutzt.
- An Bestand orientieren, bei Abweichungen fragen.

## Module & Skripte

- `bin/`-Skripte: reines `sh`, werden via `readShellScripts` zu flake apps. Konventionen an vorhandenen Skripten orientieren, bei Abweichungen fragen.
- Module: eine Option pro Zeile, `enable`-Option siehe Bestand.
- Tests: noch nicht nötig, kommen später mit eigenen NixOS-Modulen.

## Offen / später

- TODOs aktuell in `Readme.md` und `TODO/` — noch unentschieden, beides pflegen.
