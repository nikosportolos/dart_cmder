# dart_cmder

## Commands

### BaseCommand

An extended [Command](https://pub.dev/documentation/args/latest/command_runner/Command-class.html) interface.

```dart
BaseCommand({
  this.arguments = const <BaseArgument<void>>[],
  final List<BaseCommand> subCommands = const <BaseCommand>[],
})
```
