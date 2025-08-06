import 'package:flutter_test/flutter_test.dart';
import 'package:smart_isolate_manager/smart_isolate_manager.dart';

void main() {
  group('SmartIsolateManager', () {
    final manager = SmartIsolateManager();

    setUp(() {
      manager.initialize(
        config: const IsolateConfig(
          enableLogging: true,
          prettyLog: false,
          taskTimeout: Duration(seconds: 1), // Short timeout for testing
        ),
      );
    });

    test('executes a simple task successfully', () async {
      final task = IsolateTask<int, int>(
        argument: 10,
        task: (input) => Future.value(input * 2),
        name: 'DoubleTask',
      );

      final result = await manager.runTask(task);
      expect(result, 20);
    });

    test('throws error if task fails', () async {
      final task = IsolateTask<void, void>(
        argument: null,
        task: (_) => throw Exception('Failure'),
        name: 'FailingTask',
      );

      expect(
        () async => await manager.runTask(task),
        throwsA(isA<Exception>()),
      );
    });

    test('throws IsolateTimeoutException when task times out', () async {
      final task = IsolateTask<void, void>(
        argument: null,
        task: (_) async {
          await Future.delayed(
            const Duration(seconds: 2),
          ); // Longer than timeout
        },
        name: 'TimeoutTask',
      );

      expect(
        () async => await manager.runTask(task),
        throwsA(isA<IsolateTimeoutException>()),
      );
    });
  });
}
