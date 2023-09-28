import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_cmder/src/interface/arguments/multi_directory.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('MultiDirectoryArgument', () {
    group('null ArgResults', () {
      test('no default value', () {
        const MultiDirectoryArgument argument = MultiDirectoryArgument(name: 'dir');
        argument.add(ArgParser());
        expect(argument.parse(null), <Directory>[]);
      });

      test('with default value', () {
        final MultiDirectoryArgument argument = MultiDirectoryArgument(
          name: 'dir',
          defaultsTo: <Directory>[testDirectory],
        );
        argument.add(ArgParser());
        expect(argument.parse(null).length, 1);
        testDirectories(testDirectory, argument.parse(null).first);
      });

      test('with allowed values & default value', () {
        final MultiDirectoryArgument argument = MultiDirectoryArgument(
          name: 'dir',
          defaultsTo: <Directory>[testDirectory],
          allowedValues: <Directory>[rootDirectory, demoDirectory],
        );
        argument.add(ArgParser());
        expect(argument.parse(null).length, 1);
        testDirectories(testDirectory, argument.parse(null).first);
      });

      test('with allowed values', () {
        final MultiDirectoryArgument argument = MultiDirectoryArgument(
          name: 'dir',
          allowedValues: <Directory>[rootDirectory, demoDirectory],
        );
        argument.add(ArgParser());
        expect(argument.parse(null).length, 0);
      });
    });

    group('no default value', () {
      testMultiDirectoryArgument(
        argument: const MultiDirectoryArgument(name: 'dir', abbr: 'd'),
        mocks: <Iterable<String>, List<Directory>?>{
          <String>['--dir', 'test']: <Directory>[testDirectory],
          <String>['-d', 'test']: <Directory>[testDirectory],
          <String>['test', 'test']: <Directory>[],
          <String>['']: <Directory>[],
        },
      );
    });

    group('with default value', () {
      testMultiDirectoryArgument(
        argument:
            MultiDirectoryArgument(name: 'dir', abbr: 'd', defaultsTo: <Directory>[testDirectory]),
        mocks: <Iterable<String>, List<Directory>?>{
          <String>['--dir', 'test']: <Directory>[testDirectory],
          <String>['-d', 'test']: <Directory>[testDirectory],
          <String>['test', 'test']: <Directory>[testDirectory],
          <String>['']: <Directory>[testDirectory],
        },
      );
    });

    group('with value builder', () {
      testMultiDirectoryArgument(
        argument: MultiDirectoryArgument(
          name: 'dir',
          abbr: 'd',
          valueBuilder: (Object? value) {
            return Directory(value.toString());
          },
        ),
        mocks: <Iterable<String>, List<Directory>?>{
          <String>['--dir', 'test']: <Directory>[testDirectory],
          <String>['-d', 'test']: <Directory>[testDirectory],
          <String>['test', 'test']: <Directory>[],
          <String>['']: <Directory>[],
        },
      );
    });

    group('valueBuilder throws exception', () {
      testMultiDirectoryArgument(
        argument: MultiDirectoryArgument(
          name: 'dir',
          abbr: 'd',
          valueBuilder: (Object? value) {
            throw Exception('test');
          },
        ),
        mocks: <Iterable<String>, List<Directory>?>{
          <String>['--dir', 'test']: <Directory>[],
          <String>['-d', 'test']: <Directory>[],
          <String>['test', 'test']: <Directory>[],
          <String>['']: <Directory>[],
        },
      );
    });

    group('valueBuilder throws exception with default value', () {
      testMultiDirectoryArgument(
        argument: MultiDirectoryArgument(
          name: 'dir',
          abbr: 'd',
          defaultsTo: <Directory>[testDirectory],
          valueBuilder: (Object? value) {
            throw Exception('test');
          },
        ),
        mocks: <Iterable<String>, List<Directory>?>{
          <String>['--dir', 'test']: <Directory>[testDirectory],
          <String>['-d', 'test']: <Directory>[testDirectory],
          <String>['test', 'test']: <Directory>[testDirectory],
          <String>['']: <Directory>[testDirectory],
        },
      );
    });
  });
}
