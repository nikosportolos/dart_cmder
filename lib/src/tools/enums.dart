import 'dart:mirrors';

extension TypeX on Type {
  bool get isEnum => reflectClass(this).isEnum;
}

extension EnumX on Object? {
  bool get isEnum => reflectClass(runtimeType).isEnum;

  T? toNullableEnum<T>(final T? defaultValue) {
    final List<T> enumValues = getEnumValues<T>();

    for (final T value in enumValues) {
      if (_toEnumString == value._toEnumString) {
        return value;
      }
    }

    return defaultValue;
  }

  T toEnum<T>(final T? defaultValue) {
    final List<T> enumValues = getEnumValues<T>();

    for (final T value in enumValues) {
      if (_toEnumString == value._toEnumString) {
        return value;
      }
    }

    return defaultValue ?? enumValues.first;
  }

  List<T> getEnumValues<T>() {
    return reflectClass(T).getField(const Symbol('values')).reflectee;
  }

  List<String> getEnumValueStrings<T>() {
    final List<T> values = reflectClass(T) //
        .getField(const Symbol('values'))
        .reflectee;

    return values
        .map((T value) => reflect(value)
            .invoke(const Symbol('toString'), <T>[])
            .reflectee
            .toString()
            ._toEnumString)
        .toList(growable: false);
  }

  String get _toEnumString {
    return toString().split('.').last;
  }
}
