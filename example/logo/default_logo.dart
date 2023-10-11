import 'package:dart_cmder/dart_cmder.dart';

import 'mocks.dart';

void main() async {
  await RunnerWithDefaultLogo().run(<String>[commandName]);
}

class RunnerWithDefaultLogo extends BaseRunner {
  RunnerWithDefaultLogo()
      : super(
          executableName: title,
          description: 'This is a CLI app with default logo',
          $commands: <BaseCommand>[
            DemoCommand(),
          ],
        );
}
