// AgentCanvas — agentic generative UI (skeleton).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'agent/agent_controller.dart';

void main() => runApp(const ProviderScope(child: AgentCanvasApp()));

class AgentCanvasApp extends StatelessWidget {
  const AgentCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgentCanvas',
      theme: ThemeData.dark(useMaterial3: true),
      home: const AgentScreen(),
    );
  }
}

class AgentScreen extends ConsumerWidget {
  const AgentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(agentProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('AgentCanvas')),
      body: Center(
        child: Text('Agent phase: ${state.phase.name}\n\n'
            'TODO: composer → agent.run(goal); render state.uiSpec via RFW.'),
        // TODO (Phase 5): render the generated RFW UI from state.uiSpec.
      ),
    );
  }
}
