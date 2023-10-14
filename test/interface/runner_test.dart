import 'dart:io';

import 'package:dart_cmder/dart_cmder.dart';
import 'package:path/path.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:trace/trace.dart';

import 'mocks.dart';

void main() {
  group('BaseRunner', () {
    test('smoke test', () {
      final BaseRunner runner = DemoRunner();
      expect(runner.executableName, 'demo');
      expect(runner.description,
          'This is a demo CLI app written in Dart using dart_cmder.');
      expect(runner.usage, runnerUsageMock);
    });

    test('runs a command', () async {
      final BaseRunner runner = EmptyRunner();
      final DemoCommand command = DemoCommand();
      command.shouldSkipExit = true;
      runner.addCommand(command);

      expect(
        runner.run(<String>['cmd']).then((_) {
          expect(command.hasRun, isTrue);
          expect(command.hasErrors, isFalse);
        }),
        completes,
      );
    });

    test('terminate with errors', () async {
      final BaseRunner runner = EmptyRunner();
      final BaseCommand command = ErrorOnExecuteCommand();
      command.shouldSkipExit = true;
      runner.addCommand(command);

      expect(
        runner.run(<String>['error']).then((_) {
          expect(command.hasRun, isFalse);
          expect(command.hasErrors, isTrue);
        }),
        completes,
      );
    });

    test('terminate with errors', () async {
      final BaseRunner runner = EmptyRunner();
      final BaseCommand command = ErrorOnDisposeCommand();
      command.shouldSkipExit = true;
      runner.addCommand(command);

      expect(
        runner.run(<String>['error']).then((_) {
          expect(command.hasRun, isTrue);
          expect(command.hasErrors, isTrue);
        }),
        completes,
      );
    });

    test('with args', () async {
      final String path = join(Directory.current.path, 'test', 'interface');
      final String logpath = join(path, 'logs');
      final List<String> args = <String>[
        'cmd',
        '--no-enabled',
        '-m',
        'option1',
        '-i',
        'Hello dart_cmder',
        '-l',
        LogLevel.success.name,
        '--path',
        path,
        '-d',
        logpath,
      ];

      final DemoCommand command = DemoCommand();
      command.shouldSkipExit = true;
      final DemoRunner runner = DemoRunner(
        commands: <BaseCommand>[command],
      );

      await runner.run(args);

      expect(command.name, 'cmd');
      expect(command.description, 'This is a demo command');
      expect(command.subcommands.isEmpty, true);
      // expect(command.usage, commandUsage);
      expect(command.invocation, 'demo cmd [arguments]');
      expect(command.logLevel, LogLevel.success);
      expect(command.logsDirectory?.path, Directory(logpath).path);
      expect(command.path, path);
      expect(command.colored, true);
      expect(command.runner, runner);
      expect(command.enabled, false);
      expect(command.modes, <Option>[Option.option1]);
    });
  });
}
