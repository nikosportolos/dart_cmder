import 'dart:io';

import 'package:ansix/ansix.dart';
import 'package:args/args.dart';
import 'package:dart_cmder/src/interface/arguments/multi_option.dart';

/// Defines an option that takes multiple values.
class MultiDirectoryArgument extends MultiOptionArgument<Directory> {
  const MultiDirectoryArgument({
    required super.name,
    super.abbr,
    super.help,
    super.allowedValues,
    super.hide = false,
    super.aliases,
    super.defaultsTo,
    super.splitCommas = true,
    super.valueHelp,
    super.allowedHelp,
    super.valueBuilder,
  });

  /// This adds an [Option](https://pub.dev/documentation/args/latest/args/Option-class.html)
  /// with the given properties to the options that have been defined for this parser.
  @override
  void add(final ArgParser argParser) {
    argParser.addMultiOption(
      name,
      abbr: abbr,
      aliases: aliases,
      allowed: allowedValues
          ?.map((Directory directory) => directory.absolute.path)
          .toList(growable: false),
      allowedHelp: allowedHelp,
      defaultsTo: defaultsTo
          ?.map((Directory directory) => directory.absolute.path.toString())
          .toList(growable: false),
      help: help,
      hide: hide,
      splitCommas: splitCommas,
      valueHelp: valueHelp,
    );
  }

  /// This method is used to parse the given [ArgResults] into a [List<Directory>].
  @override
  List<Directory> parse(ArgResults? argResults) {
    if (argResults == null) {
      return defaultsTo?.toList(growable: false) ?? <Directory>[];
    }

    try {
      if (valueBuilder != null) {
        return <Directory>[
          for (final Object? o in argResults[name]) //
            valueBuilder!.call(o)
        ];
      }

      final List<Object?> values = argResults[name];
      if (values.isEmpty) {
        return <Directory>[];
      }

      return <Directory>[
        for (final Object? value in values)
          if (!value.toString().isNullOrEmpty) //
            Directory(value!.toString())
      ];
    } catch (_) {
      return defaultsTo ?? <Directory>[];
    }
  }
}
