import 'package:ansix/ansix.dart';

class Logo {
  Logo({
    required this.title,
    this.subtitle,
    this.theme,
  }) {
    formatted = AnsiGrid.list(
      <Object?>[
        title,
        if (subtitle != null) subtitle,
      ],
      theme: theme ??
          const AnsiGridTheme(
            border: AnsiBorder(
              type: AnsiBorderType.outside,
            ),
            overrideTheme: true,
            cellTextTheme: AnsiTextTheme(
              alignment: AnsiTextAlignment.center,
            ),
            wrapText: true,
            wrapOptions: WrapOptions(lineLength: 80),
          ),
    ).formattedText;
  }

  final AnsiText title;
  final AnsiText? subtitle;
  final AnsiGridTheme? theme;

  late final String formatted;
}
