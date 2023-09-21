import 'dart:io';

import 'package:ansix/ansix.dart';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dart_cmder/src/arguments/argument.dart';
import 'package:dart_cmder/src/extensions.dart';
import 'package:meta/meta.dart';
import 'package:trace/trace.dart';

abstract class BaseCommand extends Command<void> {
  BaseCommand() {
    for (BaseArgument arg in arguments) {
      arg.add(argParser);
    }
  }

  List<BaseArgument> get arguments;

  final Stopwatch _stopwatch = Stopwatch();
  bool _hasErrors = false;

  bool get hasErrors => _hasErrors;

  static const BaseArgument pathArg = OptionArgument(
    name: 'path',
    abbr: 'p',
    help: 'The root path of the project where the pubspec.yaml is.',
    defaultsTo: '.',
  );

  static final BaseArgument logLevelArg = MultiOptionArgument(
    name: 'level',
    abbr: 'l',
    help: 'Define log level.',
    defaultsTo: [LogLevel.info],
    allowedValues: LogLevel.values.map((LogLevel l) => l.name),
  );

  static const BaseArgument logToFileArg = FlagArgument(
    name: 'file',
    abbr: 'f',
    help: 'Log messages to file.',
    defaultsTo: false,
  );

  static final List<BaseArgument> cmderArguments = <BaseArgument>[pathArg, logLevelArg, logToFileArg];

  String? get path => argResults.getValue<String>(pathArg);

  LogLevel get logLevel => argResults.getValue<LogLevel>(logLevelArg);

  bool get logToFile => argResults.getValue<bool>(logToFileArg);

  @override
  String get invocation => '${runner?.executableName} $name [arguments]';

  Future<void> init() async {
    Trace.info(
      AnsiGrid.list(
        <AnsiText>[
          AnsiText(
            name.toUpperCase().split('').join(' '),
            foregroundColor: AnsiColor.deepSkyBlue2,
            alignment: AnsiTextAlignment.center,
          ),
          AnsiText(description,
              foregroundColor: AnsiColor.deepSkyBlue5,
              padding: AnsiPadding.horizontal(4),
              alignment: AnsiTextAlignment.center,
              style: const AnsiTextStyle(italic: true)),
        ],
        theme: const AnsiGridTheme(
          border: AnsiBorder(
            style: AnsiBorderStyle.rounded,
            type: AnsiBorderType.outside,
            color: AnsiColor.white,
          ),
        ),
      ),
    );

    Trace.debug('> Running command: ${name.bold()}');
    Trace.verbose(argParser.options.entries.map((MapEntry<String, Option> e) {
      return e.value;
    }));
  }

  Future<void> execute();

  Future<void> dispose() async {}

  @visibleForTesting
  @override
  Future<void> run() async {
    _stopwatch.start();

    try {
      await init();
      await execute();
    } catch (e, st) {
      exitWithError(e, st);
    }

    // Ensure that dispose runs always
    try {
      await dispose();
    } catch (e, st) {
      exitWithError(e, st);
    }

    _terminate();
  }

  void exitWithCode(final int code) {
    _terminate(code: code);
  }

  void exitWithError(final Object error, [final StackTrace? st]) {
    _hasErrors = true;
    _terminate(error: error, stacktrace: st);
  }

  void _terminate({
    final int? code,
    final Object? error,
    final StackTrace? stacktrace,
  }) {
    _stopwatch.stop();

    if (_hasErrors) {
      Trace.error('${runner?.executableName.bold()} terminated with error:', error, stacktrace);
      Trace.debug('❌ finished with errors in ${_stopwatch.elapsed}');
      exit(code ?? 1);
    }

    Trace.debug('\n✔ ${invocation.bold()} finished in ${_stopwatch.elapsed}'.green());
    exit(code ?? 0);
  }
}
