import 'package:flutter/material.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 36, child: Icon(Icons.person)),
          const SizedBox(height: 12),
          Text('Utilisateur', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('À propos'),
              subtitle: const Text('SHAREL — maquette'),
            ),
          ),
        ],
      ),
    );
  }
}
