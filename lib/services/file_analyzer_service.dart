import 'package:flutter/foundation.dart';

/// Service d'analyse de fichiers
class FileAnalyzerService {
  /// Scan récursif du système de fichiers
  Future<AnalysisResult> scanDirectory(String path) async {
    debugPrint('[FileAnalyzer] Starting scan of $path');

    // TODO: Implement actual file scanning
    return const AnalysisResult(
      totalSize: 0,
      largeFiles: [],
      duplicates: [],
      unusedFiles: [],
    );
  }

  /// Déterminer si un fichier est "inutile"
  bool isUnusedFile(String path) {
    final filename = path.split('/').last.toLowerCase();
    final unusedPatterns = ['.tmp', '.bak', '.cache', '.temp', r'~$', '.swp'];
    return unusedPatterns.any((p) => filename.endsWith(p));
  }

  /// Calculer le hash d'un fichier pour détecter les doublons
  Future<String> fileHash(String path) async {
    // TODO: Implement actual file hashing
    return 'dummy_hash_${path.hashCode}';
  }
}

/// Résultat d'analyse
class AnalysisResult {
  final int totalSize;
  final List<LargeFile> largeFiles;
  final List<DuplicateGroup> duplicates;
  final List<UnusedFile> unusedFiles;

  const AnalysisResult({
    required this.totalSize,
    required this.largeFiles,
    required this.duplicates,
    required this.unusedFiles,
  });

  int get totalSaveable {
    final largeFileSize = largeFiles.fold<int>(0, (sum, f) => sum + f.size);
    final duplicateSize = duplicates.fold<int>(0, (sum, g) => sum + (g.size * (g.files.length - 1)));
    final unusedSize = unusedFiles.fold<int>(0, (sum, f) => sum + f.size);
    return largeFileSize + duplicateSize + unusedSize;
  }
}

/// Fichier volumineux
class LargeFile {
  final String path;
  final String name;
  final int size;
  final DateTime? modifiedDate;

  const LargeFile({
    required this.path,
    required this.name,
    required this.size,
    this.modifiedDate,
  });

  String get formattedSize {
    if (size < 1024 * 1024) return '${(size / (1024)).toStringAsFixed(2)} KB';
    if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

/// Groupe de fichiers dupliqués
class DuplicateGroup {
  final String hash;
  final int size;
  final List<String> files;

  const DuplicateGroup({
    required this.hash,
    required this.size,
    required this.files,
  });

  String get formattedSize {
    final totalSize = size * files.length;
    if (totalSize < 1024 * 1024) return '${(totalSize / 1024).toStringAsFixed(2)} KB';
    if (totalSize < 1024 * 1024 * 1024) {
      return '${(totalSize / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(totalSize / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

/// Fichier inutile
class UnusedFile {
  final String path;
  final String name;
  final int size;
  final String reason;

  const UnusedFile({
    required this.path,
    required this.name,
    required this.size,
    required this.reason,
  });

  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(2)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}
