import 'package:args/args.dart';
import 'package:dart_cmder/src/interface/arguments/argument.dart';

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
  void add(final ArgParser argParser) {
    argParser.addOption(
      name,
      abbr: abbr,
      aliases: aliases,
      allowed: _getAllowedValues(),
      allowedHelp: allowedHelp,
      defaultsTo: defaultsTo?.toString(),
      help: help,
      hide: hide,
      mandatory: mandatory,
      valueHelp: valueHelp,
    );
  }

  List<String>? _getAllowedValues() {
    if (allowedValues == null || allowedValues!.isEmpty) {
      return null;
    }

    return allowedValues!.map((T e) {
      return e.toString();
    }).toList(growable: false);
  }

  /// This method is used to parse the given [ArgResults] into a [T?].
  @override
  T? parse(ArgResults? argResults) {
    if (argResults == null) {
      return defaultsTo;
    }

    try {
      if (valueBuilder != null) {
        return valueBuilder!.call(argResults[name]);
      }

      return argResults[name] ?? defaultsTo;
    } catch (_) {
      return defaultsTo;
    }
  }
}
