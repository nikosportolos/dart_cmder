import 'package:args/args.dart';
import 'package:dart_cmder/dart_cmder.dart';
import 'package:test/test.dart';

void main() {
  group('FlagArgument', () {
    test('null ArgResults', () {
      const FlagArgument argument = FlagArgument(name: 'flag');
      argument.addTo(ArgParser());
      expect(argument.parse(null), false);
    });

    group('no default value', () {
      _testFlagArgument(
        argument: const FlagArgument(name: 'flag', abbr: 'f'),
        mocks: <String, bool?>{
          '--flag': true,
          '--no-flag': false,
          '-f': true,
          'test': false,
          '': false,
        },
      );
    });

    group('with default value', () {
      _testFlagArgument(
        argument: const FlagArgument(name: 'flag', abbr: 'f', defaultsTo: true),
        mocks: <String, bool?>{
          '--flag': true,
          '--no-flag': false,
          '-f': true,
          'test': true,
          '': true,
        },
      );
    });
  });
}

void _testFlagArgument({
  required final Map<String, bool?> mocks,
  required final FlagArgument argument,
}) {
  for (final MapEntry<String, bool?> mock in mocks.entries) {
    test('${mock.key} --> ${mock.value}', () {
      final ArgParser parser = ArgParser();
      argument.addTo(parser);
      final ArgResults results = parser.parse(<String>[mock.key]);
      expect(argument.parse(results), mock.value);
    });
  }
}
