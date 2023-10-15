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

#### Arguments

Each **BaseCommand** has by default the following arguments:

| Argument               | Abbreviation | Help                                                                    | Allowed values                                                             | Defaults to |
|------------------------|--------------|-------------------------------------------------------------------------|----------------------------------------------------------------------------|-------------|
| `--path`               | `-p`         | The root path of the project where the pubspec.yaml is.                 |                                                                            | `.`         |
| `--level`              | `-l`         | Define the level that will be used to filter log messages.              | `none`, `verbose`, `debug`, `info`, `success`, `warning`, `error`, `fatal` | `info`      |
| `--logdir`             | `-d`         | If not null, then messages will be logged into the specified directory. |                                                                            | `null`      |
| `--color`,`--no-color` | `-c`         | If set to false, no colors will be printed in the console.              |                                                                            | `true`      |


#### Usage

**Create a command with custom arguments**

```dart
class DemoCommand extends BaseCommand {
  DemoCommand({
    super.arguments = const <BaseArgument<void>>[],
    super.subCommands = const <BaseCommand>[],
  });

  @override
  String get name => 'cmd';

  @override
  String get description => 'This is a demo command';

  @override
  List<BaseArgument<void>> get arguments => <BaseArgument<void>>[enabledArg, inputArg, modeArg];

  static const FlagArgument enabledArg = FlagArgument(
    name: 'enabled',
    abbr: 'e',
    help: 'This is a demo flag argument',
  );

  static const OptionArgument<String> inputArg = OptionArgument<String>(
    name: 'input',
    abbr: 'i',
    help: 'This is a demo option argument',
    defaultsTo: 'default-input-value',
  );

  static const EnumArgument<Mode> modeArg = EnumArgument<Mode>(
    name: 'mode',
    abbr: 'm',
    help: 'This is a demo enum argument',
    defaultsTo: Mode.debug,
  );

  static const MultiEnumArgument<Feature> featureArg = MultiEnumArgument<Feature>(
    name: 'feature',
    abbr: 'f',
    help: 'This is a demo multi-option argument',
    defaultsTo: <Feature>[Feature.feat1],
  );

  Mode get mode => modeArg.parse(argResults)!;

  bool get enabled => enabledArg.parse(argResults);

  @override
  Future<void> execute() async {
    printArguments();

    Trace.info('Lorem ipsum dolor sit amet, consectetur adipiscing elit, \n'
            'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.');
  }
}  
```
