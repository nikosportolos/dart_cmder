import 'dart:async';
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
      final DemoRunner runner = DemoRunner(
        commands: <BaseCommand>[command],
      );

      unawaited(runner.run(args));

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(command.name, 'cmd');
      expect(command.description, 'This is a demo command');
      expect(command.subcommands.isEmpty, true);
      // expect(command.usage, commandUsage);
      expect(command.invocation, 'demo cmd [arguments]');
      expect(command.logLevel, LogLevel.success);
      expect(command.logsDirectory, logpath);
      expect(command.path, path);
      expect(command.runner, runner);
      expect(command.enabled, false);
      expect(command.modes, <Option>[Option.option1]);
    });
  });
}
