// ignore_for_file: avoid_print

import 'package:dart_cmder/dart_cmder.dart';
import 'package:trace/trace.dart';

enum Mode { debug, stage, release }

enum Feature { feat1, feat2, feat3, feat4 }

class DemoRunner extends BaseRunner {
  DemoRunner({
    final List<BaseCommand> commands = const <BaseCommand>[],
  }) : super(
          executableName: 'demo',
          description: 'This is a demo CLI app written in Dart using dart_cmder.',
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
