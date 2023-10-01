# dart_cmder

## Tools

* [Tools](#tools)
  * [Logging](#logging)
  * [Finder](#finder)

---

### Logging

Effective logging is paramount in Command Line Interface (CLI) applications, as it provides
critical insights into program execution, aids in debugging, and offers transparency
to developers and users alike.
However, mere text-based logs may fall short in delivering a seamless user experience.

This package leverages two powerful tools to enhance your CLI application: [Trace](https://pub.dev/packages/trace)
for logging and [AnsiX](https://pub.dev/packages/ansix) for styling.

- **Trace** provides a logging framework, offering comprehensive visibility into the execution flow.
  It simplifies the process of debugging and monitoring your CLI app, as it provides.


- **AnsiX** introduces a rich palette of
  ANSI [styles](https://github.com/nikosportolos/ansix/blob/main/.documentation/features/theme.md#styles)
  and [colors](https://github.com/nikosportolos/ansix/blob/main/.documentation/features/theme.md#colors),
  along with versatile [widgets](https://github.com/nikosportolos/ansix/blob/main/.documentation/features/widgets.md#widgets)
  like [data grids](https://github.com/nikosportolos/ansix/blob/main/.documentation/features/widgets.md#ansigrid),
  [tree views](https://github.com/nikosportolos/ansix/blob/main/.documentation/features/widgets.md#ansitreeview),
  and [indented JSON representation](https://github.com/nikosportolos/ansix/blob/main/.documentation/features/print.md#printJson).

This combination empowers you to create visually appealing and feature-rich CLI interfaces,
making interactions with your application both efficient and visually engaging.

Explore the extensive capabilities of [Trace](https://github.com/nikosportolos/trace#examples) and
[AnsiX](https://github.com/nikosportolos/ansix#examples) to take your CLI application to the next level! 🚀


### Finder

The **Finder** tool 🔎 is an integral component of this package, designed to streamline
the process of locating and interacting with files and directories.

It provides a user-friendly class with a suite of convenient methods and frequently-used constants,
making it effortless to search for and work with files within your CLI application.

```dart
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
```


<a href="https://raw.githubusercontent.com/nikosportolos/dart_cmder/main/assets/images/finder-grid-example.webp" target="_blank">
  <img src="https://raw.githubusercontent.com/nikosportolos/dart_cmder/main/assets/images/finder-grid-example.webp" width="400" alt="finder-grid-example">
</a>


