import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_cmder/src/interface/command.dart';
import 'package:dart_cmder/src/logo.dart';
import 'package:trace/trace.dart';

/// An extended [CommandRunner] interface that provides
/// convenient methods and safe execution.
abstract class BaseRunner extends CommandRunner<void> {
  BaseRunner({
    required final String executableName,
    required final String description,
    required this.$commands,
    super.usageLineLength,
    super.suggestionDistanceLimit,
    this.sink,
    this.loggerTheme,
    this.logo,
    this.showLogo = true,
  }) : super(executableName, description) {
    $commands.forEach(addCommand);
  }

  final IOSink? sink;
  final Logo? logo;
  final bool showLogo;
  final List<BaseCommand> $commands;
  final LoggerTheme? loggerTheme;

  @override
  String get usage => super.usage.replaceFirst('$description\n\n', '');

  void printLogo() {
    if (!showLogo) {
      return;
    }

    Trace.print(
      logo?.formattedText ??
          Logo.fromText(
            title: executableName,
            subtitle: description,
          ).formattedText,
    );
  }
}
