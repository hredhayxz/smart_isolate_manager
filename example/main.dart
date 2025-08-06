import 'package:flutter/material.dart';
import 'package:smart_isolate_manager/smart_isolate_manager.dart';

void main() async {
  final isolateManager = SmartIsolateManager();
  isolateManager.initialize(
    config: IsolateConfig(
      enableLogging: true,
      prettyLog: true,
      taskTimeout: Duration(seconds: 10),
    ),
  );

  final task = IsolateTask<int, int>(
    name: 'SquareTask',
    argument: 12,
    task: (number) async {
      await Future.delayed(Duration(seconds: 2));
      return number * number;
    },
  );

  try {
    final result = await isolateManager.runTask(task);
    debugPrint('✅ Result from isolate: $result');
  } catch (e) {
    debugPrint('❌ Error running task: $e');
  }
}
