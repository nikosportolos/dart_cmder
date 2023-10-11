import 'package:args/args.dart';

/// Base argument interface
abstract class BaseArgument<T> {
  const BaseArgument({
    required this.name,
    this.abbr,
    this.help,
    this.allowedValues,
    this.aliases = const <String>[],
    this.hide = false,
    this.valueBuilder,
  });

  final String name;
  final String? abbr;
  final String? help;
  final Iterable<T>? allowedValues;
  final List<String> aliases;
  final bool hide;
  final T Function(Object? value)? valueBuilder;

  /// This method adds an [Option](https://pub.dev/documentation/args/latest/args/Option-class.html)
  /// with the given properties to the options that have been defined for this parser.
  void add(final ArgParser argParser);

  /// This method is used to parse the given [ArgResults] into a [BaseArgument].
  dynamic parse(final ArgResults? argResults);
}
