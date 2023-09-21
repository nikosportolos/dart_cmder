import 'package:args/args.dart';
import 'package:dart_cmder/dart_cmder.dart';
import 'package:test/test.dart';

void main() {
  group('MultiOptionArgument', () {
    test('null ArgResults', () {
      const MultiOptionArgument<String?> argument =
          MultiOptionArgument<String?>(name: 'option');
      argument.add(ArgParser());
      expect(argument.parse(null), null);
    });

    group('String', () {
      group('no default value', () {
        _testMultiOptionArgument(
          argument: const MultiOptionArgument<String?>(
            name: 'option',
            abbr: 'o',
          ),
          mocks: <Iterable<String>, Iterable<String?>>{
            <String>['--option', 'test']: <String?>['test'],
            <String>['-o', 'test']: <String?>['test'],
            <String>['test', 'test']: <String?>[],
            <String>['']: <String?>[],
          },
        );
      });

      group('with default value', () {
        _testMultiOptionArgument(
          argument: const MultiOptionArgument<String?>(
            name: 'option',
            abbr: 'o',
            defaultsTo: <String?>['dart_cmder'],
          ),
          mocks: <Iterable<String>, Iterable<String?>>{
            <String>['--option', 'test']: <String?>['test'],
            <String>['-o', 'test']: <String?>['test'],
            <String>['test', 'test']: <String?>['dart_cmder'],
            <String>['']: <String?>['dart_cmder'],
          },
        );
      });
    });

    group('enum', () {
      group('no default value - no value builder', () {
        _testMultiOptionArgument(
          argument: const MultiOptionArgument<Mode?>(name: 'mode', abbr: 'm'),
          mocks: <Iterable<String>, Iterable<String>?>{
            <String>['--mode', Mode.release.name]: <String>[Mode.release.name],
            <String>['-m', Mode.release.name]: <String>[Mode.release.name],
            <String>['test', Mode.release.name]: <String>[],
            <String>['']: <String>[],
          },
        );
      });

      group('with default value - no value builder', () {
        _testMultiOptionArgument(
          argument: const MultiOptionArgument<Mode>(
              name: 'mode', abbr: 'm', defaultsTo: <Mode>[Mode.debug]),
          mocks: <Iterable<String>, Iterable<String>?>{
            <String>['--mode', Mode.release.name]: <String>[Mode.release.name],
            <String>['-m', Mode.release.name]: <String>[Mode.release.name],
            <String>['test', Mode.release.name]: <String>['Mode.debug'],
            <String>['']: <String>['Mode.debug'],
          },
        );
      });

      group('no default value & value builder', () {
        _testMultiOptionArgument(
          argument: MultiOptionArgument<Mode>(
            name: 'mode',
            abbr: 'm',
            valueBuilder: (Object? m) {
              return Mode.values
                      .where((Mode mode) => m.toString() == mode.name)
                      .firstOrNull ??
                  Mode.debug;
            },
          ),
          mocks: <Iterable<String>, Iterable<Mode>?>{
            <String>['--mode', Mode.release.name]: <Mode>[Mode.release],
            <String>['-m', Mode.release.name]: <Mode>[Mode.release],
            <String>['test', Mode.release.name]: <Mode>[],
            <String>['']: <Mode>[],
          },
        );
      });

      group('with default value & value builder', () {
        _testMultiOptionArgument(
          argument: MultiOptionArgument<Mode>(
            name: 'mode',
            abbr: 'm',
            defaultsTo: <Mode>[Mode.debug],
            valueBuilder: (Object? m) {
              return Mode.values
                      .where((Mode mode) => m.toString() == mode.name)
                      .firstOrNull ??
                  Mode.debug;
            },
          ),
          mocks: <Iterable<String>, Iterable<Mode>?>{
            <String>['--mode', Mode.release.name]: <Mode>[Mode.release],
            <String>['-m', Mode.release.name]: <Mode>[Mode.release],
            <String>['test', Mode.release.name]: <Mode>[Mode.debug],
            <String>['']: <Mode>[Mode.debug],
          },
        );
      });
    });
  });
}

enum Mode { debug, release }

typedef MultiOptionArgumentMock = Map<Iterable<String>, Iterable<dynamic>?>;

void _testMultiOptionArgument<T>({
  required final MultiOptionArgumentMock mocks,
  required final MultiOptionArgument<T> argument,
}) {
  for (final MapEntry<Iterable<String>, Iterable<dynamic>?> mock
      in mocks.entries) {
    test('${mock.key} --> ${mock.value}', () {
      final ArgParser parser = ArgParser();
      argument.add(parser);
      final ArgResults results = parser.parse(mock.key);
      expect(argument.parse(results), mock.value);
    });
  }
}
