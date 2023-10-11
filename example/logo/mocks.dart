import 'package:dart_cmder/src/interface/command.dart';

const String title = 'My Dart CLI App';
const String commandName = 'demo';

class DemoCommand extends BaseCommand {
  @override
  Future<void> execute() async {}

  @override
  String get name => commandName;

  @override
  String get description => 'This is a demo command.';
}
