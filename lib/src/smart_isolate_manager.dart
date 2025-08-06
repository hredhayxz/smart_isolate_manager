import 'dart:async';
import 'dart:isolate';

import 'isolate_task.dart';
import 'isolate_config.dart';
import 'isolate_logger.dart';
import 'isolate_exception.dart';

/// The main isolate manager class.
class SmartIsolateManager {
  static final SmartIsolateManager _instance = SmartIsolateManager._internal();

  factory SmartIsolateManager() => _instance;

  late final IsolateLogger _logger;
  late final IsolateConfig _config;

  SmartIsolateManager._internal();

  void initialize({IsolateConfig config = const IsolateConfig()}) {
    _config = config;
    _logger = IsolateLogger(
      enabled: config.enableLogging,
      pretty: config.prettyLog,
    );
    _logger.log('Initialized SmartIsolateManager with config: $config');
  }

  /// Runs a task in a new isolate and returns the result.
  Future<R> runTask<T, R>(IsolateTask<T, R> task) async {
    final completer = Completer<R>();
    final responsePort = ReceivePort();

    _logger.log('Spawning isolate for task: ${task.name ?? 'Unnamed'}');

    final isolate = await Isolate.spawn<_IsolateMessage<T, R>>(
      _isolateEntryPoint,
      _IsolateMessage(task: task, sendPort: responsePort.sendPort),
      debugName: task.name,
    );

    final timer = Timer(_config.taskTimeout, () {
      _logger.error('Task "${task.name}" timed out');
      responsePort.close();
      isolate.kill(priority: Isolate.immediate);
      completer.completeError(
        IsolateTimeoutException(task.name ?? 'Unnamed', _config.taskTimeout),
      );
    });

    responsePort.listen((message) {
      if (!completer.isCompleted) {
        timer.cancel();
        responsePort.close();
        isolate.kill(priority: Isolate.immediate);

        if (message is _IsolateResult<R>) {
          if (message.error != null) {
            _logger.error(
              'Task "${task.name}" failed with error: ${message.error}',
              message.error,
              message.stackTrace,
            );
            completer.completeError(message.error!, message.stackTrace);
          } else {
            _logger.log('Task "${task.name}" completed successfully.');
            completer.complete(message.result as R);
          }
        }
      }
    });

    return completer.future;
  }

  static void _isolateEntryPoint<T, R>(_IsolateMessage<T, R> message) async {
    try {
      final result = await message.task.task(message.task.argument);
      message.sendPort.send(_IsolateResult(result: result));
    } catch (e, st) {
      message.sendPort.send(_IsolateResult(error: e, stackTrace: st));
    }
  }
}

class _IsolateMessage<T, R> {
  final IsolateTask<T, R> task;
  final SendPort sendPort;

  _IsolateMessage({required this.task, required this.sendPort});
}

class _IsolateResult<R> {
  final R? result;
  final Object? error;
  final StackTrace? stackTrace;

  _IsolateResult({this.result, this.error, this.stackTrace});
}
