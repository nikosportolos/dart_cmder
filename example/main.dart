import 'dart:io';

import 'package:trace/trace.dart';

import 'demo_runner.dart';

void main() {
  final List<String> args = <String>[
    'cmd',
    '--no-enabled',
    '-m',
    'option1',
    '-i',
    'Hello dart_cmder',
    '-l',
    LogLevel.verbose.name,
    '-d',
    '${Directory.current.path}/logs',
  ];

  DemoRunner().run(args);
}
