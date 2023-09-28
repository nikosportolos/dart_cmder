import 'package:args/args.dart';
import 'package:dart_cmder/dart_cmder.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('EnumArgument', () {
    group('null ArgResults', () {
      test('no default value', () {
        const OptionArgument<Mode?> argument = EnumArgument<Mode?>(name: 'mode');
        argument.add(ArgParser());
        expect(argument.parse(null), null);
      });

      test('with default value', () {
        const OptionArgument<Mode?> argument = EnumArgument<Mode?>(
          name: 'mode',
          defaultsTo: Mode.release,
        );
        argument.add(ArgParser());
        expect(argument.parse(null), Mode.release);
      });
    });

    group('no default value - no value builder', () {
      testOptionArgument(
        argument: const EnumArgument<Mode?>(name: 'mode', abbr: 'm'),
        mocks: <Iterable<String>, Mode?>{
          <String>['--mode', Mode.release.name]: Mode.release,
          <String>['-m', Mode.release.name]: Mode.release,
          <String>['test', Mode.release.name]: null,
          <String>['']: null,
        },
      );
    });

    group('with default value - no value builder', () {
      testOptionArgument(
        argument: const EnumArgument<Mode>(name: 'mode', abbr: 'm', defaultsTo: Mode.debug),
        mocks: <Iterable<String>, Mode>{
          <String>['--mode', Mode.release.name]: Mode.release,
          <String>['-m', Mode.release.name]: Mode.release,
          <String>['test', Mode.release.name]: Mode.debug,
          <String>['']: Mode.debug,
        },
      );
    });

    group('no default value & value builder', () {
      testOptionArgument(
        argument: EnumArgument<Mode>(
          name: 'mode',
          abbr: 'm',
          valueBuilder: (Object? m) {
            return Mode.values.where((Mode mode) => m.toString() == mode.name).firstOrNull ??
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
      testOptionArgument(
        argument: const EnumArgument<Mode>(
          name: 'mode',
          abbr: 'm',
          defaultsTo: Mode.debug,
          allowedValues: Mode.values,
          // valueBuilder: (Object? m) {
          //   return Mode.values
          //           .where((Mode mode) => m.toString() == mode.name)
          //           .firstOrNull ??
          //       Mode.debug;
          // },
        ),
        mocks: <Iterable<String>, Mode>{
          <String>['--mode', Mode.release.name]: Mode.release,
          <String>['-m', Mode.release.name]: Mode.release,
          <String>['test', Mode.release.name]: Mode.debug,
          <String>['']: Mode.debug,
        },
      );
    });

    group('valueBuilder throws exception', () {
      testOptionArgument(
        argument: EnumArgument<Mode>(
          name: 'mode',
          abbr: 'm',
          valueBuilder: (Object? value) {
            throw Exception('test');
          },
        ),
        mocks: <Iterable<String>, Mode?>{
          <String>['--mode', Mode.release.name]: null,
          <String>['-m', Mode.release.name]: null,
          <String>['test', Mode.release.name]: null,
          <String>['']: null,
        },
      );
    });

    group('valueBuilder throws exception with default value', () {
      testOptionArgument(
        argument: EnumArgument<Mode>(
          name: 'mode',
          abbr: 'm',
          defaultsTo: Mode.release,
          valueBuilder: (Object? value) {
            throw Exception('test');
          },
        ),
        mocks: <Iterable<String>, Mode?>{
          <String>['--mode', Mode.release.name]: Mode.release,
          <String>['-m', Mode.release.name]: Mode.release,
          <String>['test', 'test']: Mode.release,
          <String>['']: Mode.release,
        },
      );
    });
  });
}
