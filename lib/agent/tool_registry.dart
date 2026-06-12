// Tools the agent can call. Keep each tool typed and validated.
typedef ToolFn = Future<Map<String, dynamic>> Function(Map<String, dynamic> args);

class Tool {
  final String name;
  final String description;

  /// JSON-schema-ish description used to build the decoding grammar.
  final Map<String, dynamic> argsSchema;
  final ToolFn run;

  const Tool({
    required this.name,
    required this.description,
    required this.argsSchema,
    required this.run,
  });
}

class ToolRegistry {
  final Map<String, Tool> _tools;
  ToolRegistry(this._tools);

  factory ToolRegistry.withDefaults() {
    // TODO (Phase 5): register real tools (search corpus, calculator, etc.).
    return ToolRegistry({});
  }

  Iterable<Tool> get tools => _tools.values;

  Future<Map<String, dynamic>> call(String name, Map<String, dynamic> args) async {
    final tool = _tools[name];
    if (tool == null) {
      throw ArgumentError('Unknown tool: $name');
    }
    // TODO (Phase 5): validate `args` against tool.argsSchema before running.
    return tool.run(args);
  }
}
