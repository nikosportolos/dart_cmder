import 'package:args/args.dart';
import 'package:dart_cmder/src/interface/arguments/multi_option.dart';
import 'package:dart_cmder/src/tools/enums.dart';

/// Defines an option that takes multiple values.
class MultiEnumArgument<T> extends MultiOptionArgument<T> {
  const MultiEnumArgument({
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
      allowed: allowedValues?.map((T e) => e.toString()),
      allowedHelp: allowedHelp,
      defaultsTo:
          defaultsTo?.map((T e) => e.toString()).toList(growable: false),
      help: help,
      hide: hide,
      splitCommas: splitCommas,
      valueHelp: valueHelp,
    );
  }

  /// This method is used to parse the given [ArgResults] into a [List<T>].
  @override
  List<T> parse(ArgResults? argResults) {
    if (argResults == null) {
      return defaultsTo?.toList(growable: false) ?? <T>[];
    }

    try {
      if (valueBuilder != null) {
        return <T>[
          for (final Object? o in argResults[name]) //
            valueBuilder!.call(o)
        ];
      }

      final List<Object?> values = argResults[name];
      if (values.isEmpty) {
        return <T>[];
      }

      return <T>[
        for (final Object? value in values) //
          value.toEnum<T?>(null)!
      ];
    } catch (_) {
      return defaultsTo ?? <T>[];
    }
  }
}
