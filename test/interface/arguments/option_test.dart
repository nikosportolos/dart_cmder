import 'package:args/args.dart';
import 'package:dart_cmder/dart_cmder.dart';
import 'package:test/test.dart';

void main() {
  group('OptionArgument', () {
    group('String', () {
      test('null ArgResults', () {
        const OptionArgument<String?> argument =
            OptionArgument<String?>(name: 'option');
        argument.add(ArgParser());
        expect(argument.parse(null), null);
      });

      group('no default value', () {
        _testOptionArgument(
          argument: const OptionArgument<String?>(name: 'option', abbr: 'o'),
          mocks: <Iterable<String>, String?>{
            <String>['--option', 'test']: 'test',
            <String>['-o', 'test']: 'test',
            <String>['test', 'test']: null,
            <String>['']: null,
          },
        );
      });

      group('with default value', () {
        _testOptionArgument(
          argument: const OptionArgument<String?>(
              name: 'option', abbr: 'o', defaultsTo: 'dart_cmder'),
          mocks: <Iterable<String>, String?>{
            <String>['--option', 'test']: 'test',
            <String>['-o', 'test']: 'test',
            <String>['test', 'test']: 'dart_cmder',
            <String>['']: 'dart_cmder',
          },
        );
      });
    });

    group('enum', () {
      group('no default value - no value builder', () {
        _testOptionArgument(
          argument: const OptionArgument<Mode?>(name: 'mode', abbr: 'm'),
          mocks: <Iterable<String>, Mode?>{
            <String>['--mode', Mode.release.name]: null,
            <String>['-m', Mode.release.name]: null,
            <String>['test', Mode.release.name]: null,
            <String>['']: null,
          },
        );
      });

      group('with default value - no value builder', () {
        _testOptionArgument(
          argument: const OptionArgument<Mode>(
              name: 'mode', abbr: 'm', defaultsTo: Mode.debug),
          mocks: <Iterable<String>, Mode>{
            <String>['--mode', Mode.release.name]: Mode.debug,
            <String>['-m', Mode.release.name]: Mode.debug,
            <String>['test', Mode.release.name]: Mode.debug,
            <String>['']: Mode.debug,
          },
        );
      });

      group('no default value & value builder', () {
        _testOptionArgument(
          argument: OptionArgument<Mode>(
            name: 'mode',
            abbr: 'm',
            valueBuilder: (Object? m) {
              return Mode.values
                      .where((Mode mode) => m.toString() == mode.name)
                      .firstOrNull ??
                  Mode.debug;
            },
          ),
          mocks: <Iterable<String>, Mode>{
            <String>['--mode', Mode.release.name]: Mode.release,
            <String>['-m', Mode.release.name]: Mode.release,
            <String>['test', Mode.release.name]: Mode.debug,
            <String>['']: Mode.debug,
          },
        );
      });

      group('with default value & value builder', () {
        _testOptionArgument(
          argument: OptionArgument<Mode>(
            name: 'mode',
            abbr: 'm',
            defaultsTo: Mode.debug,
            valueBuilder: (Object? m) {
              return Mode.values
                      .where((Mode mode) => m.toString() == mode.name)
                      .firstOrNull ??
                  Mode.debug;
            },
          ),
          mocks: <Iterable<String>, Mode>{
            <String>['--mode', Mode.release.name]: Mode.release,
            <String>['-m', Mode.release.name]: Mode.release,
            <String>['test', Mode.release.name]: Mode.debug,
            <String>['']: Mode.debug,
          },
        );
      });
    });
  });
}

enum Mode { debug, release }

void _testOptionArgument<T>({
  required final Map<Iterable<String>, T> mocks,
  required final OptionArgument<T> argument,
}) {
  for (final MapEntry<Iterable<String>, T> mock in mocks.entries) {
    test('${mock.key} --> ${mock.value}', () {
      final ArgParser parser = ArgParser();
      argument.add(parser);
      final ArgResults results = parser.parse(mock.key);
      expect(argument.parse(results), mock.value);
    });
  }
}
