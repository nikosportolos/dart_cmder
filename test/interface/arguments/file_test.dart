import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_cmder/dart_cmder.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('FileArgument', () {
    group('null ArgResults', () {
      test('no default value', () {
        const FileArgument argument = FileArgument(name: 'file');
        argument.addTo(ArgParser());
        expect(argument.parse(null), null);
      });

      test('with default value', () {
        final FileArgument argument = FileArgument(
          name: 'file',
          defaultsTo: testFile,
        );
        argument.addTo(ArgParser());
        expect(argument.parse(null)?.path, testFile.path);
      });

      test('with allowed values & default value', () {
        final FileArgument argument = FileArgument(
          name: 'file',
          defaultsTo: testFile,
          allowedValues: <File>[rootFile, demoFile],
        );
        argument.addTo(ArgParser());
        expect(argument.parse(null)?.path, testFile.path);
      });

      test('with allowed values', () {
        final FileArgument argument = FileArgument(
          name: 'file',
          allowedValues: <File>[rootFile, demoFile],
        );
        argument.addTo(ArgParser());
        expect(argument.parse(null)?.path, null);
      });
    });

    group('no default value', () {
      testFileArgument(
        argument: const FileArgument(name: 'file', abbr: 'f'),
        mocks: <Iterable<String>, File?>{
          <String>['--file', 'test']: testFile,
          <String>['-f', 'test']: testFile,
          <String>['test', 'test']: null,
          <String>['']: null,
        },
      );
    });

    group('with default value', () {
      testFileArgument(
        argument: FileArgument(name: 'file', abbr: 'f', defaultsTo: testFile),
        mocks: <Iterable<String>, File?>{
          <String>['--file', 'test']: testFile,
          <String>['-f', 'test']: testFile,
          <String>['test', 'test']: testFile,
          <String>['']: testFile,
        },
      );
    });

    group('valueBuilder throws exception', () {
      testFileArgument(
        argument: FileArgument(
          name: 'file',
          abbr: 'f',
          valueBuilder: (Object? value) {
            throw Exception('test');
          },
        ),
        mocks: <Iterable<String>, File?>{
          <String>['--file', 'test']: null,
          <String>['-f', 'test']: null,
          <String>['test', 'test']: null,
          <String>['']: null,
        },
      );
    });

    group('valueBuilder throws exception with default value', () {
      testFileArgument(
        argument: FileArgument(
          name: 'file',
          abbr: 'f',
          defaultsTo: testFile,
          valueBuilder: (Object? value) {
            throw Exception('test');
          },
        ),
        mocks: <Iterable<String>, File?>{
          <String>['--file', 'test']: testFile,
          <String>['-f', 'test']: testFile,
          <String>['test', 'test']: testFile,
          <String>['']: testFile,
        },
      );
    });
  });
}
