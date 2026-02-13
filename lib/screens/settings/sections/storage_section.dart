import 'package:flutter/material.dart';

class StorageSection extends StatelessWidget {
  const StorageSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Cache'),
          subtitle: const Text('127 MB'),
          trailing: ElevatedButton(
            onPressed: () {},
            child: const Text('Vider'),
          ),
        ),
        ListTile(
          title: const Text('Images en cache'),
          subtitle: const Text('45 MB'),
          trailing: ElevatedButton(
            onPressed: () {},
            child: const Text('Vider'),
          ),
        ),
      ],
    );
  }
}
