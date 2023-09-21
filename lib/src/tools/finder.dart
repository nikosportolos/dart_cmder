import 'dart:io';

import 'package:ansix/ansix.dart';
import 'package:path/path.dart';

/// The Finder tool is an integral component of this package,
/// designed to streamline the process of locating and interacting with files and directories.
///
/// It provides a user-friendly class with a suite of convenient methods and frequently-used constants,
/// making it effortless to search for and work with files within your CLI application.
class Finder {
  static final RegExp arbMatchingPattern = RegExp(r'^[a-zA-Z0-9_]+.arb');
  static final RegExp dartMatchingPattern = RegExp(r'^[a-zA-Z0-9_]+.dart$');
  static final RegExp yamlMatchingPattern = RegExp(r'^[a-zA-Z0-9_]+.yaml$');

  static const String analysisOptionsFileName = 'analysis_options.yaml';
  static const String l10nYaml = 'l10n.yaml';
  static const String pubspecYaml = 'pubspec.yaml';

  static Directory findDirectoryFromPath(final String? path) {
    return path.isNullOrEmpty || path == '.' //
        ? Directory.current
        : path!.startsWith('./')
            ? Directory(
                join(Directory.current.path, normalize(path.substring(2))))
            : Directory(normalize(path));
  }

  static Iterable<File> _findFiles({
    final RegExp? matchingPattern,
    required final String path,
    final bool? recursive,
  }) {
    return Directory(path)
        .listSync(recursive: recursive ?? true, followLinks: true)
        .whereType<File>()
        .where((File file) => matchingPattern == null
            ? true
            : matchingPattern.hasMatch(basename(file.path)));
  }

  static List<FileSystemEntity> findFiles({
    final RegExp? matchingPattern,
    required final String path,
    final bool? recursive,
  }) {
    return _findFiles(
      matchingPattern: matchingPattern,
      path: path,
      recursive: recursive,
    ).toList(growable: false);
  }

  static List<String> findAbsoluteFilePaths({
    final RegExp? matchingPattern,
    required final String path,
    final bool? recursive,
  }) {
    return _findFiles(
      matchingPattern: matchingPattern,
      path: path,
      recursive: recursive,
    ) //
        .map((File file) => file.absolute.path)
        .toList(growable: false);
  }

  static List<FileSystemEntity> findArbFiles({
    required final String path,
    final bool? recursive,
  }) {
    return findFiles(
      matchingPattern: arbMatchingPattern,
      path: path,
      recursive: recursive,
    );
  }

  static List<FileSystemEntity> findDartFiles({
    required final String path,
    final bool? recursive,
  }) {
    return findFiles(
      matchingPattern: dartMatchingPattern,
      path: path,
      recursive: recursive,
    );
  }

  static List<FileSystemEntity> findYamlFiles({
    required final String path,
    final bool? recursive,
  }) {
    return findFiles(
      matchingPattern: yamlMatchingPattern,
      path: path,
      recursive: recursive,
    );
  }
}
