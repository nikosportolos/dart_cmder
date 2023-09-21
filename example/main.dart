import 'dart:io';

import 'demo_runner.dart';

void main(final List<String> args) {
  DemoRunner().run(<String>[
    'cmd',
    '--no-enabled',
    '-m',
    'debug',
    '-p',
    Directory.current.path,
  ]);
}
