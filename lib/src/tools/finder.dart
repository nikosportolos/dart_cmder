import 'dart:io';

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

  static const String analysisOptionsYaml = 'analysis_options.yaml';
  static const String l10nYaml = 'l10n.yaml';
  static const String pubspecYaml = 'pubspec.yaml';
  static const String pubspecLock = 'pubspec.lock';

  /// Returns the Directory of the given path.
  static Directory findDirectoryFromPath(final String? path) {
    if (path == null || path.trim().isEmpty) {
      return Directory.current;
    }

    return Directory(
      normalize(join(current, path)),
    );
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

  /// Returns a list of files found in the given [path].
  static List<File> findFiles({
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

  /// Returns a list of the absolute file paths
  /// found in the given [path].
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

  /// Returns a list of `.arb` files found in the given [path].
  static List<File> findArbFiles({
    required final String path,
    final bool? recursive,
  }) {
    return findFiles(
      matchingPattern: arbMatchingPattern,
      path: path,
      recursive: recursive,
    );
  }

  /// Returns a list of `.dart` files found in the given [path].
  static List<File> findDartFiles({
    required final String path,
    final bool? recursive,
  }) {
    return findFiles(
      matchingPattern: dartMatchingPattern,
      path: path,
      recursive: recursive,
    );
  }

  /// Returns a list of `.yaml` files found in the given [path].
  static List<File> findYamlFiles({
    required final String path,
    final bool? recursive,
  }) {
    return findFiles(
      matchingPattern: yamlMatchingPattern,
      path: path,
      recursive: recursive,
    );
  }

  /// Returns a list of `pubspec.yaml` files found in the given [path].
  static List<File> findPubspecYamlFiles({
    required final String path,
    final bool? recursive,
  }) {
    return findFiles(
      matchingPattern: RegExp('$pubspecYaml\$'),
      path: path,
      recursive: recursive,
    ).toList(growable: false);
  }

  /// Returns a list of `pubspec.lock` files found in the given [path].
  static List<File> findPubspecLockFiles({
    required final String path,
    final bool? recursive,
  }) {
    return findFiles(
      matchingPattern: RegExp('$pubspecLock\$'),
      path: path,
      recursive: recursive,
    ).toList(growable: false);
  }
}
