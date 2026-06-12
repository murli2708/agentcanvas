# AgentCanvas — an on-device agent that builds its own UI

> Phase 5 starter. *A local agent that plans, calls tools, and renders a fresh interface for each answer — no hardcoded screens.*

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

## License

MIT.
