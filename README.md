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

* [Usage](#usage)
* Interface
  * [BaseRunner](./.documentation/runner.md#baserunner)
    * [Logo](./.documentation/runner.md#logo)
  * [BaseCommand](./.documentation/command.md#basecommand)
  * [BaseArgument](./.documentation/argument.md#baseargument)
    * [FlagArgument](./.documentation/argument.md#flagargument)
    * [OptionArgument](./.documentation/argument.md#optionargument)
      * [EnumArgument](./.documentation/argument.md#enumargument)
      * [FileArgument](./.documentation/argument.md#fileargument)
      * [DirectoryArgument](./.documentation/argument.md#directoryargument)
    * [MultiOptionArgument](./.documentation/argument.md#multioptionargument)
      * [MultiEnumArgument](./.documentation/argument.md#multioptionargument)
      * [MultiFileArgument](./.documentation/argument.md#multioptionargument)
      * [MultiDirectoryArgument](./.documentation/argument.md#multioptionargument)
* [Tools](./.documentation/tools.md#tools)
  * [Logging](./.documentation/tools.md#logging)
  * [Finder](./.documentation/tools.md#finder)
* [Usage](#usage)
* [Contribution](#contribution)
* [Changelog](#changelog)


## Usage


1. **Create a command with custom arguments**

```dart
class DemoCommand extends BaseCommand {
  DemoCommand({
    super.arguments = const <BaseArgument<void>>[],
    super.subCommands = const <BaseCommand>[],
  });

  @override
  String get name => 'cmd';

  @override
  String get description => 'This is a demo command';

  @override
  List<BaseArgument<void>> get arguments => <BaseArgument<void>>[enabledArg, inputArg, modeArg];

  static const FlagArgument enabledArg = FlagArgument(
    name: 'enabled',
    abbr: 'e',
    help: 'This is a demo flag argument',
  );

  static const OptionArgument<String> inputArg = OptionArgument<String>(
    name: 'input',
    abbr: 'i',
    help: 'This is a demo option argument',
    defaultsTo: 'default-input-value',
  );

  static const EnumArgument<Mode> modeArg = EnumArgument<Mode>(
    name: 'mode',
    abbr: 'm',
    help: 'This is a demo enum argument',
    defaultsTo: Mode.debug,
  );

  static const MultiEnumArgument<Feature> featureArg = MultiEnumArgument<Feature>(
    name: 'feature',
    abbr: 'f',
    help: 'This is a demo multi-option argument',
    defaultsTo: <Feature>[Feature.feat1],
  );

  Mode get mode => modeArg.parse(argResults)!;

  bool get enabled => enabledArg.parse(argResults);

  @override
  Future<void> execute() async {
    printArguments();

    Trace.info('Lorem ipsum dolor sit amet, consectetur adipiscing elit, \n'
            'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.');
  }
}  
```

2. **Create a runner**

```dart
class DemoRunner extends BaseRunner {
  DemoRunner({
    final List<BaseCommand> commands = const <BaseCommand>[],
  }) : super(
          executableName: 'demo',
          description: 'This is a demo CLI app written in Dart using dart_cmder.',
          $commands: <BaseCommand>[
            DemoCommand(),
            ...commands,
          ],
        );
}
```

3. **Run your CLI app**

```dart
import 'dart:io';
import 'package:trace/trace.dart';
import 'demo_runner.dart';

void main() {
  final List<String> args = <String>[
    'cmd',
    '--no-enabled',
    '-m',
    'option3',
    '-i',
    'Hello dart_cmder',
    '-l',
    LogLevel.verbose.name,
    '-d',
    '${Directory.current.path}/logs',
  ];

  DemoRunner().run(args);
}
```

<a href="https://raw.githubusercontent.com/nikosportolos/dart_cmder/main/assets/images/example.webp" target="_blank">
  <img src="https://raw.githubusercontent.com/nikosportolos/dart_cmder/main/assets/images/example.webp" width="750" alt="dart-cmder-example">
</a>

Check the [example](https://github.com/nikosportolos/dart_cmder/tree/main/example) 
folder for the complete CLI app samples.


## Contribution

Check the [contribution guide](https://github.com/nikosportolos/dart_cmder/tree/main/CONTRIBUTING.md)
if you want to help with **dart_cmder**.


## Changelog

Check the [changelog](https://github.com/nikosportolos/dart_cmder/tree/main/CHANGELOG.md)
to learn what's new in **dart_cmder**.

