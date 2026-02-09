import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/design_system.dart';

class ReceiverPage extends StatefulWidget {
  const ReceiverPage({super.key});

  @override
  State<ReceiverPage> createState() => _ReceiverPageState();
}

class _ReceiverPageState extends State<ReceiverPage> {
  // ignore: unused_field
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Recevoir', style: theme.textTheme.headlineMedium),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              }
            },
          ),
      ),
      body: _buildContent(),
    );
  }
  Widget _buildContent() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Recevoir des fichiers', style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppTheme.spacing16),
          Text('Scannez le QR code ou collez l\'adresse fournie par l\'envoyeur.', style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppTheme.spacing24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scanner QR / URL'),
              onPressed: () => context.push('/transfer/join'),
            ),
          ),
          const SizedBox(height: AppTheme.spacing12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.link),
              label: const Text('Coller l\'URL'),
              onPressed: () => context.push('/transfer/join'),
            ),
          ),
        ],
      ),
    );
  }
}