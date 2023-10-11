import 'package:args/args.dart';
import 'package:dart_cmder/dart_cmder.dart';
import 'package:test/test.dart';

void main() {
  const FlagArgument arg1 = FlagArgument(name: 'arg1');
  const FlagArgument arg2 = FlagArgument(name: 'arg2');
  const FlagArgument arg3 = FlagArgument(name: 'arg3');

  group('extensions', () {
    group('ArgParserX', () {
      test('addArgument', () {
        final ArgParser parser = ArgParser();
        parser.addArgument(arg1);
        expect(parser.options.length, 1);
        expect(parser.options.containsKey(arg1.name), isTrue);
      });

      test('addArguments', () {
        final ArgParser parser = ArgParser();
        parser.addArguments(
          <BaseArgument<dynamic>>[arg2, arg3],
        );
        expect(parser.options.length, 2);
        expect(parser.options.containsKey(arg2.name), isTrue);
        expect(parser.options.containsKey(arg3.name), isTrue);
      });
    });
  });
}
