// ignore_for_file: avoid_print

import 'package:dart_cmder/dart_cmder.dart';
import 'package:trace/trace.dart';

enum Option {
  option1,
  option2,
  option3;

  @override
  String toString() => name;
}

class DemoRunner extends BaseRunner {
  DemoRunner({
    final List<BaseCommand> commands = const <BaseCommand>[],
  }) : super(
          executableName: 'demo',
          description:
              'This is a demo CLI app written in Dart using dart_cmder.',
          $commands: <BaseCommand>[
            DemoCommand(),
            ...commands,
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

  List<Option> get modes => modeArg.parse(argResults) as List<Option>;

  bool get enabled => enabledArg.parse(argResults);

  @override
  Future<void> execute() async {
    printArguments();

    Trace.info('Lorem ipsum dolor sit amet, consectetur adipiscing elit, \n'
        'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.');
  }
}
