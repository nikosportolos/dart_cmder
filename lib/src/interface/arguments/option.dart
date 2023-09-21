part of 'argument.dart';

/// Defines an option that takes a value.
class OptionArgument<T> extends BaseArgument<T> {
  const OptionArgument({
    required super.name,
    super.abbr,
    super.help,
    super.allowedValues,
    this.defaultsTo,
    this.valueHelp,
    this.mandatory = false,
    super.hide = false,
    this.allowedHelp,
    super.valueBuilder,
  });

  final T? defaultsTo;
  final String? valueHelp;
  final bool mandatory;
  final Map<String, String>? allowedHelp;

  /// This adds an [Option](https://pub.dev/documentation/args/latest/args/Option-class.html)
  /// with the given properties to the options that have been defined for this parser.
  @override
  void add(final ArgParser parser) {
    parser.addOption(
      name,
      abbr: abbr,
      aliases: aliases,
      allowed:
          allowedValues?.map((T e) => e.toString()).toList(growable: false),
      allowedHelp: allowedHelp,
      defaultsTo: defaultsTo?.toString(),
      help: help,
      hide: hide,
      mandatory: mandatory,
      valueHelp: valueHelp,
    );
  }

  /// This method is used to parse the given [ArgResults] into a [T?].
  @override
  T? parse(ArgResults? results) {
    if (results == null) {
      return defaultsTo;
    }

    try {
      final T result = valueBuilder != null
          ? valueBuilder!.call(results[name])
          : results[name];
      return result;
    } catch (_) {
      return defaultsTo;
    }
  }
}
