import 'dart:io';

import 'package:dart_cmder/src/tools/finder.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  final String path = join(
    Directory.current.path,
    'test',
    'tools',
    'finder',
    'samples',
  );

  group('Finder', () {
    group('Find directory from path', () {
      test('empty', () {
        expect(Finder.findDirectoryFromPath('').path, Directory.current.path);
      });
      test('spaces', () {
        expect(Finder.findDirectoryFromPath('  ').path, Directory.current.path);
      });

      test('.', () {
        expect(Finder.findDirectoryFromPath('.').path, Directory.current.path);
      });

      test('./test/tools/finder/samples', () {
        expect(Finder.findDirectoryFromPath('./test/tools/finder/samples').path,
            path);
      });

      test(path, () {
        expect(Finder.findDirectoryFromPath(path).path, path);
      });
    });

    group('Find files', () {
      test('Find all files', () {
        final List<FileSystemEntity> files = Finder.findFiles(path: path);
        expect(files.length, 15);
      });

      test('Find all files - not recursive', () {
        final List<FileSystemEntity> files =
            Finder.findFiles(path: path, recursive: false);
        expect(files.length, 0);
        expect(
            Finder.findFiles(
                    path: join(path, 'project_1', 'lib'), recursive: false)
                .length,
            1);
      });

      test('Find dart files', () {
        final List<FileSystemEntity> files = Finder.findDartFiles(path: path);
        expect(files.length, 6);
      });

      test('Find arb files', () {
        final List<FileSystemEntity> files = Finder.findArbFiles(path: path);
        expect(files.length, 2);
      });

      test('Find yaml files', () {
        final List<FileSystemEntity> files = Finder.findYamlFiles(path: path);
        expect(files.length, 5);
      });

      test('Find pubspec.yaml files', () {
        final List<File> files = Finder.findPubspecYamlFiles(path: path);
        expect(files.length, 3);
      });

      test('Find pubspec.lock files', () {
        final List<File> files = Finder.findPubspecLockFiles(path: path);
        expect(files.length, 2);
      });

      test('Find analysis_options.yaml files', () {
        final List<FileSystemEntity> files = Finder.findFiles(
          path: path,
          matchingPattern: RegExp(Finder.analysisOptionsYaml),
        );
        expect(files.length, 1);
      });

      test('Find l10n.yaml files', () {
        final List<FileSystemEntity> files = Finder.findFiles(
          path: path,
          matchingPattern: RegExp(Finder.l10nYaml),
        );
        expect(files.length, 1);
      });

      test('Find absolute paths', () {
        final List<String> files = Finder.findAbsoluteFilePaths(path: path);
        expect(files.length, 15);
      });
    });
  });
}
