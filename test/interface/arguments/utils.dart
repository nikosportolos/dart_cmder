import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_cmder/src/interface/arguments/arguments.dart';
import 'package:test/test.dart';

enum Mode { debug, release, stage }

final Directory rootDirectory = Directory('.');
final Directory testDirectory = Directory('test');
final Directory demoDirectory = Directory('demo');

final File rootFile = File('.');
final File testFile = File('test');
final File demoFile = File('demo');

void testOptionArgument<T>({
  required final Map<Iterable<String>, T> mocks,
  required final OptionArgument<T> argument,
}) {
  for (final MapEntry<Iterable<String>, T> mock in mocks.entries) {
    test('${mock.key} --> ${mock.value}', () {
      final ArgParser parser = ArgParser();
      argument.addTo(parser);
      final ArgResults results = parser.parse(mock.key);
      expect(argument.parse(results), mock.value);
    });
  }
}

void testDirectoryArgument({
  required final Map<Iterable<String>, Directory?> mocks,
  required final DirectoryArgument argument,
}) {
  for (final MapEntry<Iterable<String>, Directory?> mock in mocks.entries) {
    test('${mock.key} --> ${mock.value}', () {
      final ArgParser parser = ArgParser();
      argument.addTo(parser);
      final ArgResults results = parser.parse(mock.key);
      expect(argument.parse(results)?.absolute.path, mock.value?.absolute.path);
    });
  }
}

void testFileArgument({
  required final Map<Iterable<String>, File?> mocks,
  required final FileArgument argument,
}) {
  for (final MapEntry<Iterable<String>, File?> mock in mocks.entries) {
    test('${mock.key} --> ${mock.value}', () {
      final ArgParser parser = ArgParser();
      argument.addTo(parser);
      final ArgResults results = parser.parse(mock.key);
      expect(argument.parse(results)?.absolute.path, mock.value?.absolute.path);
    });
  }
}

typedef MultiOptionArgumentMock<T> = Map<Iterable<String>, List<T>?>;

void testMultiOptionArgument<T>({
  required final MultiOptionArgumentMock<T> mocks,
  required final MultiOptionArgument<T> argument,
}) {
  for (final MapEntry<Iterable<String>, Iterable<dynamic>?> mock
      in mocks.entries) {
    test('${mock.key} --> ${mock.value}', () {
      final ArgParser parser = ArgParser();
      argument.addTo(parser);
      final ArgResults results = parser.parse(mock.key);
      expect(argument.parse(results), mock.value);
    });
  }
}

void testMultiFileArgument({
  required final MultiOptionArgumentMock<File> mocks,
  required final MultiOptionArgument<File> argument,
}) {
  for (final MapEntry<Iterable<String>, List<File>?> mock in mocks.entries) {
    test('${mock.key} --> ${mock.value}', () {
      final ArgParser parser = ArgParser();
      argument.addTo(parser);
      final ArgResults results = parser.parse(mock.key);
      final List<File> actual = argument.parse(results);
      expect(actual.length, mock.value?.length);

      for (int i = 0; i < actual.length; i++) {
        testFiles(actual[i], mock.value![i]);
      }
    });
  }
}

void testMultiDirectoryArgument({
  required final MultiOptionArgumentMock<Directory> mocks,
  required final MultiOptionArgument<Directory> argument,
}) {
  for (final MapEntry<Iterable<String>, List<Directory>?> mock
      in mocks.entries) {
    test('${mock.key} --> ${mock.value}', () {
      final ArgParser parser = ArgParser();
      argument.addTo(parser);
      final ArgResults results = parser.parse(mock.key);
      final List<Directory> actual = argument.parse(results);
      expect(actual.length, mock.value?.length);

      for (int i = 0; i < actual.length; i++) {
        testDirectories(actual[i], mock.value![i]);
      }
    });
  }
}

void testDirectories(final Directory a, final Directory b) {
  expect(a.absolute.path, b.absolute.path);
}

void testFiles(final File a, final File b) {
  expect(a.absolute.path, b.absolute.path);
}
