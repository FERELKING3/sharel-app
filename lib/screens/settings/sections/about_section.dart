import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Version'),
          subtitle: const Text('7.6.0 (AllMight Refactored)'),
        ),
        ListTile(
          title: const Text('Licences'),
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'SHAREL',
              applicationVersion: '7.6.0',
              applicationLegalese: '© 2024 SHAREL. Tous droits réservés.',
            );
          },
        ),
        ListTile(
          title: const Text('Diagnostique'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
        ListTile(
          title: const Text('Support'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
      ],
    );
  }
}
