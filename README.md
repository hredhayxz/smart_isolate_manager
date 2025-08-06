# Smart Isolate Manager 🚀

[![pub package](https://img.shields.io/pub/v/smart_isolate_manager.svg)](https://pub.dev/packages/smart_isolate_manager)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)

A powerful and easy-to-use isolate manager for running heavy Dart/Flutter tasks in the background with full error handling, timeouts, and logging support.

## Features ✨

- 🏗️ Simple and intuitive API for running tasks in isolates
- ⏱️ Configurable timeouts for tasks
- 📝 Built-in logging with pretty formatting
- 🚦 Proper error handling and propagation
- 🧵 Thread-safe singleton implementation
- 🎨 Configurable logging options
- 🔄 Automatic resource cleanup

## Installation 💻

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  smart_isolate_manager: ^0.0.1  # use the latest version
```

Then run:

```bash
flutter pub get
```

## Usage 🚀

### Basic Usage

```dart
import 'package:smart_isolate_manager/smart_isolate_manager.dart';

void main() async {
  // Initialize the isolate manager
  final isolateManager = SmartIsolateManager();
  isolateManager.initialize(
    config: IsolateConfig(
      enableLogging: true,
      prettyLog: true,
      taskTimeout: Duration(seconds: 30),
    ),
  );

  try {
    // Define a task
    final task = IsolateTask<int, String>(
      name: 'Example Task',
      argument: 42,
      task: (number) async {
        // Heavy computation here
        await Future.delayed(Duration(seconds: 1));
        return 'Processed: ${number * 2}';
      },
    );

    // Run the task in an isolate
    final result = await isolateManager.runTask(task);
    print('Result: $result'); // Output: Result: Processed: 84
  } catch (e) {
    print('Error: $e');
  }
}
```

### Error Handling

```dart
try {
  final task = IsolateTask<int, String>(
    name: 'Failing Task',
    argument: -1,
    task: (number) {
      if (number < 0) {
        throw ArgumentError('Number must be positive');
      }
      return 'Success';
    },
  );
  
  final result = await isolateManager.runTask(task);
} on IsolateTimeoutException catch (e) {
  print('Task timed out: $e');
} on IsolateException catch (e) {
  print('Isolate error: $e');
} catch (e, stack) {
  print('Unexpected error: $e\n$stack');
}
```

## Configuration ⚙️

### `IsolateConfig`

| Parameter      | Type      | Default | Description |
|----------------|-----------|---------|-------------|
| `enableLogging`| `bool`    | `false` | Enable/disable logging |
| `prettyLog`    | `bool`    | `false` | Enable pretty-printed logs |
| `taskTimeout`  | `Duration`| 30s     | Maximum time a task can run before timing out |

## Best Practices 📝

1. **Keep tasks focused**: Each task should do one thing well.
2. **Handle errors**: Always wrap task execution in try-catch blocks.
3. **Use meaningful names**: Name your tasks for better logging.
4. **Be mindful of memory**: Large objects passed to/from isolates are copied.
5. **Set appropriate timeouts**: Adjust timeouts based on expected task duration.

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Made with ❤️ by [Md Alhaz Mondal Hredhay](https://www.linkedin.com/in/hredhayxz/)

