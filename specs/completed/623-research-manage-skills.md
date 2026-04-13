# Brainstorm: manage-skills Adaptionen für npx-ai-setup

> **Source**: https://github.com/Getty/manage-skills
> **Erstellt**: 2026-04-04
> **Status**: completed
> **Autor**: Torsten Raudssus (Getty)
> **Lizenz**: MIT

## Was ist manage-skills?

CLI-Tool (644 Zeilen Bash) für hardlink-basiertes Skill-Sharing über Projekte hinweg.
Config in `~/.manage-skills/` mit `sources` (Skill-Quellverzeichnisse) und `targets` (Installationsziele).
Prüft über Inodes, ob Skills echt gelinkt oder gecopyt sind.

## Bestandsvergleich

| manage-skills Feature | Unser Äquivalent | Status |
|----------------------|-----------------|--------|
| Skill installation | `lib/plugins.sh` + Template-Copy | ✅ Covered (andere Methode) |
| Post-install skill management | — | ❌ Missing |
| Interactive skill selection | — | ❌ Missing |
| Skill status tracking ([*]/[~]/[ ]) | `/doctor` (partiell) | ⚠️ Partial |
| `sync` nach git clone | `/update` (partiell) | ⚠️ Partial |
| fzf-based numbered fallback | — | ❌ Missing |
| Multi-source skill directories | — | ❌ Missing (unnötig für uns) |
| Hardlink integrity check | — | ❌ Missing (andere Architektur) |

---

## Kandidaten für Adaption

### 1. Interactive Skill Selection während Setup (NEU)

**Was es tut**: Beim `manage-skills`-Aufruf ohne Argumente öffnet sich fzf mit allen verfügbaren Skills. Bereits installierte sind vorselektiert. TAB zum togglen, ENTER zum bestätigen. Fallback auf nummerierten Menü wenn fzf nicht installiert.

**Unser Gap**: Wir installieren ALLE 49 Skill-Templates ohne Auswahl. User bekommen Skills sie nie brauchen.

**Spezifische Technik aus manage-skills**:
```bash
# fzf mit Preselection bereits installierter Skills
selected=$(echo -n "$fzf_input" | fzf --multi --ansi \
  --header="Toggle skills with TAB, confirm with ENTER" \
  --prompt="Skills for $(basename "$PWD") > " \
  --preview="head -20 {+1}/$target_file 2>/dev/null || echo 'Not yet linked'" \
  --preview-window=right:50%:wrap)
```

**Numbered fallback** (wenn kein fzf):
```bash
printf "  %2d) %s %-30s\n" "$num" "${states[$i]}" "${names[$i]}"
read -rp "> " input
# Toggle: [*] → [ ] → [*]
```

**Effort**: Mittel — neuer Prompt-Flow in `bin/ai-setup.sh`
**Value**: Hoch — reduziert Bloat, gibt User Kontrolle
**Token-Impact**: -30% Context-Bloat in Projekten mit vielen unbenutzten Skills

---

### 2. manage-skills als Optionales Plugin installieren (NEU)

**Was es tut**: manage-skills als zusätzliches Tool für User, die Skills über mehrere Projekte teilen wollen. Nach Setup: `manage-skills sources add ~/.npx-ai-setup/templates/skills/` würde unsere Templates als Quelle registrieren.

**Unser Gap**: Nach dem initialen Setup gibt es keine CLI für post-install Skill-Verwaltung.

**Integration**: In `lib/plugins.sh` als optionaler Block:
```bash
install_manage_skills() {
  if ask_yes_no "manage-skills installieren (Skill-Sharing über Projekte)?"; then
    curl -fsSL https://raw.githubusercontent.com/Getty/manage-skills/main/install.sh | bash
    # Register our templates as a source
    manage-skills sources add "$TEMPLATES_DIR/skills"
  fi
}
```

**Effort**: Niedrig — ~20 Zeilen in plugins.sh
**Value**: Mittel — nützlich für Power-User mit vielen Projekten
**Caveat**: Externe Abhängigkeit, curl-pipe-bash Sicherheitsrisiko ohne Hash-Prüfung

---

### 3. Skill-Drift-Erkennung im Doctor (PARTIAL COVERAGE)

