part of 'argument.dart';

class OptionArgument extends BaseArgument {
  const OptionArgument({
    required super.name,
    super.abbr,
    super.help,
    super.defaultsTo,
    super.allowedValues,
    this.valueHelp,
    this.mandatory = false,
    super.hide = false,
    this.allowedHelp,
  });

  final String? valueHelp;
  final bool mandatory;
  final Map<String, String>? allowedHelp;

  @override
  void add(final ArgParser parser) {
    parser.addOption(
      name,
      abbr: abbr,
      aliases: aliases,
      allowed: allowedValues,
      allowedHelp: allowedHelp,
      defaultsTo: defaultsTo,
      help: help,
      hide: hide,
      mandatory: mandatory,
      valueHelp: valueHelp,
    );
  }
}
