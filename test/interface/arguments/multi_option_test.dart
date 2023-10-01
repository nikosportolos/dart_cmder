import 'package:args/args.dart';
import 'package:dart_cmder/dart_cmder.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('MultiOptionArgument', () {
    test('null ArgResults', () {
      const MultiOptionArgument<String?> argument =
          MultiOptionArgument<String?>(name: 'option');
      argument.add(ArgParser());
      expect(argument.parse(null), <String?>[]);
    });

    group('String', () {
      group('no default value', () {
        testMultiOptionArgument(
          argument: const MultiOptionArgument<String?>(
            name: 'option',
            abbr: 'o',
          ),
          mocks: <Iterable<String>, List<String?>>{
            <String>['--option', 'test']: <String?>['test'],
            <String>['-o', 'test']: <String?>['test'],
            <String>['test', 'test']: <String?>[],
            <String>['']: <String?>[],
          },
        );
      });

      group('with default value', () {
        testMultiOptionArgument(
          argument: const MultiOptionArgument<String?>(
            name: 'option',
            abbr: 'o',
            defaultsTo: <String?>['dart_cmder'],
          ),
          mocks: <Iterable<String>, List<String?>>{
            <String>['--option', 'test']: <String?>['test'],
            <String>['-o', 'test']: <String?>['test'],
            <String>['test', 'test']: <String?>['dart_cmder'],
            <String>['']: <String?>['dart_cmder'],
          },
        );
      });

      group('valueBuilder throws exception', () {
        testMultiOptionArgument(
          argument: MultiOptionArgument<String?>(
            name: 'option',
            abbr: 'o',
            valueBuilder: (Object? value) {
              throw Exception('test');
            },
          ),
          mocks: <Iterable<String>, List<String?>?>{
            <String>['--option', 'test']: <String?>[],
            <String>['-o', 'test']: <String?>[],
            <String>['test', 'test']: <String?>[],
            <String>['']: <String?>[],
          },
        );
      });

      group('valueBuilder throws exception with default value', () {
        testMultiOptionArgument(
          argument: MultiOptionArgument<String?>(
            name: 'option',
            abbr: 'o',
            defaultsTo: <String?>['test'],
            valueBuilder: (Object? value) {
              throw Exception('test');
            },
          ),
          mocks: <Iterable<String>, List<String?>?>{
            <String>['--option', 'test']: <String?>['test'],
            <String>['-o', 'test']: <String?>['test'],
            <String>['test', 'test']: <String?>['test'],
            <String>['']: <String?>['test'],
          },
        );
      });
    });
  });
}
