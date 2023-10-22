import 'dart:io';

import 'package:ansix/ansix.dart';
import 'package:args/args.dart';
import 'package:dart_cmder/dart_cmder.dart';

class DirectoryArgument extends OptionArgument<Directory> {
  const DirectoryArgument({
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
  void addTo(final ArgParser parargParserer) {
    parargParserer.addOption(
      name,
      abbr: abbr,
      aliases: aliases,
      allowed: allowedValues
          ?.map((Directory directory) => directory.absolute.path)
          .toList(growable: false),
      allowedHelp: allowedHelp,
      defaultsTo: defaultsTo?.absolute.path.toString(),
      help: help,
      hide: hide,
      mandatory: mandatory,
      valueHelp: valueHelp,
    );
  }

  /// This method is used to parse the given [ArgResults] into a [Directory].
  @override
  Directory? parse(ArgResults? argResults) {
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

      return Finder.findDirectoryFromPath(value);
    } catch (_) {
      return defaultsTo;
    }
  }
}
