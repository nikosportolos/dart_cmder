import 'package:args/args.dart';
import 'package:dart_cmder/dart_cmder.dart';

extension ArgumentX on BaseArgument {
  void add(final ArgParser parser) {}
}

extension ArgResultsX on ArgResults? {
  T getValue<T>(BaseArgument option) {
    return (this?[option.name] ?? option.defaultsTo) as T;
  }
}
