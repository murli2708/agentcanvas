# AgentCanvas — an on-device agent that builds its own UI

![Phase](https://img.shields.io/badge/Phase%205-The%20Imagination-7C3AED)
![Status](https://img.shields.io/badge/status-scaffold%20%C2%B7%20building%20in%20public-orange)
![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![SDUI](https://img.shields.io/badge/render-RFW%20%C2%B7%20server--driven%20UI-02569B)
![Decoding](https://img.shields.io/badge/output-grammar--constrained%20JSON-success)
![License](https://img.shields.io/badge/license-MIT-green)

> Phase 5 · The Imagination. *A local agent that plans, calls tools, and renders a fresh interface for each answer — no hardcoded screens.*

> **Status — honest:** scaffold + engineering plan. The reliability KPIs (100% valid JSON,
> ≥99% safe render) are the bar the design targets; measured over real generation runs as it's built.

## Problem

Most apps have fixed screens. AgentCanvas flips that: a small on-device model runs an
agent loop (plan → call tool → observe → respond) and **emits UI as data** that the app
renders at runtime. The interface is generated per task.

## Constraints

- Agent loop and model run on-device.
- UI is generated as data and rendered with **RFW (Remote Flutter Widgets)** — no eval, no
  arbitrary code execution.
- Tool calls and UI specs are produced with **grammar-constrained decoding** (GBNF /
  Outlines / XGrammar) so output is always valid JSON, never a hallucinated shape.

## Architecture

```
 user ─▶ agent loop ──▶ tool registry (search, calc, ...) ──▶ observation
            │                                                     │
            └──────────────▶ UI spec (constrained JSON) ──▶ RFW renderer ──▶ widgets
```

Finite state machine:
`idle → planning → callingTool → awaitingObservation → generatingUI → rendering → awaitingUserAction → done | error`

## Key design decisions & tradeoffs

- **Grammar-constrained decoding, not "please output JSON".** A GBNF/Outlines-style grammar masks logits so a small local model can *only* emit valid JSON — this is how you get a 100% parse rate from a 3B model instead of hope-and-retry.
- **UI as data, rendered via RFW — never `eval`.** The model emits a widget *spec*; a strict component/action allow-list renders it. No arbitrary code execution, ever. Model output is treated as untrusted input at the Dart boundary.
- **The agent is an explicit, cancellable state machine.** Max-iteration and timeout guards mean it can't loop forever, and every transition is observable/loggable — debuggability is a feature.
- **Validate observations before feeding them back.** Tool output is checked before it re-enters the model context — defensive against injection and garbage-in-garbage-out loops.

## Quickstart

```bash
flutter pub get
flutter run
```

## KPI table

| Metric                  | Target                                              |
| ----------------------- | --------------------------------------------------- |
| Output validity         | 100% schema-valid (grammar-constrained decoding)    |
| Rendering safety        | RFW only — no dynamic code execution                |
| Loop transparency       | Every state transition is observable/loggable       |
| Tool calls              | Structured, typed, validated before execution       |

## Failure modes & what I'd change next

- **Unconstrained generation** drifts into invalid JSON — always decode against a grammar.
- **Runaway loops**: cap iterations and require a terminal `respond` action.
- **Over-trusting tool output**: validate observations before feeding them back to the model.
- **UI injection**: RFW (data-driven) instead of building widgets from raw strings.

## Where this fits

Part of the **[Edge AI Architect roadmap](https://github.com/murli2708/edge-ai-roadmap)** — a 6-month, 6-project build-in-public series.

**Phase 5 of 6** · ← prev **[LocalMind](https://github.com/murli2708/localmind)** · next → **[EdgeMind Studio](https://github.com/murli2708/edgemind-studio)** (Phase 6 · the multimodal capstone)

## License

MIT © Murli — see [LICENSE](LICENSE).
