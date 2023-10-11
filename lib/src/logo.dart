import 'package:ansix/ansix.dart';

/// Represents the logo of a CLI app.
class Logo extends AnsiWidget {
  Logo({
    required this.title,
    this.subtitle,
    this.border,
    this.wrapOptions,
  }) {
    formattedText = AnsiGrid.list(
      <Object?>[
        title,
        if (subtitle != null) subtitle,
      ],
      theme: AnsiGridTheme(
        border: border ??
            const AnsiBorder(
              type: AnsiBorderType.outside,
            ),
        overrideTheme: true,
        cellTextTheme: const AnsiTextTheme(
          alignment: AnsiTextAlignment.center,
        ),
        wrapText: true,
        wrapOptions: wrapOptions ?? const WrapOptions(lineLength: 80),
      ),
    ).formattedText;
  }

  final AnsiText title;
  final AnsiText? subtitle;
  final AnsiBorder? border;
  final WrapOptions? wrapOptions;

  @override
  late final String formattedText;

  /// Returns a [Logo] using the default text styles.
  factory Logo.fromText({
    required final String title,
    final String? subtitle,
    final AnsiBorder? border,
    final WrapOptions? wrapOptions,
  }) {
    return Logo(
      title: AnsiText(
        title,
        style: const AnsiTextStyle(bold: true),
        padding: AnsiPadding.horizontal(2),
        alignment: AnsiTextAlignment.center,
      ),
      subtitle: subtitle == null
          ? null
          : AnsiText(
              subtitle,
              style: const AnsiTextStyle(italic: true),
              alignment: AnsiTextAlignment.center,
              padding: AnsiPadding.horizontal(2),
            ),
      border: border,
      wrapOptions: wrapOptions,
    );
  }
}
