import 'dart:async';

/// Represents a single isolate task with required arguments and a callback function.
class IsolateTask<T, R> {
  final FutureOr<R> Function(T argument) task;
  final T argument;
  final String? name;

  IsolateTask({required this.task, required this.argument, this.name});
}
