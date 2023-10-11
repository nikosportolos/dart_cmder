import 'package:args/args.dart';
import 'package:dart_cmder/dart_cmder.dart';
import 'package:dart_cmder/src/tools/enums.dart';

class EnumArgument<T> extends OptionArgument<T> {
  const EnumArgument({
    required super.name,
    super.abbr,
    super.help,
    super.allowedValues,
    super.defaultsTo,
    super.valueHelp,
    super.mandatory = false,
    super.hide = false,
    super.allowedHelp,
    super.valueBuilder,
  });

  /// This adds an [Option](https://pub.dev/documentation/args/latest/args/Option-class.html)
  /// with the given properties to the options that have been defined for this parser.
  @override
  void add(final ArgParser argParser) {
    argParser.addOption(
      name,
      abbr: abbr,
      aliases: aliases,
      allowed: allowedValues == null
          ? defaultsTo.getEnumValueStrings<T>()
          : allowedValues.getEnumValueStrings<T>(),
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
  T? parse(ArgResults? argResults) {
    if (argResults == null) {
      return defaultsTo;
    }

    try {
      if (valueBuilder != null) {
        return valueBuilder!.call(argResults[name]);
      }

      final Object? value = argResults[name];
      return value.toNullableEnum<T?>(defaultsTo);
    } catch (_) {
      return defaultsTo;
    }
  }
}
