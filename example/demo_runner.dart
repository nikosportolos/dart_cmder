// ignore_for_file: avoid_print

import 'package:dart_cmder/dart_cmder.dart';
import 'package:dart_cmder/src/extensions.dart';
import 'package:dart_cmder/src/runner.dart';

class DemoRunner extends BaseRunner {
  DemoRunner()
      : super(
          executableName: 'demo',
          description: 'This is a demo CLI app written in Dart using dart_cmder.',
          $commands: <BaseCommand>[
            DemoCommand(),
          ],
        );
}

class DemoCommand extends BaseCommand {
  @override
  String get name => 'cmd';

  @override
  String get description => 'This is a demo command';

  @override
  List<BaseArgument> get arguments => <BaseArgument>[enabledArg, inputArg, modeArg, ...BaseCommand.cmderArguments];

  static const FlagArgument enabledArg = FlagArgument(
    name: 'enabled',
    abbr: 'e',
    help: 'This is a demo flag argument',
  );
  static const OptionArgument inputArg = OptionArgument(
    name: 'input',
    abbr: 'i',
    help: 'This is a demo option argument',
    defaultsTo: 'default-input-value',
  );
  static const MultiOptionArgument modeArg = MultiOptionArgument(
    name: 'mode',
    abbr: 'm',
    help: 'This is a demo multi-option argument',
    allowedValues: <String>['debug', 'release'],
  );

  String get mode => argResults.getValue<String>(modeArg);

  bool get enabled => argResults.getValue<bool>(enabledArg);

  @override
  Future<void> execute() async {
    print('Running on [$mode] mode from [$path]');
    print('enabled = [$enabled]');
    print('logToFile = [$logToFile]');
    print('logLevel = [$logLevel]');

    print('\nLorem ipsum dolor sit amet, consectetur adipiscing elit, \n'
        'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.');
  }
}
