import 'package:dart_cmder/dart_cmder.dart';

import 'mocks.dart';

void main() async {
  await RunnerWithNoLogo().run(<String>[commandName]);
}

class RunnerWithNoLogo extends BaseRunner {
  RunnerWithNoLogo()
      : super(
          executableName: title,
          description: 'This is a CLI app with no logo',
          $commands: <BaseCommand>[
            DemoCommand(),
          ],
          showLogo: false,
        );
}
