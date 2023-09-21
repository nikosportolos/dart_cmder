import 'dart:io';

import 'package:ansix/ansix.dart';
import 'package:args/command_runner.dart';
import 'package:dart_cmder/src/command.dart';
import 'package:trace/trace.dart';

class BaseRunner extends CommandRunner<void> {
  BaseRunner({
    required final String executableName,
    required final String description,
    required this.$commands,
    super.usageLineLength,
    super.suggestionDistanceLimit,
    final IOSink? sink,
  }) : super(executableName, description) {
    Trace.registerLogger(
      ConsoleLogger(ioSink: sink),
    );
    initialize();
    $commands.forEach(addCommand);
  }

  final List<BaseCommand> $commands;

  @override
  String get usage => super.usage.replaceFirst('$description\n\n', '');

  void initialize() {
    // ignore: avoid_print
    print(
      AnsiGrid.list(
        <AnsiText>[
          AnsiText(
            executableName,
            alignment: AnsiTextAlignment.center,
            style: const AnsiTextStyle(bold: true),
          ),
          AnsiText(
            description,
            padding: AnsiPadding.horizontal(4),
            style: const AnsiTextStyle(italic: true),
            alignment: AnsiTextAlignment.center,
          ),
        ],
        theme: const AnsiGridTheme(
          overrideTheme: true,
          border: AnsiBorder(
            style: AnsiBorderStyle.rounded,
            type: AnsiBorderType.outside,
            color: AnsiColor.white,
          ),
        ),
      ),
    );
  }
}
