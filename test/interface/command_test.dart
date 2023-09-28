import 'package:dart_cmder/dart_cmder.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:trace/trace.dart';

import 'mocks.dart';

void main() {
  group('BaseCommand', () {
    test('smoke test', () {
      final BaseCommand command = DemoCommand(
        subCommands: <BaseCommand>[
          DemoSubCommand(),
        ],
      );

      expect(command.name, 'cmd');
      expect(command.description, 'This is a demo command');
      expect(command.subcommands.isEmpty, false);
      expect(command.subcommands.entries.first.value.name, 'sub');
      expect(command.subcommands.entries.first.value.description, 'Demo sub-command');
      expect(command.path, '.');
      expect(command.logLevel, LogLevel.info);
      expect(command.logsDirectory, null);
      expect(command.runner, null);
    });

    test('from runner', () {
      final DemoRunner runner = DemoRunner();
      final BaseCommand command = runner.$commands[0];

      expect(command.name, 'cmd');
      expect(command.description, 'This is a demo command');
      expect(command.subcommands.isEmpty, true);
      expect(command.usage, commandUsage);
      expect(command.invocation, 'demo cmd [arguments]');
      expect(command.logLevel, LogLevel.info);
      expect(command.logsDirectory, null);
      expect(command.path, '.');
      expect(command.runner, runner);
    });

    test('subcommands', () {
      final DemoRunner runner = DemoRunner();
      final BaseCommand command = runner.$commands[0];

      command.addSubcommand(DemoCommand());
      expect(command.subcommands.isEmpty, false);
      expect(command.usage, subcommandUsage);
      expect(command.invocation, 'demo cmd <subcommand> [arguments]');
      expect(command.logLevel, LogLevel.info);
      expect(command.logsDirectory, null);
      expect(command.path, '.');
      expect(command.runner, runner);
    });

    // test('with error', () async {
    //   final StreamSubscription<LogEntry> sub =
    //       Trace.stream.listen((LogEntry event) {});
    //   try {
    //     final ErrorCommand command = ErrorCommand();
    //     final DemoRunner runner = DemoRunner(commands: <BaseCommand>[command]);
    //
    //     command.skipExit = true;
    //
    //     await command.run();
    //
    //   } catch (e) {
    //     // TODO
    //   }
    //   await sub.cancel();
    // });
  });
}
