# Flutter Clean Architecture Rules

> A portable instruction set for Claude Code and AI assistants to enforce clean architecture, dumb UI, and consistent patterns across all Flutter projects.

## What This Is

A set of rule files that teach Claude Code (or any AI assistant) how to write, refactor, and review Flutter code following a strict clean architecture style:

- **Dumb UI** — screens display state and forward actions, nothing else.
- **Cubit-owned behavior** — loading, filtering, error handling, UI-ready data.
- **Data-source-owned persistence** — Firebase, Supabase, SharedPreferences, validation, normalization.
- **Thin repos** — delegate to data sources, expose clean methods.
- **Small files** — screens 30-70 lines, widgets 80-120 lines, hard max 150.
- **Package-first** — use `corereusablepackage` before building custom widgets/services.

## Files

| File | Purpose | When to Use |
|------|---------|-------------|
| `CLAUDE.md` | Primary instruction file | Drop into project root or Claude Code project instructions |
| `CONSTRAINTS.md` | Detailed architecture constraints and layer ownership rules | Attach alongside CLAUDE.md for comprehensive coverage |
| `SKILL.md` | Compact skill-format instructions | Use as a Claude skill instruction file |
| `docs/CORE_KIT_USAGE.md` | Setup guide for `corereusablepackage` | Reference when starting a new project |
| `docs/REFACTOR_CHECKLIST.md` | Pre-delivery quality checklist | Run before submitting any code changes |
| `templates/FEATURE_TEMPLATE.md` | New feature folder and code template | Reference when adding a new feature |

## Quick Start

**Option 1 — Project root (recommended):**
Copy `CLAUDE.md` to the root of your Flutter project. Claude Code reads it automatically.

**Option 2 — Full coverage:**
Paste `CLAUDE.md` + `CONSTRAINTS.md` into Claude project instructions.

**Option 3 — Skill mode:**
Use `SKILL.md` as a skill instruction file if your workspace supports custom skills.

## Prerequisites

Add `corereusablepackage` to your project:

```yaml
# pubspec.yaml
dependencies:
  corereusablepackage:
    path: ../corereusablepackage
```

See `docs/CORE_KIT_USAGE.md` for full setup instructions.
