/// Configuration options for SmartIsolateManager.
class IsolateConfig {
  final bool enableLogging;
  final bool prettyLog;
  final Duration taskTimeout;

  const IsolateConfig({
    this.enableLogging = false,
    this.prettyLog = false,
    this.taskTimeout = const Duration(seconds: 30),
  });
}
