import 'package:args/args.dart';
import 'package:dart_cmder/dart_cmder.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('MultiEnumArgument', () {
    group('null ArgResults', () {
      test('no default value', () {
        const MultiEnumArgument<Mode> argument =
            MultiEnumArgument<Mode>(name: 'mode');
        argument.add(ArgParser());
        expect(argument.parse(null), <Mode>[]);
      });

      test('with default value', () {
        const MultiEnumArgument<Mode> argument = MultiEnumArgument<Mode>(
          name: 'mode',
          defaultsTo: <Mode>[Mode.release],
        );
        argument.add(ArgParser());
        final List<Mode> actual = argument.parse(null);
        expect(actual.length, 1);
        expect(Mode.release, actual.first);
      });

      test('with allowed values & default value', () {
        const MultiEnumArgument<Mode> argument = MultiEnumArgument<Mode>(
          name: 'mode',
          defaultsTo: <Mode>[Mode.release],
          allowedValues: <Mode>[Mode.release, Mode.stage],
        );
        argument.add(ArgParser());
        final List<Mode> actual = argument.parse(null);
        expect(actual.length, 1);
        expect(Mode.release, actual.first);
      });

      test('with allowed values', () {
        const MultiEnumArgument<Mode> argument = MultiEnumArgument<Mode>(
          name: 'mode',
          allowedValues: <Mode>[Mode.release, Mode.stage],
        );
        argument.add(ArgParser());
        expect(argument.parse(null).length, 0);
      });
    });

    group('no default value - no value builder', () {
      testMultiOptionArgument(
        argument: const MultiEnumArgument<Mode?>(name: 'mode', abbr: 'm'),
        mocks: <Iterable<String>, List<Mode>?>{
          <String>['--mode', Mode.release.name]: <Mode>[Mode.release],
          <String>['-m', Mode.release.name]: <Mode>[Mode.release],
          <String>['test', Mode.release.name]: <Mode>[],
          <String>['']: <Mode>[],
        },
      );
    });

    group('with default value - no value builder', () {
      testMultiOptionArgument(
        argument: const MultiEnumArgument<Mode>(
            name: 'mode', abbr: 'm', defaultsTo: <Mode>[Mode.debug]),
        mocks: <Iterable<String>, List<Mode>?>{
          <String>['--mode', Mode.release.name]: <Mode>[Mode.release],
          <String>['-m', Mode.release.name]: <Mode>[Mode.release],
          <String>['test', Mode.release.name]: <Mode>[Mode.debug],
          <String>['']: <Mode>[Mode.debug],
        },
      );
    });

    group('no default value & value builder', () {
      testMultiOptionArgument(
        argument: MultiEnumArgument<Mode>(
          name: 'mode',
          abbr: 'm',
          valueBuilder: (Object? m) {
            return Mode.values
                    .where((Mode mode) => m.toString() == mode.name)
                    .firstOrNull ??
                Mode.debug;
          },
        ),
        mocks: <Iterable<String>, List<Mode>?>{
          <String>['--mode', Mode.release.name]: <Mode>[Mode.release],
          <String>['-m', Mode.release.name]: <Mode>[Mode.release],
          <String>['test', Mode.release.name]: <Mode>[],
          <String>['']: <Mode>[],
        },
      );
    });

    group('with default value & value builder', () {
      testMultiOptionArgument(
        argument: MultiEnumArgument<Mode>(
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
        mocks: <Iterable<String>, List<Mode>?>{
          <String>['--mode', Mode.release.name]: <Mode>[Mode.release],
          <String>['-m', Mode.release.name]: <Mode>[Mode.release],
          <String>['test', Mode.release.name]: <Mode>[Mode.debug],
          <String>['']: <Mode>[Mode.debug],
        },
      );
    });

    group('valueBuilder throws exception', () {
      testMultiOptionArgument(
        argument: MultiEnumArgument<Mode>(
          name: 'mode',
          abbr: 'm',
          valueBuilder: (Object? value) {
            throw Exception('test');
          },
        ),
        mocks: <Iterable<String>, List<Mode>?>{
          <String>['--mode', Mode.release.name]: <Mode>[],
          <String>['-m', Mode.release.name]: <Mode>[],
          <String>['test', Mode.release.name]: <Mode>[],
          <String>['']: <Mode>[],
        },
      );
    });

    group('valueBuilder throws exception with default value', () {
      testMultiOptionArgument(
        argument: MultiEnumArgument<Mode>(
          name: 'mode',
          abbr: 'm',
          defaultsTo: <Mode>[Mode.release],
          valueBuilder: (Object? value) {
            throw Exception('test');
          },
        ),
        mocks: <Iterable<String>, List<Mode>?>{
          <String>['--mode', Mode.release.name]: <Mode>[Mode.release],
          <String>['-m', Mode.release.name]: <Mode>[Mode.release],
          <String>['test', Mode.release.name]: <Mode>[Mode.release],
          <String>['']: <Mode>[Mode.release],
        },
      );
    });
  });
}