**Was es tut**: manage-skills `check` erkennt Skills die als `[~]` (lokale Kopie, kein Hardlink) existieren statt `[*]` (hardlinked). Analog: Wir könnten im `/doctor` prüfen ob installierte Skills noch mit unseren Templates übereinstimmen.

**Ihr exakter Pattern**:
```bash
# Inode-Vergleich cross-platform
inode_p=$(stat -c %i "$project_file" 2>/dev/null || stat -f %i "$project_file" 2>/dev/null)
```

**Unser Gap**: `/doctor` prüft nicht ob installierte Skills veraltet sind vs. aktueller Template-Version.

**Effort**: Niedrig — neue Prüfroutine in `doctor.sh`
**Value**: Niedrig-Mittel — relevant nur wenn User Skills manuell modifiziert haben

---

## Einzelne Patterns/Techniken zum Adaptieren

### A. Cross-platform `stat` Inode-Check
```bash
stat -c %i "$file" 2>/dev/null || stat -f %i "$file" 2>/dev/null
```
Einfaches Pattern für macOS + Linux Kompatibilität. Wir haben ähnliche Cross-Platform-Guards in setup.sh — dieses Pattern dort ergänzen wo stat-calls vorkommen.

### B. `expand_path()` mit Tilde-Expansion
```bash
expand_path() {
  local p="$1"
  p="${p/#\~/$HOME}"
  echo "$p"
}
```
Sauberere Alternative zu `eval echo` für `~`-Expansion. In unseren Bash-Scripts an mehreren Stellen relevant.

### C. Numbered Menu mit State-Toggle (kein fzf)
Ihr Fallback-Menu-Pattern ist das sauberste bash-only Interactive-Menu das ich in diesem Kontext gesehen habe. Komplett in bash, keine deps.

### D. Skill-Status Icons als UX-Pattern
`[*]` hardlinked / `[~]` copy / `[ ]` available / `●` original
Könnten wir für unser `/doctor` output übernehmen: `[✓]` aktuell / `[~]` modifiziert / `[ ]` nicht installiert

---

## Architektur-Analyse

### Unser Ansatz vs. manage-skills

| | npx-ai-setup | manage-skills |
|--|-------------|--------------|
| Model | npx one-liner → Copy-Install | CLI-Tool → Hardlink |
| Team | Alle erhalten gleiche Version | Team bekommt Git-Kopie, Dev bekommt Hardlink |
| Sync nach Clone | `/update` skill | `manage-skills sync` |
| Philosophie | Zero-dep für End-User | Tool für Power-User |

**Kritische Erkenntnis**: Hardlinks funktionieren nicht über Filesystem-Grenzen und lösen sich bei `git clone` auf. manage-skills `sync` ist der Recovery-Schritt danach. Für Team-Setups ist unser Copy-Ansatz robuster — ein Vorteil, kein Nachteil.

---

## Gesamtranking nach Aufwand/Nutzen

| Kandidat | Value ★ | Aufwand | Empfehlung |
|---------|---------|---------|-----------|
| Interactive Skill Selection | ★★★★★ | Mittel | **GO** |
| manage-skills Plugin | ★★★ | Niedrig | GO (mit Sicherheitscheck) |
| Skill-Drift Detection im Doctor | ★★ | Niedrig | LATER |
| Cross-platform stat pattern | ★★ | Minimal | Quick Win (inline) |
| Numbered fallback menu | ★★★★ | Niedrig | GO (Teil von #1) |

---

## Philosophie-Check

**CONCEPT.md**: Nicht vorhanden. Check gegen Projektgeist:

- **Interactive Skill Selection**: Fügt Safety hinzu (User wählt bewusst). GO
- **manage-skills Plugin**: Optionale externe Abhängigkeit — curl-pipe-bash ohne Verifikation ist Risiko. PIVOT: besser als lokalen Installer (`install_from_github_release`-Pattern) integrieren.
- **Hardlink-Infrastruktur komplett übernehmen**: Widerspricht unserem Copy-Modell. SKIP

---

## Nicht adaptierbar

- **Multi-source config** (`~/.manage-skills/sources`): Wir haben eine einzige Quelle (unsere Templates), kein Mehrsource-Bedarf.
- **Hardlink-Architektur**: Unser Copy-Modell ist für Team-Setups robuster.
- **`manage-skills init`**: Passt nicht in unsere npx-basierte Einrichtung.
