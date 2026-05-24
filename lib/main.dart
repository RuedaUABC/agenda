import 'package:agenda/core/theme/app_theme.dart';
import 'package:agenda/core/app/app_restart_scope.dart';
import 'package:agenda/features/configuracion/preferences_helper.dart';
import 'package:agenda/features/configuracion/presentation/settings_controller.dart';
import 'package:agenda/features/navegacion/presentation/navegacion.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const AppRestartScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  final Widget? home;
  final SettingsController? settingsController;

  const MyApp({super.key, this.home, this.settingsController});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SettingsController? _settingsController;

  SettingsController? get _activeController {
    return widget.settingsController ?? _settingsController;
  }

  @override
  void initState() {
    super.initState();
    widget.settingsController?.addListener(_onSettingsChanged);
    if (widget.settingsController == null) {
      _loadSettings();
    }
  }

  @override
  void didUpdateWidget(covariant MyApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.settingsController?.removeListener(_onSettingsChanged);
    widget.settingsController?.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    widget.settingsController?.removeListener(_onSettingsChanged);
    _settingsController?.removeListener(_onSettingsChanged);
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = PreferencesHelper();
    await prefs.init();
    final controller = SettingsController(prefs: prefs);
    await controller.loadSettings();
    controller.addListener(_onSettingsChanged);
    if (mounted) {
      setState(() => _settingsController = controller);
    }
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = _activeController;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: controller?.themeMode ?? ThemeMode.system,
      home:
          widget.home ??
          AgendaNavigation(
            settingsController: controller,
            initialIndex: controller?.initialNavigationIndex,
          ),
    );
  }
}
