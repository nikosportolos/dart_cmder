# dart_cmder

## Arguments

---

### Table of Contents

* [BaseArgument](#baseargument)
  * [FlagArgument](#flagargument)
  * [OptionArgument](#optionargument)
    * [EnumArgument](#enumargument)
    * [FileArgument](#fileargument)
    * [DirectoryArgument](#directoryargument)
  * [MultiOptionArgument](#multioptionargument)
    * [MultiEnumArgument](#multienumargument)
    * [MultiFileArgument](#multifileargument)
    * [MultiDirectoryArgument](#multidirectoryargument) 


---

### BaseArgument

Base argument interface.

```dart
const BaseArgument({
  required this.name,
  this.abbr,
  this.help,
  this.allowedValues,
  this.aliases = const <String>[],
  this.hide = false,
  this.valueBuilder,
})
```

Each argument implements two methods:

- **add**

  This method adds an [Option](https://pub.dev/documentation/args/latest/args/Option-class.html)
  with the given properties to the options that have been defined for this parser.

  ```dart
  void add(final ArgParser parser)
  ```
  
- **parse**

  This method is used to parse the given [ArgResults](https://pub.dev/documentation/args/latest/args/ArgResults-class.html) 
  into a [BaseArgument](#baseargument).

  ```dart
  dynamic parse(final ArgResults? results)
  ```

---

#### FlagArgument

Defines a boolean flag.

```dart
const FlagArgument({
  required super.name,
  super.abbr,
  super.help,
  this.defaultsTo,
  this.negatable = true,
  super.aliases,
  super.hide = false,
  super.valueBuilder,
})
```
---

#### OptionArgument

Defines an option that takes a value.

```dart
const OptionArgument({
  required super.name,
  super.abbr,
  super.help,
  super.allowedValues,
  this.defaultsTo,
  this.valueHelp,
  this.mandatory = false,
  super.hide = false,
  this.allowedHelp,
  super.valueBuilder,
})
```

##### EnumArgument

```dart
const EnumArgument({
  required super.name,
  super.abbr,
  super.help,
  super.allowedValues,
  super.defaultsTo,
  super.valueHelp,
  super.mandatory = false,
  super.hide = false,
  super.allowedHelp,
  super.valueBuilder,
})
```

##### FileArgument

```dart
const FileArgument({
  required super.name,
  super.abbr,
  super.help,
  super.allowedValues,
  super.defaultsTo,
  super.valueHelp,
  super.mandatory = false,
  super.hide = false,
  super.allowedHelp,
  super.valueBuilder,
})
```

##### DirectoryArgument

```dart
const DirectoryArgument({
  required super.name,
  super.abbr,
  super.help,
  super.allowedValues,
  super.defaultsTo,
  super.valueHelp,
  super.mandatory = false,
  super.hide = false,
  super.allowedHelp,
  super.valueBuilder,
})
```
---

#### MultiOptionArgument

Defines an option that takes multiple values.

```dart
const MultiOptionArgument({
  required super.name,
  super.abbr,
  super.help,
  super.allowedValues,
  super.hide = false,
  super.aliases,
  this.defaultsTo,
  this.splitCommas = true,
  this.valueHelp,
  this.allowedHelp,
  super.valueBuilder,
})
```

##### MultiEnumArgument

```dart
const MultiEnumArgument({
  required super.name,
  super.abbr,
  super.help,
  super.allowedValues,
  super.hide = false,
  super.aliases,
  super.defaultsTo,
  super.splitCommas = true,
  super.valueHelp,
  super.allowedHelp,
  super.valueBuilder,
})
```

##### MultiFileArgument

```dart
const MultiFileArgument({
  required super.name,
  super.abbr,
  super.help,
  super.allowedValues,
  super.hide = false,
  super.aliases,
  super.defaultsTo,
  super.splitCommas = true,
  super.valueHelp,
  super.allowedHelp,
  super.valueBuilder,
})
```

##### MultiDirectoryArgument

```dart
const MultiDirectoryArgument({
  required super.name,
  super.abbr,
  super.help,
  super.allowedValues,
  super.hide = false,
  super.aliases,
  super.defaultsTo,
  super.splitCommas = true,
  super.valueHelp,
  super.allowedHelp,
  super.valueBuilder,
})
```
