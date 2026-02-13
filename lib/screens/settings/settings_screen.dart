import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/responsive/responsive_config.dart';
import '../../core/theme/design_system.dart';
import 'sections/appearance_section.dart';
import 'sections/language_section.dart';
import 'sections/transfer_section.dart';
import 'sections/storage_section.dart';
import 'sections/about_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _buildSectionHeader('AFFICHAGE', theme),
          const AppearanceSection(),
          const SizedBox(height: 16),
          _buildSectionHeader('LANGUE & RÉGION', theme),
          const LanguageSection(),
          const SizedBox(height: 16),
          _buildSectionHeader('TRANSFERT', theme),
          const TransferSection(),
          const SizedBox(height: 16),
          _buildSectionHeader('STOCKAGE', theme),
          const StorageSection(),
          const SizedBox(height: 16),
          _buildSectionHeader('À PROPOS', theme),
          const AboutSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.outline,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
