import 'package:args/args.dart';

part 'flag.dart';
part 'multi_option.dart';
part 'option.dart';

abstract class BaseArgument {
  const BaseArgument({
    required this.name,
    this.abbr,
    this.help,
    this.defaultsTo,
    this.allowedValues,
    this.aliases = const <String>[],
    this.hide = false,
  });

  final String name;
  final String? abbr;
  final String? help;
  final dynamic defaultsTo;
  final Iterable<String>? allowedValues;
  final List<String> aliases;
  final bool hide;

  static Map<BaseArgument, dynamic> fromArguments(
    final ArgResults results,
    final List<BaseArgument> arguments,
  ) {
    return <BaseArgument, dynamic>{
      for (final BaseArgument value in arguments) //
        value: results[value.name] ?? value.defaultsTo
    };
  }

  void add(final ArgParser parser) {
    throw UnimplementedError();
  }
}
