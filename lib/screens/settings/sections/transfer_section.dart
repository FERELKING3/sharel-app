import 'package:flutter/material.dart';

class TransferSection extends StatelessWidget {
  const TransferSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Méthode de découverte'),
          trailing: DropdownButton<String>(
            value: 'mdns',
            items: const [
              DropdownMenuItem(value: 'mdns', child: Text('mDNS')),
              DropdownMenuItem(value: 'qr', child: Text('Code QR')),
            ],
            onChanged: (value) {},
          ),
        ),
        SwitchListTile(
          title: const Text('Accepter automatiquement'),
          value: false,
          onChanged: (value) {},
        ),
      ],
    );
  }
}
