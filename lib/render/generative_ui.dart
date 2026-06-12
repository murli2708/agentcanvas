// Renders a model-generated UI spec safely with Remote Flutter Widgets (RFW).
//
// RFW is data-driven: we interpret a widget description, we never execute code.
import 'package:flutter/material.dart';

class GenerativeUiRenderer extends StatelessWidget {
  /// The constrained-JSON UI spec emitted by the agent.
  final Map<String, dynamic>? uiSpec;

  /// Called when the rendered UI fires an event (button tap, etc.).
  final void Function(String event, Map<String, dynamic> data)? onEvent;

  const GenerativeUiRenderer({super.key, required this.uiSpec, this.onEvent});

  @override
  Widget build(BuildContext context) {
    if (uiSpec == null) {
      return const SizedBox.shrink();
    }
    // TODO (Phase 5):
    //  - Maintain a Runtime + DynamicContent (rfw package).
    //  - Import a vetted widget library (core + material) into the Runtime.
    //  - Translate `uiSpec` into RFW remote widget data and render it.
    //  - Wire onEvent into the Runtime's event handler.
    return const Center(child: Text('TODO: render uiSpec via RFW Runtime'));
  }
}
