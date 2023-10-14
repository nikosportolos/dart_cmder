import 'dart:io' show Directory, exit;

import 'package:ansix/ansix.dart';
import 'package:args/command_runner.dart';
import 'package:dart_cmder/dart_cmder.dart';
import 'package:meta/meta.dart';
import 'package:trace/trace.dart';

/// An extended [Command] interface.
abstract class BaseCommand extends Command<void> {
  BaseCommand({
    this.arguments = const <BaseArgument<void>>[],
    final List<BaseCommand> subCommands = const <BaseCommand>[],
    this.filter,
  }) {
    _stopwatch.start();

    // Add subcommands
    for (final BaseCommand cmd in subCommands) {
      addSubcommand(cmd);
    }

    // Add and parse arguments
    argParser.addArguments(<BaseArgument<dynamic>>[
      ...arguments,
      ...cmderArguments,
    ]);
  }

  final List<BaseArgument<void>> arguments;
  late final LogFilter? filter;

  final Stopwatch _stopwatch = Stopwatch();

  /// Project root path argument.
  ///
  /// Defaults to `.`
  static const BaseArgument<String> pathArg = OptionArgument<String>(
    name: 'path',
    abbr: 'p',
    help: 'The root path of the project where the pubspec.yaml is.',
    defaultsTo: '.',
  );

  /// Log level argument.
  ///
  /// Defaults to `LogLevel.info`
  static const BaseArgument<LogLevel> logLevelArg = EnumArgument<LogLevel>(
    name: 'level',
    abbr: 'l',
    help: 'Define the level that will be used to filter log messages.',
    defaultsTo: LogLevel.info,
    allowedValues: LogLevel.values,
  );

  /// Log to file argument.
  ///
  /// If this argument flag is not null, then a [FileLogger] will be used
  /// to log messages into the specified directory.
  ///
  /// Defaults to `null`
  static const BaseArgument<Directory> logDirectoryArg = DirectoryArgument(
    name: 'logdir',
    abbr: 'd',
    help: 'If not null, then messages will be '
        'logged into the specified directory.',
    defaultsTo: null,
  );

  /// Colored text.
  ///
  /// If set to false, no colors will be printed in the console.
  ///
  /// Defaults to `true`
  static const FlagArgument colorArg = FlagArgument(
    name: 'color',
    abbr: 'c',
    negatable: true,
    help: 'If set to false, no colors will be printed in the console.',
    defaultsTo: true,
  );

  static const List<BaseArgument<void>> cmderArguments = <BaseArgument<void>>[
    pathArg,
    logLevelArg,
    logDirectoryArg,
    colorArg,
  ];

  String? get path => pathArg.parse(argResults);

  LogLevel get logLevel => logLevelArg.parse(argResults);

  Directory? get logsDirectory => logDirectoryArg.parse(argResults);

  bool get colored => colorArg.parse(argResults);

  Future<void> init() async {
    final bool allowColors = colorArg.parse(argResults);
    Trace.toggleAnsiFormatting(allowColors);

    final BaseRunner cliRunner = runner as BaseRunner;
    final LogFilter logFilter =
        filter ?? DefaultLogFilter(logLevel, debugOnly: false);

    Trace.registerLoggers(
      <Logger>[
        ConsoleLogger(
          level: logLevel,
          theme: cliRunner.loggerTheme,
          filter: logFilter,
        ),
        if (logsDirectory != null)
          FileLogger(
            level: logLevel,
            theme: cliRunner.loggerTheme,
            path: logsDirectory?.path,
            filter: logFilter,
          ),
      ],
    );

    cliRunner.printLogo();

    Trace.printListItem('Running command: ${name.bold()}');
  }

  Future<void> execute();

  @visibleForTesting
  @override
  Future<void> run() async {
    try {
      await init();
      await execute();
      hasRun = true;
    } catch (e, st) {
      await exitWithError(e, st);
    }

    // Ensure that dispose runs always
    try {
      await dispose();
      await exitWithCode(0);
    } catch (e, st) {
      await exitWithError(e, st);
    }
  }

  void printArguments() {
    final AnsiGrid grid = AnsiGrid.fromRows(
      <List<Object?>>[
        for (final BaseArgument<void> arg in <BaseArgument<void>>[
          ...arguments,
          ...cmderArguments
        ])
          <Object?>[
            '  - ',
            AnsiText(
              arg.name,
              foregroundColor: AnsiColor.dodgerBlue1,
              style: const AnsiTextStyle(bold: true),
              padding: AnsiPadding.only(right: 1),
            ),
            arg.parse(argResults),
          ]
      ],
      theme: const AnsiGridTheme(
        border: AnsiBorder(type: AnsiBorderType.none),
        keepSameWidth: false,
        overrideTheme: true,
      ),
    );

    Trace.verbose(grid);
  }

  Future<void> dispose() async {}

  /// Terminates the CLI app with a code.
  Future<void> exitWithCode(final int code) async {
    await _terminate(code: code);
  }

  /// Terminates the CLI app with errors.
  Future<void> exitWithError(final Object error, [final StackTrace? st]) async {
    hasErrors = true;
    await _terminate(error: error, stacktrace: st);
  }

  Future<void> _terminate({
    final int? code,
    final Object? error,
    final StackTrace? stacktrace,
  }) async {
    _stopwatch.stop();

    if (hasErrors) {
      Trace.error('${runner?.executableName.bold()} terminated with error:',
          error, stacktrace);
      Trace.error('❌ finished with errors in ${_stopwatch.elapsed}');
      await _exit(code ?? 1);
    }

    Trace.info('✔ ${invocation.bold()} finished in ${_stopwatch.elapsed}');
    await _exit(code ?? 0);
  }

  @visibleForTesting
  bool shouldSkipExit = false;

  @visibleForTesting
  bool hasRun = false;

  @visibleForTesting
  bool hasErrors = false;

  Future<void> _exit(final int code) async {
    if (shouldSkipExit) {
      return;
    }

    await Trace.dispose();
    exit(code);
  }
}
