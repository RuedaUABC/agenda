import 'package:agenda/core/app/app_restart_scope.dart';
import 'package:flutter/material.dart';

import '../preferences_helper.dart';
import 'settings_controller.dart';

class AdvancedSettingsWidget extends StatefulWidget {
  final SettingsController controller;
  final bool scrollable;

  const AdvancedSettingsWidget({
    super.key,
    required this.controller,
    this.scrollable = true,
  });

  @override
  State<AdvancedSettingsWidget> createState() => _AdvancedSettingsWidgetState();
}

class _AdvancedSettingsWidgetState extends State<AdvancedSettingsWidget> {
  SettingsController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SettingsSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(
                    icon: Icons.palette_outlined,
                    title: 'Apariencia',
                    subtitle: 'Tema, densidad y comportamiento visual',
                  ),
                  const SizedBox(height: 8),
                  _ThemeSelector(controller: controller),
                  const Divider(height: 1),
                  _DropdownPreference<InitialModulePreference>(
                    icon: Icons.home_outlined,
                    title: 'Vista inicial',
                    subtitle: 'Se aplicara al abrir Agenda',
                    value: controller.initialModule,
                    values: InitialModulePreference.values,
                    labelFor: _initialModuleLabel,
                    onSelected: controller.updateInitialModule,
                  ),
                  const Divider(height: 1),
                  _ResponsiveSettingsTile(
                    icon: Icons.restart_alt_outlined,
                    title: 'Aplicar cambios',
                    subtitle: 'Reinicia Agenda para cargar lo guardado',
                    control: FilledButton.icon(
                      onPressed: () => _restartApp(context),
                      icon: const Icon(Icons.check),
                      label: const Text('Aplicar'),
                    ),
                  ),
                  const Divider(height: 1),
                  _DensitySelector(controller: controller),
                  const Divider(height: 1),
                  _WeekStartSelector(controller: controller),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SettingsSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(
                    icon: Icons.warning_amber_outlined,
                    title: 'Confirmaciones',
                    subtitle: 'Controla acciones destructivas comunes',
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.delete_outline),
                    title: const Text('Confirmar eliminacion'),
                    subtitle: const Text(
                      'Pedir confirmacion antes de eliminar elementos comunes',
                    ),
                    value: controller.confirmDestructiveActions,
                    onChanged: controller.updateConfirmDestructiveActions,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SettingsSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(
                    icon: Icons.storage_outlined,
                    title: 'Gestion de datos',
                    subtitle: 'Respaldo local y acciones de mantenimiento',
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.ios_share_outlined),
                    title: const Text('Exportar respaldo'),
                    subtitle: const Text(
                      'Genera un respaldo JSON con datos reales',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final backup = await controller
                          .exportCompleteLocalDataBackup();
                      if (!context.mounted) return;
                      await showDialog<void>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Respaldo generado'),
                            content: SizedBox(
                              width: 520,
                              child: SelectableText(backup),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cerrar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.upload_file_outlined),
                    title: const Text('Importar respaldo'),
                    subtitle: const Text(
                      'Valida formato y version antes de importar',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showImportDialog(context);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.delete_forever_outlined,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: const Text('Borrar todos los datos'),
                    subtitle: const Text(
                      'Siempre requiere confirmacion reforzada',
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Borrar todos los datos'),
                            content: const Text(
                              'Esta accion requiere confirmacion reforzada.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancelar'),
                              ),
                              FilledButton(
                                onPressed: () async {
                                  await controller.deleteAllLocalData();
                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Datos locales eliminados'),
                                    ),
                                  );
                                },
                                child: const Text('Eliminar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SettingsSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(
                    icon: Icons.info_outline,
                    title: 'Informacion de la app',
                    subtitle: 'Version y estado de capacidades internas',
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.new_releases_outlined),
                    title: const Text('Version'),
                    subtitle: Text(controller.appInfo.version),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.folder_outlined),
                    title: const Text('Almacenamiento'),
                    subtitle: Text(controller.appInfo.storageStatus),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.notifications_active_outlined),
                    title: const Text('Notificaciones nativas'),
                    subtitle: Text(controller.appInfo.notificationStatus),
                  ),
                ],
              ),
            ),
          ],
        );

        if (!widget.scrollable) return content;

        return ListView(padding: EdgeInsets.zero, children: [content]);
      },
    );
  }

  String _initialModuleLabel(InitialModulePreference value) {
    switch (value) {
      case InitialModulePreference.tareas:
        return 'Tareas';
      case InitialModulePreference.horario:
        return 'Horario';
      case InitialModulePreference.calendario:
        return 'Calendario';
      case InitialModulePreference.ajustes:
        return 'Ajustes';
    }
  }

  void _restartApp(BuildContext context) {
    final restarted = AppRestartScope.restart(context);
    if (!restarted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo reiniciar desde esta vista')),
      );
    }
  }

  Future<void> _showImportDialog(BuildContext context) async {
    final textController = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Importar respaldo'),
          content: SizedBox(
            width: 520,
            child: TextField(
              controller: textController,
              minLines: 6,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'JSON de respaldo',
                alignLabelWithHint: true,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                try {
                  await controller.importCompleteLocalDataBackup(
                    textController.text,
                  );
                } catch (_) {
                  if (!dialogContext.mounted) return;
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Respaldo invalido')),
                  );
                  return;
                }
                if (!dialogContext.mounted) return;
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Respaldo importado')),
                );
              },
              child: const Text('Importar'),
            ),
          ],
        );
      },
    );
    textController.dispose();
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: colorScheme.onPrimaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSurface extends StatelessWidget {
  final Widget child;

  const _SettingsSurface({required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final SettingsController controller;

  const _ThemeSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _ResponsiveSettingsTile(
      icon: Icons.contrast_outlined,
      title: 'Tema',
      subtitle: 'Selecciona claro, oscuro o seguir sistema',
      control: SegmentedButton<AppThemePreference>(
        segments: const [
          ButtonSegment(
            value: AppThemePreference.system,
            label: Text('Sistema'),
          ),
          ButtonSegment(value: AppThemePreference.light, label: Text('Claro')),
          ButtonSegment(value: AppThemePreference.dark, label: Text('Oscuro')),
        ],
        selected: {controller.themePreference},
        onSelectionChanged: (selection) {
          controller.updateThemePreference(selection.single);
        },
      ),
    );
  }
}

class _DensitySelector extends StatelessWidget {
  final SettingsController controller;

  const _DensitySelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _ResponsiveSettingsTile(
      icon: Icons.density_medium_outlined,
      title: 'Densidad visual',
      subtitle: 'Ajusta el espacio de listas y paneles',
      control: SegmentedButton<VisualDensityPreference>(
        segments: const [
          ButtonSegment(
            value: VisualDensityPreference.comoda,
            label: Text('Comoda'),
          ),
          ButtonSegment(
            value: VisualDensityPreference.compacta,
            label: Text('Compacta'),
          ),
        ],
        selected: {controller.visualDensity},
        onSelectionChanged: (selection) {
          controller.updateVisualDensity(selection.single);
        },
      ),
    );
  }
}

