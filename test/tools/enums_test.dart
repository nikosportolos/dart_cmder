import 'package:dart_cmder/src/tools/enums.dart';
import 'package:test/test.dart';

void main() {
  group('enums', () {
    test('type - isEnum', () {
      expect(123.runtimeType.isEnum, false);
      expect(123.0.runtimeType.isEnum, false);
      expect('123123'.runtimeType.isEnum, false);
      expect(<void>[].runtimeType.isEnum, false);
      expect(<void>{}.runtimeType.isEnum, false);
      expect(false.runtimeType.isEnum, false);
      expect(Demo.value1.runtimeType.isEnum, true);
      expect(Demo.values.runtimeType.isEnum, false);
    });

    test('object - isEnum', () {
      expect(123.isEnum, false);
      expect(123.0.isEnum, false);
      expect('123123'.isEnum, false);
      expect(<void>[].isEnum, false);
      expect(<void>{}.isEnum, false);
      expect(false.isEnum, false);
      expect(Demo.value1.isEnum, true);
      expect(Demo.values.isEnum, false);
    });

    test('toEnum', () {
      expect(
        'value2'.toEnum<Demo>(Demo.value1),
        Demo.value2,
      );
      expect(
        'value3'.toEnum<Demo>(Demo.value1),
        Demo.value3,
      );
      expect(
        'value4'.toEnum<Demo>(Demo.value1),
        Demo.value1,
      );
      expect(
        'value4'.toEnum<Demo>(Demo.value1),
        Demo.value1,
      );
      expect(
        'value4'.toEnum<Demo>(null),
        Demo.value1,
      );
    });

    test('toNullableEnum', () {
      expect(
        'value2'.toNullableEnum<Demo>(Demo.value1),
        Demo.value2,
      );
      expect(
        'value3'.toNullableEnum<Demo>(Demo.value1),
        Demo.value3,
      );
      expect(
        'value4'.toNullableEnum<Demo>(Demo.value1),
        Demo.value1,
      );
      expect(
        'value4'.toNullableEnum<Demo>(null),
        null,
      );
    });

    test('getEnumValues', () {
      expect(
        Demo.value1.getEnumValues<Demo>(),
        Demo.values,
      );
    });
  });
}

enum Demo { value1, value2, value3 }
