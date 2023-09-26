import 'dart:developer';
import 'dart:io' show exit;

import 'package:ansix/ansix.dart';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dart_cmder/src/interface/arguments/argument.dart';
import 'package:dart_cmder/src/interface/runner.dart';
import 'package:meta/meta.dart';
import 'package:trace/trace.dart';

/// An extended [Command] interface.
abstract class BaseCommand extends Command<void> {
  BaseCommand({
    this.arguments = const <BaseArgument<void>>[],
    final List<BaseCommand> subCommands = const <BaseCommand>[],
  }) {
    _stopwatch.start();

    // Add subcommands
    for (final BaseCommand cmd in subCommands) {
      addSubcommand(cmd);
    }

    // Add and parse arguments
    for (BaseArgument<void> arg in <BaseArgument<void>>[
      ...arguments,
      ...cmderArguments
    ]) {
      arg.add(argParser);
    }
  }

  final List<BaseArgument<void>> arguments;

  final Stopwatch _stopwatch = Stopwatch();

  /// Project root path argument.
  static const BaseArgument<String> pathArg = OptionArgument<String>(
    name: 'path',
    abbr: 'p',
    help: 'The root path of the project where the pubspec.yaml is.',
    defaultsTo: '.',
  );

  /// Log level argument.
  static final BaseArgument<LogLevel> logLevelArg = OptionArgument<LogLevel>(
    name: 'level',
    abbr: 'l',
    help: 'Define the level that will be used to filter log messages.',
    defaultsTo: LogLevel.info,
    allowedValues: LogLevel.values,
    valueBuilder: (Object? value) {
      return LogLevel.values
              .where((LogLevel l) => l.name == value)
              .firstOrNull ??
          LogLevel.verbose;
    },
  );

  /// Log to file argument.
  ///
  /// If this argument flag is not null, then a [FileLogger] will be used
  /// to log messages into the specified directory.
  static const BaseArgument<String?> logDirectoryArg = OptionArgument<String?>(
    name: 'logdir',
    abbr: 'd',
    help:
        'If not null, then messages will be logged into the specified directory.',
    defaultsTo: null,
  );

  static final List<BaseArgument<void>> cmderArguments = <BaseArgument<void>>[
    pathArg,
    logLevelArg,
    logDirectoryArg,
  ];

  String? get path => pathArg.parse(argResults);

  LogLevel get logLevel => logLevelArg.parse(argResults);

  String? get logsDirectory => logDirectoryArg.parse(argResults);

  Future<void> init() async {
    final BaseRunner cliRunner = runner as BaseRunner;

    Trace.registerLoggers(
      <Logger>[
        ConsoleLogger(
          level: logLevel,
          theme: cliRunner.loggerTheme,
          ioSink: cliRunner.sink,
          filter: DefaultLogFilter(
            logLevel,
            debugOnly: false,
          ),
        ),
        if (logsDirectory != null)
          FileLogger(
            level: logLevel,
            theme: cliRunner.loggerTheme,
            path: logsDirectory,
          ),
      ],
    );

    cliRunner.printLogo();

    Trace.printListItem('Running command: ${name.bold()}');
    argParser.options.entries.map((MapEntry<String, Option> e) {
      Trace.verbose(e.value.name);
    });
  }

  Future<void> execute();

  @visibleForTesting
  @override
  Future<void> run() async {
    try {
      await init();
      await execute();
    } catch (e, st) {
      await exitWithError(e, st);
    }

    // Ensure that dispose runs always
    try {
      await dispose();
      await exitWithCode(0);
    } catch (e, st) {
      await exitWithError(e, st);
      return;
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
    await _terminate(
      hasErrors: true,
      error: error,
      stacktrace: st,
    );
  }

  Future<void> _terminate({
    final int? code,
    final Object? error,
    final StackTrace? stacktrace,
    final bool hasErrors = false,
  }) async {
    _stopwatch.stop();

    if (hasErrors) {
      Trace.error('${runner?.executableName.bold()} terminated with error:',
          error, stacktrace);
      Trace.error('❌ finished with errors in ${_stopwatch.elapsed}');
      await _exit(code ?? 1);
    }

    Trace.debug('✔ ${invocation.bold()} finished in ${_stopwatch.elapsed}');
    await _exit(code ?? 0);
  }

  @visibleForTesting
  bool skipExit = false;

  Future<void> _exit(final int code) async {
    try {
      await Trace.dispose();
    } catch (e, st) {
      log('Failed to dispose Trace', error: e, stackTrace: st);
    }
    if (!skipExit) {
      exit(code);
    }
  }
}
