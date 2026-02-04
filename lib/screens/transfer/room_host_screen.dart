import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/theme/design_system.dart';
import '../../viewmodel/selection_viewmodel.dart';
import '../../viewmodel/transfer_viewmodel.dart';

class RoomHostScreen extends ConsumerStatefulWidget {
  const RoomHostScreen({super.key});

  @override
  ConsumerState<RoomHostScreen> createState() => _RoomHostScreenState();
}

class _RoomHostScreenState extends ConsumerState<RoomHostScreen> {
  Uri? _uri;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final selection = ref.read(selectionProvider);
      if (selection.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Aucun élément sélectionné')),
          );
          Navigator.pop(context);
        }
        return;
      }
      
      final uri = await ref.read(transferProvider.notifier).startHost(selection);
      if (mounted) {
        setState(() {
          _uri = uri;
        });
      }
    });
  }

  @override
  void dispose() {
    ref.read(transferProvider.notifier).stopHost();
    super.dispose();
  }

  void _copyToClipboard() {
    if (_uri != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adresse copiée'), duration: Duration(seconds: 2)),
      );
      setState(() {
        _copied = true;
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) setState(() => _copied = false);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(transferProvider);
    final selection = ref.watch(selectionProvider);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Room Host'), elevation: 0),
      body: _uri == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Démarrage du serveur...', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Veuillez patienter',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? AppTheme.spacing16 : AppTheme.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Success badge
                  Container(
                    padding: EdgeInsets.all(AppTheme.spacing16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.secondary.withValues(alpha: 0.12),
                          theme.colorScheme.secondary.withValues(alpha: 0.04),
                        ],
                      ),
                      border: Border.all(color: theme.colorScheme.secondary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppTheme.spacing12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                          ),
                          child: Icon(Icons.check_circle, color: theme.colorScheme.secondary, size: 28),
                        ),
                        const SizedBox(width: AppTheme.spacing16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Serveur actif', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                              SizedBox(height: AppTheme.spacing8),
                              Text('En attente de clients...', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppTheme.spacing32),

                  // QR Code Section
                  Text('Code QR', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  SizedBox(height: AppTheme.spacing12),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(AppTheme.spacing16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(alpha: 0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: QrImage(
                        data: _uri!.toString(),
                        version: QrVersions.auto,
                        size: 200,
                      ),
                    ),
                  ),

                  SizedBox(height: AppTheme.spacing32),

                  // Server address
                  Text('Adresse du serveur', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  SizedBox(height: AppTheme.spacing12),
                  Container(
                    padding: EdgeInsets.all(AppTheme.spacing16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: theme.colorScheme.surface,
                      border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.15)),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SelectableText(
                          _uri!.toString(),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: AppTheme.spacing12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _copyToClipboard,
                            icon: Icon(_copied ? Icons.check : Icons.content_copy),
                            label: Text(_copied ? 'Copié !' : 'Copier l\'adresse'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppTheme.spacing32),

                  // Items count
                  Container(
                    padding: EdgeInsets.all(AppTheme.spacing16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
                      border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppTheme.spacing8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primary.withValues(alpha: 0.2),
                          ),
                          child: Icon(Icons.folder, color: theme.colorScheme.primary),
                        ),
                        SizedBox(width: AppTheme.spacing16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${selection.length} élément(s)', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                            Text('Prêt à partager', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppTheme.spacing32),

                  // Status bar
                  Container(
                    padding: EdgeInsets.all(AppTheme.spacing16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outline, fontWeight: FontWeight.w600)),
                        SizedBox(height: AppTheme.spacing8),
                        Text(
                          state.message.isEmpty ? 'En attente de clients...' : state.message,
                          style: theme.textTheme.bodyMedium,
                        ),
                        if (state.progress > 0) ...[
                          SizedBox(height: AppTheme.spacing12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: state.progress,
                              minHeight: 6,
                              backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
                              valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: AppTheme.spacing32),
                ],
              ),
            ),
    );
  }
}
