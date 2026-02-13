import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/settings_provider.dart';

class AppearanceSection extends ConsumerWidget {
  const AppearanceSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final theme = Theme.of(context);

    return Column(
      children: [
        ListTile(
          title: const Text('Thème sombre'),
          trailing: Switch(
            value: isDarkMode,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setDarkMode(value);
            },
          ),
        ),
        ListTile(
          title: const Text('Densité UI'),
          trailing: DropdownButton<int>(
            value: ref.watch(uiDensityProvider),
            items: const [
              DropdownMenuItem(value: 0, child: Text('Compacte')),
              DropdownMenuItem(value: 1, child: Text('Normal')),
              DropdownMenuItem(value: 2, child: Text('Spacieuse')),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(settingsProvider.notifier).setUIDensity(value);
              }
            },
          ),
        ),
      ],
    );
  }
}
