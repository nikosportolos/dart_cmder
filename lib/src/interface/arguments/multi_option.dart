import 'package:args/args.dart';
import 'package:dart_cmder/src/interface/arguments/argument.dart';

/// Defines an option that takes multiple values.
class MultiOptionArgument<T> extends BaseArgument<T> {
  const MultiOptionArgument({
    required super.name,
    super.abbr,
    super.help,
    super.allowedValues,
    super.hide = false,
    super.aliases,
    this.defaultsTo,
    this.splitCommas = true,
    this.valueHelp,
    this.allowedHelp,
    super.valueBuilder,
  });

  final bool splitCommas;
  final String? valueHelp;
  final Map<String, String>? allowedHelp;
  final List<T>? defaultsTo;

  /// This adds an [Option](https://pub.dev/documentation/args/latest/args/Option-class.html)
  /// with the given properties to the options that have been defined for this parser.
  @override
  void add(final ArgParser parser) {
    parser.addMultiOption(
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
  List<T> parse(ArgResults? results) {
    if (results == null) {
      return defaultsTo?.toList(growable: false) ?? <T>[];
    }

    try {
      if (valueBuilder != null) {
        return <T>[
          for (final Object? o in results[name]) //
            valueBuilder!.call(o)
        ];
      }

      final List<Object?> values = results[name];
      if (values.isEmpty) {
        return <T>[];
      }

      return results[name] ?? defaultsTo ?? <T>[];
    } catch (_) {
      return defaultsTo ?? <T>[];
    }
  }
}
