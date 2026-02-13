import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/settings_provider.dart';

class LanguageSection extends ConsumerWidget {
  const LanguageSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageCodeProvider);

    return ListTile(
      title: const Text('Langue'),
      trailing: DropdownButton<String>(
        value: language,
        items: const [
          DropdownMenuItem(value: 'fr', child: Text('Français')),
          DropdownMenuItem(value: 'en', child: Text('English')),
        ],
        onChanged: (value) {
          if (value != null) {
            ref.read(settingsProvider.notifier).setLanguage(value);
          }
        },
      ),
    );
  }
}
