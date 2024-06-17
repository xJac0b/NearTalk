import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neartalk/presentation/styles/app_typography.dart';

class ThemePicker extends HookWidget {
  const ThemePicker({
    required this.onChanged,
    this.initialValue,
    super.key,
  });

  final ThemeMode? initialValue;
  final void Function(ThemeMode?) onChanged;
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: initialValue ?? ThemeMode.system,
      style: AppTypography.of(context).body,
      items: const [
        DropdownMenuItem(
          value: ThemeMode.light,
          child: Text('Light'),
        ),
        DropdownMenuItem(
          value: ThemeMode.dark,
          child: Text('Dark'),
        ),
        DropdownMenuItem(
          value: ThemeMode.system,
          child: Text('System'),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
