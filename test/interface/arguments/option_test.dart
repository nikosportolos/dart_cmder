import 'package:args/args.dart';
import 'package:dart_cmder/dart_cmder.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('OptionArgument', () {
    group('String', () {
      group('null ArgResults', () {
        test('no default value', () {
          const OptionArgument<String?> argument = OptionArgument<String?>(name: 'option');
          argument.add(ArgParser());
          expect(argument.parse(null), null);
        });
        test('with default value', () {
          const OptionArgument<String?> argument = OptionArgument<String?>(
            name: 'option',
            defaultsTo: 'test',
          );
          argument.add(ArgParser());
          expect(argument.parse(null), 'test');
        });

        test('with allowed values & default value', () {
          const OptionArgument<String?> argument = OptionArgument<String?>(
            name: 'option',
            defaultsTo: 'test',
            allowedValues: <String?>['test', 'demo'],
          );
          argument.add(ArgParser());
          expect(argument.parse(null), testDirectory.path);
        });

        test('with allowed values', () {
          const OptionArgument<String?> argument = OptionArgument<String?>(
            name: 'option',
            allowedValues: <String?>['test', 'demo'],
          );
          argument.add(ArgParser());
          expect(argument.parse(null), null);
        });
      });

      group('no default value', () {
        testOptionArgument(
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
        testOptionArgument(
          argument:
              const OptionArgument<String?>(name: 'option', abbr: 'o', defaultsTo: 'dart_cmder'),
          mocks: <Iterable<String>, String?>{
            <String>['--option', 'test']: 'test',
            <String>['-o', 'test']: 'test',
            <String>['test', 'test']: 'dart_cmder',
            <String>['']: 'dart_cmder',
          },
        );
      });

      group('valueBuilder throws exception', () {
        testOptionArgument(
          argument: OptionArgument<String?>(
            name: 'option',
            abbr: 'o',
            valueBuilder: (Object? value) {
              throw Exception('test');
            },
          ),
          mocks: <Iterable<String>, String?>{
            <String>['--option', 'test']: null,
            <String>['-o', 'test']: null,
            <String>['test', 'test']: null,
            <String>['']: null,
          },
        );
      });

      group('valueBuilder throws exception with default value', () {
        testOptionArgument(
          argument: OptionArgument<String?>(
            name: 'option',
            abbr: 'o',
            defaultsTo: 'test',
            valueBuilder: (Object? value) {
              throw Exception('test');
            },
          ),
          mocks: <Iterable<String>, String?>{
            <String>['--option', 'test']: 'test',
            <String>['-o', 'test']: 'test',
            <String>['test', 'test']: 'test',
            <String>['']: 'test',
          },
        );
      });
    });
  });
}
