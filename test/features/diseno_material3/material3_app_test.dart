import 'package:agenda/core/theme/app_theme.dart';
import 'package:agenda/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'AppTheme define temas Material 3 claro y oscuro desde el mismo seed',
    () {
      final light = AppTheme.lightTheme;
      final dark = AppTheme.darkTheme;

      expect(light.useMaterial3, isTrue);
      expect(dark.useMaterial3, isTrue);
      expect(light.brightness, Brightness.light);
      expect(dark.brightness, Brightness.dark);
      expect(
        light.colorScheme.primary,
        isNot(equals(dark.colorScheme.primary)),
      );
      expect(light.scaffoldBackgroundColor, light.colorScheme.surface);
      expect(dark.scaffoldBackgroundColor, dark.colorScheme.surface);
    },
  );

  testWidgets('MyApp usa tema del sistema y titulo Agenda', (tester) async {
    await tester.pumpWidget(const MyApp(home: SizedBox.shrink()));

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(app.title, 'Agenda');
    expect(app.themeMode, ThemeMode.system);
    expect(app.theme, AppTheme.lightTheme);
    expect(app.darkTheme, AppTheme.darkTheme);
  });
}
