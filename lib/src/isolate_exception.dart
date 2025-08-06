/// Base exception for isolate-related errors.
class IsolateException implements Exception {
  final String message;

  IsolateException(this.message);

  @override
  String toString() => 'IsolateException: $message';
}

/// Thrown when a task exceeds its timeout.
class IsolateTimeoutException extends IsolateException {
  IsolateTimeoutException(String taskName, Duration timeout)
    : super('Task "$taskName" timed out after ${timeout.inSeconds}s.');
}
