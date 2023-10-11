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


#### Logo

When a [BaseRunner](#baserunner) runs, it prints the logo of the CLI app.

<a href="https://raw.githubusercontent.com/nikosportolos/dart_cmder/main/assets/images/example.webp" target="_blank">
  <img src="https://raw.githubusercontent.com/nikosportolos/dart_cmder/main/assets/images/example.webp" width="750" alt="dart-cmder-example">
</a>

By default, it consists of the name and the description of the executable.

You can override the default logo, or even avoid printing it, by setting the corresponding
fields in the BaseRunner's constructor.


Check the [example](https://github.com/nikosportolos/dart_cmder/tree/main/example/logo)
folder for more samples.
