// ignore_for_file: avoid_print

import 'package:dart_cmder/dart_cmder.dart';

enum Option {
  option1,
  option2,
  option3;

  @override
  String toString() => name;
}

class EmptyRunner extends BaseRunner {
  EmptyRunner({
    final List<BaseCommand> commands = const <BaseCommand>[],
  }) : super(
          executableName: 'empty',
          description:
              'This is a demo CLI app written in Dart using dart_cmder.',
          $commands: commands,
        );
}

class DemoRunner extends BaseRunner {
  DemoRunner({final List<BaseCommand>? commands})
      : super(
          executableName: 'demo',
          description:
              'This is a demo CLI app written in Dart using dart_cmder.',
          $commands: commands ??
              <BaseCommand>[
                DemoCommand(),
              ],
        );
}

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
  List<BaseArgument<void>> get arguments =>
      <BaseArgument<void>>[enabledArg, inputArg, modeArg];

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

  static final MultiOptionArgument<Option> modeArg =
      MultiOptionArgument<Option>(
          name: 'mode',
          abbr: 'm',
          help: 'This is a demo multi-option argument',
          allowedValues: Option.values,
          valueBuilder: (Object? value) {
            return Option.values.where((Option m) => m.name == value).first;
          });

  List<Option> get modes => modeArg.parse(argResults);

  bool get enabled => enabledArg.parse(argResults);

  @override
  Future<void> execute() async {
    printArguments();

    print('Lorem ipsum dolor sit amet, consectetur adipiscing elit, \n'
        'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.');
  }
}

class DemoSubCommand extends BaseCommand {
  @override
  String get name => 'sub';

  @override
  String get description => 'Demo sub-command';

  @override
  Future<void> execute() async {
    print('This is a sub-command');
  }
}

class ErrorOnExecuteCommand extends BaseCommand {
  @override
  String get name => 'error';

  @override
  String get description => 'error command';

  @override
  Future<void> execute() async {
    throw Exception('this is a test exception');
  }
}

class ErrorOnDisposeCommand extends BaseCommand {
  @override
  String get name => 'error';

  @override
  String get description => 'error command';

  @override
  Future<void> execute() async {}

  @override
  Future<void> dispose() async {
    throw Exception('this is a test exception');
  }
}

const String runnerUsageMock = '''
Usage: demo <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  cmd   This is a demo command

Run "demo help <command>" for more information about a command.''';

const String commandUsage = '''
This is a demo command

Usage: demo cmd [arguments]
-h, --help            Print this usage information.
-e, --[no-]enabled    This is a demo flag argument
-i, --input           This is a demo option argument
                      (defaults to "default-input-value")
-m, --mode            This is a demo multi-option argument
                      [option1, option2, option3]
-p, --path            The root path of the project where the pubspec.yaml is.
                      (defaults to ".")
-l, --level           Define the level that will be used to filter log messages.
                      [none, verbose, debug, info (default), success, warning, error, fatal]
-d, --logdir          If not null, then messages will be logged into the specified directory.

Run "demo help" to see global options.''';

const String subcommandUsage = '''This is a demo command

Usage: demo cmd <subcommand> [arguments]
-h, --help            Print this usage information.
-e, --[no-]enabled    This is a demo flag argument
-i, --input           This is a demo option argument
                      (defaults to "default-input-value")
-m, --mode            This is a demo multi-option argument
                      [option1, option2, option3]
-p, --path            The root path of the project where the pubspec.yaml is.
                      (defaults to ".")
-l, --level           Define the level that will be used to filter log messages.
                      [none, verbose, debug, info (default), success, warning, error, fatal]
-d, --logdir          If not null, then messages will be logged into the specified directory.

Available subcommands:
  cmd   This is a demo command

Run "demo help" to see global options.''';
