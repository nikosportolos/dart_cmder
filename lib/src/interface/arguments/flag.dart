import 'package:args/args.dart';
import 'package:dart_cmder/src/interface/arguments/argument.dart';

/// Defines a boolean flag.
///
/// This adds an [Option] with the given properties
/// to the options that have been defined for this parser.
class FlagArgument extends BaseArgument<bool> {
  const FlagArgument({
    required super.name,
    super.abbr,
    super.help,
    this.defaultsTo,
    this.negatable = true,
    super.aliases,
    super.hide = false,
    super.valueBuilder,
  });

  final bool? defaultsTo;
  final bool negatable;

  /// This adds an [Option](https://pub.dev/documentation/args/latest/args/Option-class.html)
  /// with the given properties to the options that have been defined for this parser.
  @override
  void add(final ArgParser argParser) {
    argParser.addFlag(
      name,
      abbr: abbr,
      aliases: aliases,
      defaultsTo: defaultsTo,
      help: help,
      hide: hide,
      negatable: negatable,
    );
  }

  @override
  bool parse(ArgResults? argResults) {
    if (argResults == null || argResults.options.isEmpty) {
      return defaultsTo ?? false;
    }

    return argResults[name] ?? defaultsTo ?? false;
  }
}
