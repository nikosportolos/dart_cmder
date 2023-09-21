part of 'argument.dart';

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
  final Iterable<T>? defaultsTo;

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

  /// This method is used to parse the given [ArgResults] into a [List<String>].
  @override
  List<Object?>? parse(ArgResults? results) {
    if (results == null) {
      return defaultsTo?.toList(growable: false);
    }

    try {
      final List<String>? result = results[name] as List<String>?;
      if (result == null || result.isEmpty) {
        return defaultsTo == null
            ? const <Never>[]
            : defaultsTo!.toList(growable: false);
      }

      if (valueBuilder == null) {
        return result;
      }

      return <T>[
        for (final String r in result) //
          valueBuilder!.call(r),
      ];
    } catch (_) {
      return defaultsTo == null
          ? const <Never>[]
          : defaultsTo!.toList(growable: false);
    }
  }
}
