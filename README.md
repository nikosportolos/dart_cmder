# dart_cmder

[![Pub Version](https://img.shields.io/pub/v/dart_cmder?color=blue&logo=dart)](https://pub.dev/packages/dart_cmder)
[![Pub Publisher](https://img.shields.io/pub/publisher/dart_cmder)](https://pub.dev/publishers/nikosportolos.com/packages)
[![Pub Points](https://img.shields.io/pub/points/dart_cmder?color=blue&logo=dart)](https://pub.dev/packages/dart_cmder)

[![Build](https://github.com/nikosportolos/dart_cmder/actions/workflows/build.yml/badge.svg)](https://github.com/nikosportolos/dart_cmder/actions/workflows/build.yml)
[![codecov](https://codecov.io/gh/nikosportolos/dart_cmder/graph/badge.svg?token=EA0DRM7F67)](https://codecov.io/gh/nikosportolos/dart_cmder)
[![Language](https://img.shields.io/badge/language-Dart-blue.svg)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)


This Dart package offers a streamlined and intuitive interface for building powerful 
Command Line Interface (CLI) applications. 

It comes bundled with an integrated logger ([Trace](https://pub.dev/packages/trace)), providing 
comprehensive visibility into the execution flow of your CLI apps. 

Additionally, the package provides a set of convenient out-of-the-box arguments, 
including the **project root path**, **log level**, and an optional 
**log files directory** to save your log files. 
These pre-defined arguments simplify the process of configuring and customizing your CLI applications. 

With this package, developers can effortlessly handle input, output, and essential configuration options, 
allowing them to focus on the core logic of their applications. 

Whether you're crafting a simple script or a complex command-line tool, 
this package empowers you to deliver seamless user experiences. 

Explore the documentation, check the [examples](example) and unleash the 
full potential of your CLI apps with **dart_cmder**.

> [You must obey the dart_cmder 🤘🏻🤪🤘🏻](https://youtu.be/BzabCVOBUJI?si=tHOwGNXcvCtUuWfs&t=4)


## Table of Contents

* [Getting started](#getting-started)
* [Interface](#interface)
  * [BaseRunner](#baserunner)
  * [BaseCommand](#basecommand)
  * [BaseArgument](#baseargument)
    * [FlagArgument](#flagargument)
    * [OptionArgument](#optionargument)
    * [MultiOptionArgument](#multioptionargument)
* [Tools](#tools)
  * [Logging](#logging)
  * [Finder](#finder)
* [Examples](#examples)
* [Contribution](#contribution)
* [Changelog](#changelog)


## Interface

### BaseRunner

An extended [CommandRunner](https://pub.dev/documentation/args/latest/command_runner/CommandRunner-class.html) 
interface that provides convenient methods and safe execution.

```dart
BaseRunner({
  required final String executableName,
  required final String description,
  required this.$commands,
  super.usageLineLength,
  super.suggestionDistanceLimit,
  this.sink,
  this.loggerTheme,
  this.logo,
  this.showLogo = true,
})
```

### BaseCommand

An extended [Command](https://pub.dev/documentation/args/latest/command_runner/Command-class.html) interface.

```dart
BaseCommand({
  this.arguments = const <BaseArgument<void>>[],
  final List<BaseCommand> subCommands = const <BaseCommand>[],
})
```

### BaseArgument

Base argument interface.

```dart
const BaseArgument({
  required this.name,
  this.abbr,
  this.help,
  this.allowedValues,
  this.aliases = const <String>[],
  this.hide = false,
  this.valueBuilder,
})
```

Each argument implements two methods:

- **add**

  This method adds an [Option](https://pub.dev/documentation/args/latest/args/Option-class.html)
  with the given properties to the options that have been defined for this parser.

  ```dart
  void add(final ArgParser parser)
  ```
  
- **parse**

  This method is used to parse the given [ArgResults](https://pub.dev/documentation/args/latest/args/ArgResults-class.html) 
  into a [BaseArgument](#baseargument).

  ```dart
  dynamic parse(final ArgResults? results)
  ```
  

#### FlagArgument

Defines a boolean flag.

```dart
const FlagArgument({
  required super.name,
  super.abbr,
  super.help,
  this.defaultsTo,
  this.negatable = true,
  super.aliases,
  super.hide = false,
  super.valueBuilder,
})
```

#### OptionArgument

Defines an option that takes a value.

```dart
const OptionArgument({
  required super.name,
  super.abbr,
  super.help,
  super.allowedValues,
  this.defaultsTo,
  this.valueHelp,
  this.mandatory = false,
  super.hide = false,
  this.allowedHelp,
  super.valueBuilder,
})
```

#### MultiOptionArgument

Defines an option that takes multiple values.

```dart
const MultiOptionArgument({
  required super.name,
  super.abbr,
  super.help,
  super.allowedValues,
  super.hide = false,
  super.aliases,
  this.defaultsTo,
  this.splitCommas = true,
  this.valueHelp,
  this.allowedHelp,
  super.valueBuilder,
})
```

## Tools

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


<a href="https://raw.githubusercontent.com/nikosportolos/dart_cmder/main/assets/images/finder-grid-example.png" target="_blank">
  <img src="https://raw.githubusercontent.com/nikosportolos/dart_cmder/main/assets/images/finder-grid-example.png" width="400" alt="finder-grid-example">
</a>


## Examples


## Contribution

Check the [contribution guide](https://github.com/nikosportolos/dart_cmder/tree/main/CONTRIBUTING.md)
if you want to help with **dart_cmder**.


## Changelog

Check the [changelog](https://github.com/nikosportolos/dart_cmder/tree/main/CHANGELOG.md)
to learn what's new in **dart_cmder**.
