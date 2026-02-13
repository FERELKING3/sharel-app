import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/file_analyzer_service.dart';
import '../../core/theme/design_system.dart';

class AnalyzerScreen extends StatefulWidget {
  const AnalyzerScreen({Key? key}) : super(key: key);

  @override
  State<AnalyzerScreen> createState() => _AnalyzerScreenState();
}

class _AnalyzerScreenState extends State<AnalyzerScreen> {
  final analyzer = FileAnalyzerService();
  bool isScanning = false;
  AnalysisResult? result;
  double scanProgress = 0.0;

  Future<void> _startScan() async {
    setState(() {
      isScanning = true;
      scanProgress = 0.0;
    });

    try {
      final analysisResult = await analyzer.scanDirectory('/storage/emulated/0');
      setState(() {
        result = analysisResult;
        scanProgress = 1.0;
        isScanning = false;
      });
    } catch (e) {
      debugPrint('Scan error: $e');
      setState(() => isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyse du stockage'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scanneur de stockage',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Analysez votre téléphone pour trouver:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildFeatureItem(
                      '📦 Fichiers volumineux (>100 MB)',
                      theme,
                    ),
                    _buildFeatureItem(
                      '🔄 Fichiers en doublon',
                      theme,
                    ),
                    _buildFeatureItem(
                      '🗑️ Fichiers inutilisés',
                      theme,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isScanning ? null : _startScan,
                        icon: isScanning
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.search),
                        label: Text(
                          isScanning ? 'Scan en cours...' : 'Démarrer l\'analyse',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isScanning) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(value: scanProgress),
              const SizedBox(height: 8),
              Text(
                '${(scanProgress * 100).toStringAsFixed(0)}%',
                style: theme.textTheme.bodySmall,
              ),
            ],
            if (result != null) ...[
              const SizedBox(height: 24),
              _buildResultCard(
                title: 'Taille totale',
                value: _formatBytes(result!.totalSize),
                icon: Icons.storage,
                theme: theme,
              ),
              const SizedBox(height: 12),
              _buildResultCard(
                title: 'Espace à libérer',
                value: _formatBytes(result!.totalSaveable),
                icon: Icons.delete_outline,
                color: Colors.orange,
                theme: theme,
              ),
              const SizedBox(height: 24),
              if (result!.largeFiles.isNotEmpty) ...[
                Text('Fichiers volumineux', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                ...result!.largeFiles.take(5).map((f) => _buildFileItem(f.name, f.formattedSize, theme)),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(text, style: theme.textTheme.bodySmall),
    );
  }

  Widget _buildResultCard({
    required String title,
    required String value,
    required IconData icon,
    required ThemeData theme,
    Color? color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32, color: color ?? AppColors.primary),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: color ?? AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileItem(String name, String size, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
          ),
          Text(
            size,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
