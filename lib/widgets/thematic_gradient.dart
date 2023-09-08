import 'package:fluent_ui/fluent_ui.dart';

class ThematicGradientDecoration extends BoxDecoration {
  const ThematicGradientDecoration({
    super.color,
    super.image,
    super.border,
    super.borderRadius,
    super.boxShadow,
    super.gradient = const LinearGradient(
      colors: [Color.fromRGBO(32, 42, 51, 1), Color.fromRGBO(18, 21, 33, 1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    super.backgroundBlendMode,
    super.shape = BoxShape.rectangle,
  });
}
