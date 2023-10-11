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

      expect(logo.formattedText, _simpleLogoMock);
      expect(logo.toString(), _simpleLogoMock);
    });

    test('fromText', () {
      final Logo logo = Logo.fromText(
        title: 'Title',
        subtitle: 'SubTitle',
      );

      expect(logo.formattedText, _fromTextLogoMock);
      expect(logo.toString(), _fromTextLogoMock);
    });
  });
}

const String _simpleLogoMock = '''
[0m┌────────┐
[0m│Title   │
[0m[0m│SubTitle│
[0m└────────┘''';

const String _fromTextLogoMock = '''
[0m┌────────────┐
[0m│   [1mTitle[22m    │
[0m[0m│  [3mSubTitle[23m  │
[0m└────────────┘''';
