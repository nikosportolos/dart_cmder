import 'dart:io';

import 'package:ansix/ansix.dart';
import 'package:args/args.dart';
import 'package:dart_cmder/dart_cmder.dart';

class FileArgument extends OptionArgument<File> {
  const FileArgument({
    required super.name,
    super.abbr,
    super.help,
    super.allowedValues,
    super.defaultsTo,
    super.valueHelp,
    super.mandatory = false,
    super.hide = false,
    super.allowedHelp,
    super.valueBuilder,
  });

  /// This adds an [Option](https://pub.dev/documentation/args/latest/args/Option-class.html)
  /// with the given properties to the options that have been defined for this parser.
  @override
  void add(final ArgParser argParser) {
    argParser.addOption(
      name,
      abbr: abbr,
      aliases: aliases,
      allowed: allowedValues
          ?.map((File directory) => directory.absolute.path)
          .toList(growable: false),
      allowedHelp: allowedHelp,
      defaultsTo: defaultsTo?.absolute.path.toString(),
      help: help,
      hide: hide,
      mandatory: mandatory,
      valueHelp: valueHelp,
    );
  }

  /// This method is used to parse the given [ArgResults] into a [File].
  @override
  File? parse(ArgResults? argResults) {
    if (argResults == null) {
      return defaultsTo;
    }

    try {
      if (valueBuilder != null) {
        return valueBuilder!.call(argResults[name]);
      }

      final String? value = argResults[name];
      if (value.isNullOrEmpty) {
        return defaultsTo;
      }

      return File(value!);
    } catch (_) {
      return defaultsTo;
    }
  }
}
