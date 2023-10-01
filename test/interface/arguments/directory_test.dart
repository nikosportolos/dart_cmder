import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_cmder/dart_cmder.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('DirectoryArgument', () {
    group('null ArgResults', () {
      test('no default value', () {
        const DirectoryArgument argument = DirectoryArgument(name: 'dir');
        argument.add(ArgParser());
        expect(argument.parse(null), null);
      });

      test('with default value', () {
        final DirectoryArgument argument = DirectoryArgument(
          name: 'dir',
          defaultsTo: testDirectory,
        );
        argument.add(ArgParser());
        expect(argument.parse(null)?.path, testDirectory.path);
      });

      test('with allowed values & default value', () {
        final DirectoryArgument argument = DirectoryArgument(
          name: 'dir',
          defaultsTo: testDirectory,
          allowedValues: <Directory>[rootDirectory, demoDirectory],
        );
        argument.add(ArgParser());
        expect(argument.parse(null)?.path, testDirectory.path);
      });

      test('with allowed values', () {
        final DirectoryArgument argument = DirectoryArgument(
          name: 'dir',
          allowedValues: <Directory>[rootDirectory, demoDirectory],
        );
        argument.add(ArgParser());
        expect(argument.parse(null)?.path, null);
      });
    });

    group('no default value', () {
      testDirectoryArgument(
        argument: const DirectoryArgument(name: 'dir', abbr: 'd'),
        mocks: <Iterable<String>, Directory?>{
          <String>['--dir', 'test']: testDirectory,
          <String>['-d', 'test']: testDirectory,
          <String>['test', 'test']: null,
          <String>['']: null,
        },
      );
    });

    group('with default value', () {
      testDirectoryArgument(
        argument: DirectoryArgument(
            name: 'dir', abbr: 'd', defaultsTo: testDirectory),
        mocks: <Iterable<String>, Directory?>{
          <String>['--dir', 'test']: testDirectory,
          <String>['-d', 'test']: testDirectory,
          <String>['test', 'test']: testDirectory,
          <String>['']: testDirectory,
        },
      );
    });

    group('valueBuilder throws exception', () {
      testDirectoryArgument(
        argument: DirectoryArgument(
          name: 'dir',
          abbr: 'd',
          valueBuilder: (Object? value) {
            throw Exception('test');
          },
        ),
        mocks: <Iterable<String>, Directory?>{
          <String>['--dir', 'test']: null,
          <String>['-d', 'test']: null,
          <String>['test', 'test']: null,
          <String>['']: null,
        },
      );
    });

    group('valueBuilder throws exception with default value', () {
      testDirectoryArgument(
        argument: DirectoryArgument(
          name: 'dir',
          abbr: 'd',
          defaultsTo: testDirectory,
          valueBuilder: (Object? value) {
            throw Exception('test');
          },
        ),
        mocks: <Iterable<String>, Directory?>{
          <String>['--dir', 'test']: testDirectory,
          <String>['-d', 'test']: testDirectory,
          <String>['test', 'test']: testDirectory,
          <String>['']: testDirectory,
        },
      );
    });
  });
}
