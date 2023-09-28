import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_cmder/src/interface/arguments/multi_file.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('MultiFileArgument', () {
    group('null ArgResults', () {
      test('no default value', () {
        const MultiFileArgument argument = MultiFileArgument(name: 'file');
        argument.add(ArgParser());
        expect(argument.parse(null), <File>[]);
      });

      test('with default value', () {
        final MultiFileArgument argument = MultiFileArgument(
          name: 'file',
          defaultsTo: <File>[testFile],
        );
        argument.add(ArgParser());
        expect(argument.parse(null).length, 1);
        testFiles(testFile, argument.parse(null).first);
      });

      test('with allowed values & default value', () {
        final MultiFileArgument argument = MultiFileArgument(
          name: 'file',
          defaultsTo: <File>[testFile],
          allowedValues: <File>[rootFile, demoFile],
        );
        argument.add(ArgParser());
        expect(argument.parse(null).length, 1);
        testFiles(testFile, argument.parse(null).first);
      });

      test('with allowed values', () {
        final MultiFileArgument argument = MultiFileArgument(
          name: 'file',
          allowedValues: <File>[rootFile, demoFile],
        );
        argument.add(ArgParser());
        expect(argument.parse(null).length, 0);
      });
    });

    group('no default value', () {
      testMultiFileArgument(
        argument: const MultiFileArgument(name: 'file', abbr: 'f'),
        mocks: <Iterable<String>, List<File>?>{
          <String>['--file', 'test']: <File>[testFile],
          <String>['-f', 'test']: <File>[testFile],
          <String>['test', 'test']: <File>[],
          <String>['']: <File>[],
        },
      );
    });

    group('with default value', () {
      testMultiFileArgument(
        argument: MultiFileArgument(name: 'file', abbr: 'f', defaultsTo: <File>[testFile]),
        mocks: <Iterable<String>, List<File>?>{
          <String>['--file', 'test']: <File>[testFile],
          <String>['-f', 'test']: <File>[testFile],
          <String>['test', 'test']: <File>[testFile],
          <String>['']: <File>[testFile],
        },
      );
    });

    group('with value builder', () {
      testMultiFileArgument(
        argument: MultiFileArgument(
          name: 'file',
          abbr: 'f',
          valueBuilder: (Object? value) {
            return File(value.toString());
          },
        ),
        mocks: <Iterable<String>, List<File>?>{
          <String>['--file', 'test']: <File>[testFile],
          <String>['-f', 'test']: <File>[testFile],
          <String>['test', 'test']: <File>[],
          <String>['']: <File>[],
        },
      );
    });

    group('valueBuilder throws exception', () {
      testMultiFileArgument(
        argument: MultiFileArgument(
          name: 'file',
          abbr: 'f',
          valueBuilder: (Object? value) {
            throw Exception('test');
          },
        ),
        mocks: <Iterable<String>, List<File>?>{
          <String>['--file', 'test']: <File>[],
          <String>['-f', 'test']: <File>[],
          <String>['test', 'test']: <File>[],
          <String>['']: <File>[],
        },
      );
    });

    group('valueBuilder throws exception with default value', () {
      testMultiFileArgument(
        argument: MultiFileArgument(
          name: 'file',
          abbr: 'f',
          defaultsTo: <File>[testFile],
          valueBuilder: (Object? value) {
            throw Exception('test');
          },
        ),
        mocks: <Iterable<String>, List<File>?>{
          <String>['--file', 'test']: <File>[testFile],
          <String>['-f', 'test']: <File>[testFile],
          <String>['test', 'test']: <File>[testFile],
          <String>['']: <File>[testFile],
        },
      );
    });
  });
}