class _WeekStartSelector extends StatelessWidget {
  final SettingsController controller;

  const _WeekStartSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _ResponsiveSettingsTile(
      icon: Icons.calendar_view_week_outlined,
      title: 'Inicio de semana',
      subtitle: 'Aplica a calendario y horario',
      control: SegmentedButton<WeekStartPreference>(
        segments: const [
          ButtonSegment(value: WeekStartPreference.lunes, label: Text('Lunes')),
          ButtonSegment(
            value: WeekStartPreference.domingo,
            label: Text('Domingo'),
          ),
        ],
        selected: {controller.weekStart},
        onSelectionChanged: (selection) {
          controller.updateWeekStart(selection.single);
        },
      ),
    );
  }
}

class _DropdownPreference<T extends Enum> extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final T value;
  final List<T> values;
  final String Function(T value) labelFor;
  final Future<void> Function(T value) onSelected;

  const _DropdownPreference({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.values,
    required this.labelFor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _ResponsiveSettingsTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      control: DropdownMenu<T>(
        initialSelection: value,
        dropdownMenuEntries: values.map((option) {
          return DropdownMenuEntry(value: option, label: labelFor(option));
        }).toList(),
        onSelected: (selected) {
          if (selected != null) onSelected(selected);
        },
      ),
    );
  }
}

class _ResponsiveSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget control;

  const _ResponsiveSettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.control,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 560) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 44, height: 44, child: Icon(icon)),
                const SizedBox(width: 12),
                Expanded(
                  child: _TileCopy(title: title, subtitle: subtitle),
                ),
                const SizedBox(width: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 180,
                    maxWidth: 360,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: control,
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: SizedBox(width: 44, height: 44, child: Icon(icon)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TileCopy(title: title, subtitle: subtitle),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(width: constraints.maxWidth, child: control),
            ],
          ),
        );
      },
    );
  }
}

class _TileCopy extends StatelessWidget {
  final String title;
  final String subtitle;

  const _TileCopy({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
