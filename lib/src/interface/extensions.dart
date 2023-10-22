import 'package:args/args.dart';
import 'package:dart_cmder/dart_cmder.dart';

extension ArgParserX on ArgParser {
  void addArgument(final BaseArgument<dynamic> argument) {
    argument.addTo(this);
  }

  void addArguments(final List<BaseArgument<dynamic>> arguments) {
    for (final BaseArgument<dynamic> argument in arguments) {
      argument.addTo(this);
    }
  }
}
