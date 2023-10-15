import 'package:ansix/ansix.dart';
import 'package:dart_cmder/dart_cmder.dart';

import 'mocks.dart';

void main() async {
  await RunnerWithCustomLogo().run(<String>[commandName]);
}

class RunnerWithCustomLogo extends BaseRunner {
  static const String subtitle = 'This is a CLI app with custom logo';

  RunnerWithCustomLogo()
      : super(
          executableName: title,
          description: subtitle,
          $commands: <BaseCommand>[
            DemoCommand(),
          ],
          logo: Logo(
            title: AnsiText(
              title,
              foregroundColor: AnsiColor.blueViolet,
              alignment: AnsiTextAlignment.center,
              style: const AnsiTextStyle(bold: true, underline: true),
              padding: AnsiPadding.vertical(1),
            ),
            subtitle: AnsiText(
              subtitle,
              foregroundColor: AnsiColor.purple3,
              alignment: AnsiTextAlignment.center,
              style: const AnsiTextStyle(italic: true),
              padding: AnsiPadding.horizontal(3) + AnsiPadding.only(bottom: 1),
            ),
            border: const AnsiBorder(
              color: AnsiColor.purple,
              type: AnsiBorderType.outside,
              style: AnsiBorderStyle.double,
            ),
          ),
        );
}
