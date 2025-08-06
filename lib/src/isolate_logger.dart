import 'dart:developer' as developer;

/// Logger utility for isolate package.
class IsolateLogger {
  final bool enabled;
  final bool pretty;

  IsolateLogger({required this.enabled, required this.pretty});

  void log(String message) {
    if (!enabled) return;
    final timestamp = DateTime.now().toIso8601String();
    final decorated = pretty
        ? '\n🧠 [SmartIsolateManager] [$timestamp] => $message\n'
        : '[SmartIsolateManager] [$timestamp]: $message';
    developer.log(decorated);
  }

  void error(String message, [Object? error, StackTrace? stack]) {
    if (!enabled) return;
    final decorated = pretty
        ? '\n🚨 [SmartIsolateManager ERROR] => $message\n$error\n$stack\n'
        : '[SmartIsolateManager ERROR]: $message\n$error\n$stack';
    developer.log(decorated);
  }
}
