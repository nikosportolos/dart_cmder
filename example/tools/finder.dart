// ignore_for_file: avoid_print

import 'dart:io';

import 'package:ansix/ansix.dart';
import 'package:dart_cmder/src/tools/finder.dart';
import 'package:path/path.dart';

void main() {
  final List<FileSystemEntity> files = Finder.findDartFiles(path: './lib');

  final AnsiGrid grid = AnsiGrid.list(
    files.map((FileSystemEntity e) {
      return normalize(e.path);
    }).toList(growable: false),
  );

  print(grid);
}
