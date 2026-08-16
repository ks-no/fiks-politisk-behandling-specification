# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This repo is the specification for "Fiks Politisk Behandling" — a KS (Kommunesektorens organisasjon) messaging
protocol/standard for exchanging political case-handling data (utvalgssaker, vedtak, møteplaner, delegerte vedtak,
e-innsyn) between fagsystem (case systems), møtesystem (meeting systems), and arkivsystem (archive systems), routed
via Fiks-Protokoll. There is no application code here — this is a documentation/schema repository. Content is
primarily in Norwegian.

It has two parallel deliverables, both versioned per protocol version (currently `V1`):

- **`Schema/V1/`** — JSON Schema definitions for each message type.
- **`Dokumentasjon/V1/`** — Markdown documentation with PlantUML sequence/class diagrams illustrating how the
  messages are exchanged.

## Common commands

Generate PNGs from all PlantUML (`.puml`) source files (requires PlantUML and Graphviz installed locally):

```bash
./generate-png-from-puml.sh
```

This runs `plantuml` over `Dokumentasjon/**/*.puml` (PNG output) and `Schema/**/*.puml` (SVG output). Run it after
editing any `.puml` file so the checked-in `.png`/`.svg` files stay in sync with source — the rendered images are
committed alongside the `.puml` source in the same directory.

There is no build, lint, or test tooling in this repo.

## Schema architecture (`Schema/V1/`)

- Every schema file is named `no.ks.fiks.politisk.behandling.v1.<domain>.<action>.schema.json`, using JSON Schema
  draft 2020-12, with `$id` matching the filename exactly (required for `$ref` resolution between files).
- Message-specific schemas follow a `<domain>.<action>` naming pattern, e.g. `utvalgssak.send`, `moeteplan.hent`,
  `moeteplan.hent.resultat`, `delegertvedtak.send`, `einnsyn.vedtak.send`. Request/response pairs for a "hent" (get)
  operation are split into `<x>.hent.schema.json` and `<x>.hent.resultat.schema.json`.
- Shared value types live under the `felles` (common) domain and are referenced via `$ref` from other schemas
  instead of being duplicated: `felles.beskrivelse`, `felles.eksternnoekkel`, `felles.journalnummer`,
  `felles.moete`, `felles.saksnummer`, `felles.skjerming`. When adding a new field that represents one of these
  concepts, reference the existing `felles.*` schema rather than inlining an equivalent shape.
- Error responses are standardized shared schemas, reused across message types rather than defined per-message:
  `feilmelding.ikkefunnet` (not found), `feilmelding.serverfeil` (server error), `feilmelding.ugyldigforespoersel`
  (invalid request).
- `Schema/V1/meldingstyper/` holds an overview model (`meldingstyper.json`/`.puml`/`.svg`) of all message types and
  how they relate — regenerate the `.svg` from the `.puml` via the script above if it changes.

## Documentation architecture (`Dokumentasjon/V1/`)

- `Dokumentasjon/V1/modeller/` contains high-level process/flow diagrams (PNG) referenced from the top-level V1
  README, e.g. `Prosess.png`, `SendUtvalgssak.png`, `HentMøteplan.png`.
- `Dokumentasjon/V1/meldingsutveksling/` documents each message exchange in its own subfolder, one per message type
  (e.g. `utvalgssak-send/`, `moeteplan-hent/`, `einnsyn-vedtak-send/`, `utvalgssak-send-med-vedtakfrautvalg-send/`
  for the combined flow). Each subfolder follows the same internal layout:
  - `README.md` — embeds the diagrams for that message type.
  - `klassediagram/` — class diagram PNG (may be stale; these are being migrated to PlantUML for maintainability,
    per `Dokumentasjon/V1/meldingsutveksling/README.md`).
  - `sekvensdiagram/` — one `.puml`/`.png` pair per outcome: the happy path (e.g.
    `sekvensdiagram-utvalgssak-send.puml`) plus one per error case (`-serverfeil`, `-ugyldigforespoersel`, and for
    "hent" flows also `-ikkefunnet`).
- Sequence diagrams simplify away Fiks-Protokoll as an intermediary system — all messages actually flow through it,
  but diagrams show direct interaction between Fagsystem/Møtesystem/Arkivsystem for clarity.
- When adding a new message type, mirror an existing sibling folder's structure (README + klassediagram +
  sekvensdiagram with one diagram per outcome) and add a link to it from both
  `Dokumentasjon/V1/meldingsutveksling/README.md` and, if it introduces a new top-level flow, `Dokumentasjon/V1/README.md`.
