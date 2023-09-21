import 'package:ansix/ansix.dart';
import 'package:dart_cmder/src/logo.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Logo', () {
    test('simple', () {
      final Logo logo = Logo(
        title: AnsiText('Title'),
        subtitle: AnsiText('SubTitle'),
      );

      expect(logo.formatted, _simpleLogoMock);
    });
  });
}

const String _simpleLogoMock = '''
[0m┌────────┐
[0m│Title   │
[0m[0m│SubTitle│
[0m└────────┘''';
