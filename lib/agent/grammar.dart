// Grammar-constrained decoding helpers.
//
// The agent's output must ALWAYS be valid JSON of a known shape. We achieve that
// by constraining the model's decoding to a grammar (GBNF for llama.cpp, or
// Outlines / XGrammar). This file builds those grammars from our schemas.

/// A GBNF grammar string that forces the model to emit one of:
///   {"action": "call_tool", "tool": "...", "args": {...}}
///   {"action": "respond", "ui": {...}}
///
/// TODO (Phase 5): generate this from the ToolRegistry schemas + the UI spec schema
/// so new tools automatically become part of the grammar.
String buildAgentGrammar(Iterable<String> toolNames) {
  throw UnimplementedError(
    'TODO: emit GBNF/JSON-schema grammar constraining the agent action set',
  );
}
