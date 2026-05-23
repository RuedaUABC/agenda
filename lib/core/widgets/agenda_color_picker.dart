import 'package:flutter/material.dart';

class AgendaColorPicker extends StatelessWidget {
  final List<Color> colors;
  final int selectedColor;
  final ValueChanged<int> onChanged;

  const AgendaColorPicker({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (var index = 0; index < colors.length; index++)
          Tooltip(
            message: 'Seleccionar color ${index + 1}',
            child: InkWell(
              key: Key('agenda-color-option-$index'),
              borderRadius: BorderRadius.circular(24),
              onTap: () => onChanged(colors[index].toARGB32()),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors[index],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors[index].toARGB32() == selectedColor
                        ? colorScheme.onSurface
                        : colorScheme.outlineVariant,
                    width: colors[index].toARGB32() == selectedColor ? 3 : 1,
                  ),
                ),
                child: colors[index].toARGB32() == selectedColor
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            ),
          ),
      ],
    );
  }
}
