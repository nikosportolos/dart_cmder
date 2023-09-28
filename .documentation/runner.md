# dart_cmder

## CLI Runner


### BaseRunner

An extended [CommandRunner](https://pub.dev/documentation/args/latest/command_runner/CommandRunner-class.html)
interface that provides convenient methods and safe execution.

```dart
BaseRunner({
  required final String executableName,
  required final String description,
  required this.$commands,
  super.usageLineLength,
  super.suggestionDistanceLimit,
  this.sink,
  this.loggerTheme,
  this.logo,
  this.showLogo = true,
})
```
