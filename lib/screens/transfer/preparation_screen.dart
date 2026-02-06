import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../viewmodel/selection_viewmodel.dart';
import '../../providers/permission_provider.dart';
import '../../core/theme/design_system.dart';

class PreparationScreen extends ConsumerWidget {
  const PreparationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(selectionProvider);
    final perms = ref.watch(requiredPermissionsProvider);
    
    if (selection.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Préparation'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        body: const Center(child: Text('Aucun élément sélectionné')),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prérequis de transfert'),
        elevation: 0,
      ),
      body: perms.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
        data: (permissions) => _buildContent(context, selection, permissions, ref),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Set selection,
    Map<String, PermissionStatus> permissions,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? AppTheme.spacing16 : AppTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Autorisations requises',
            style: theme.textTheme.headlineSmall,
          ),
          SizedBox(height: AppTheme.spacing16),
          ...permissions.entries.map((e) => Padding(
            padding: EdgeInsets.only(bottom: AppTheme.spacing12),
            child: _PermissionItem(
              title: e.key,
              isGranted: e.value.isGranted,
              isDenied: e.value.isDenied,
            ),
          )),
          SizedBox(height: AppTheme.spacing32),
          Text(
            '${selection.length} élément(s) sélectionné(s)',
            style: theme.textTheme.bodyLarge,
          ),
          SizedBox(height: AppTheme.spacing20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (permissions.values.every((s) => s.isGranted)) {
                  context.go('/transfer/host');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veuillez accepter toutes les autorisations'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Créer une room'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  final String title;
  final bool isGranted;
  final bool isDenied;
  
  const _PermissionItem({
    required this.title,
    required this.isGranted,
    required this.isDenied,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = isGranted ? Colors.green : Colors.red;
    final statusIcon = isGranted ? Icons.check_circle : Icons.cancel;
    final statusText = isGranted ? 'Accordée' : 'Refusée';

    return Container(
      padding: EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 24),
          SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            statusText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
