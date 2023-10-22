import 'dart:io';

import 'package:ansix/ansix.dart';
import 'package:args/args.dart';
import 'package:dart_cmder/src/interface/arguments/multi_option.dart';

/// Defines an option that takes multiple values.
class MultiFileArgument extends MultiOptionArgument<File> {
  const MultiFileArgument({
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
  void addTo(final ArgParser argParser) {
    argParser.addMultiOption(
      name,
      abbr: abbr,
      aliases: aliases,
      allowed: allowedValues
          ?.map((File directory) => directory.absolute.path)
          .toList(growable: false),
      allowedHelp: allowedHelp,
      defaultsTo: defaultsTo
          ?.map((File directory) => directory.absolute.path.toString())
          .toList(growable: false),
      help: help,
      hide: hide,
      splitCommas: splitCommas,
      valueHelp: valueHelp,
    );
  }

  /// This method is used to parse the given [ArgResults] into a [List<File>].
  @override
  List<File> parse(ArgResults? argResults) {
    if (argResults == null) {
      return defaultsTo?.toList(growable: false) ?? <File>[];
    }

    try {
      if (valueBuilder != null) {
        return <File>[
          for (final Object? o in argResults[name]) //
            valueBuilder!.call(o)
        ];
      }

      final List<Object?> values = argResults[name];
      if (values.isEmpty) {
        return <File>[];
      }

      return <File>[
        for (final Object? value in values)
          if (!value.toString().isNullOrEmpty) //
            File(value!.toString())
      ];
    } catch (_) {
      return defaultsTo ?? <File>[];
    }
  }
}
