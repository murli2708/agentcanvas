// The agent loop as an explicit finite state machine.
//
// idle → planning → callingTool → awaitingObservation → generatingUI
//      → rendering → awaitingUserAction → done | error
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tool_registry.dart';

enum AgentPhase {
  idle,
  planning,
  callingTool,
  awaitingObservation,
  generatingUI,
  rendering,
  awaitingUserAction,
  done,
  error,
}

class AgentState {
  final AgentPhase phase;

  /// The constrained-JSON UI spec the model emitted, for RFW to render.
  final Map<String, dynamic>? uiSpec;
  final String? error;
  final int iterations;

  const AgentState({
    this.phase = AgentPhase.idle,
    this.uiSpec,
    this.error,
    this.iterations = 0,
  });

  AgentState copyWith({
    AgentPhase? phase,
    Map<String, dynamic>? uiSpec,
    String? error,
    int? iterations,
  }) => AgentState(
    phase: phase ?? this.phase,
    uiSpec: uiSpec ?? this.uiSpec,
    error: error ?? this.error,
    iterations: iterations ?? this.iterations,
  );
}

class AgentController extends StateNotifier<AgentState> {
  AgentController(this._tools) : super(const AgentState());

  final ToolRegistry _tools;
  static const _maxIterations = 8; // guard against runaway loops

  /// Run the agent loop for a goal.
  Future<void> run(String goal) async {
    try {
      state = state.copyWith(
        phase: AgentPhase.planning,
        error: null,
        iterations: 0,
      );

      while (state.iterations < _maxIterations) {
        // TODO (Phase 5): ask the on-device model for the next action, decoded
        // against a grammar so it's ALWAYS valid JSON: {action, args} | {respond, ui}.
        //
        //   final step = await model.nextAction(context, grammar: agentGrammar);
        //   switch (step.action) {
        //     case 'call_tool':
        //        state = state.copyWith(phase: AgentPhase.callingTool);
        //        final obs = await _tools.call(step.tool, step.args);
        //        state = state.copyWith(phase: AgentPhase.awaitingObservation);
        //        // feed obs back into context
        //     case 'respond':
        //        state = state.copyWith(phase: AgentPhase.generatingUI, uiSpec: step.ui);
        //        state = state.copyWith(phase: AgentPhase.rendering);
        //        state = state.copyWith(phase: AgentPhase.awaitingUserAction);
        //        return;
        //   }
        state = state.copyWith(iterations: state.iterations + 1);
        break; // remove once the loop above is implemented
      }

      state = state.copyWith(phase: AgentPhase.done);
    } catch (e) {
      state = state.copyWith(phase: AgentPhase.error, error: e.toString());
    }
  }
}

final agentProvider = StateNotifierProvider<AgentController, AgentState>((ref) {
  return AgentController(ToolRegistry.withDefaults());
});
