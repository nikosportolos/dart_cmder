part of 'argument.dart';

class FlagArgument extends BaseArgument {
  const FlagArgument({
    required super.name,
    super.abbr,
    super.help,
    super.defaultsTo,
    super.allowedValues,
    this.negatable = true,
    super.aliases,
    super.hide = false,
  });

  final bool negatable;

  @override
  void add(final ArgParser parser) {
    parser.addFlag(
      name,
      abbr: abbr,
      aliases: aliases,
      defaultsTo: defaultsTo,
      help: help,
      hide: hide,
      negatable: negatable,
    );
  }
}
