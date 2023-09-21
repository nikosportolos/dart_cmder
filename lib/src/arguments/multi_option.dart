part of 'argument.dart';

class MultiOptionArgument extends BaseArgument {
  const MultiOptionArgument({
    required super.name,
    super.abbr,
    super.help,
    super.defaultsTo,
    super.allowedValues,
    super.hide = false,
    this.splitCommas = true,
    this.valueHelp,
    this.allowedHelp,
  });

  final bool splitCommas;
  final String? valueHelp;
  final Map<String, String>? allowedHelp;

  @override
  void add(final ArgParser parser) {
    parser.addMultiOption(
      name,
      abbr: abbr,
      aliases: aliases,
      allowed: allowedValues,
      allowedHelp: allowedHelp,
      defaultsTo: defaultsTo,
      help: help,
      hide: hide,
      splitCommas: splitCommas,
      valueHelp: valueHelp,
    );
  }
}
