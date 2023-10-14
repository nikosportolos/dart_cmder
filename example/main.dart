import 'dart:io';

import 'package:trace/trace.dart';

import 'demo_runner.dart';

void main(final List<String> args) {
  DemoRunner().run(<String>[
    'cmd',
    '--no-enabled',
    '-m',
    'stage',
    '-i',
    'Hello dart_cmder',
    '-l',
    LogLevel.verbose.name,
    '-d',
    '${Directory.current.path}/logs',
    ...args,
  ]);
}
