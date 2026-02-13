import 'package:flutter_riverpod/flutter_riverpod.dart';

/// File model
class FileItem {
  final String path;
  final String name;
  final bool isDirectory;
  final int sizeBytes;
  final DateTime? modifiedTime;
  final String? mimeType;

  const FileItem({
    required this.path,
    required this.name,
    required this.isDirectory,
    this.sizeBytes = 0,
    this.modifiedTime,
    this.mimeType,
  });

  /// Format file size for display
  String get formattedSize {
    if (isDirectory) return '--';
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(2)} KB';
    if (sizeBytes < 1024 * 1024 * 1024) {
      return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(sizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// Get file extension
  String get extension {
    if (isDirectory) return '';
    final lastDot = name.lastIndexOf('.');
    if (lastDot == -1) return '';
    return name.substring(lastDot + 1);
  }
}

/// File listing state
class FileListingState {
  final List<FileItem> files;
  final bool isLoading;
  final String? error;
  final String currentPath;
  final bool isSearching;
  final String? searchQuery;

  const FileListingState({
    this.files = const [],
    this.isLoading = false,
    this.error,
    this.currentPath = '/',
    this.isSearching = false,
    this.searchQuery,
  });

  FileListingState copyWith({
    List<FileItem>? files,
    bool? isLoading,
    String? error,
    String? currentPath,
    bool? isSearching,
    String? searchQuery,
  }) {
    return FileListingState(
      files: files ?? this.files,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentPath: currentPath ?? this.currentPath,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// File notifier (placeholder for now)
class FileNotifier extends StateNotifier<FileListingState> {
  FileNotifier() : super(const FileListingState());

  Future<void> loadFiles(String path) async {
    state = state.copyWith(isLoading: true);
    try {
      // TODO: Implement actual file loading
      state = state.copyWith(
        isLoading: false,
        currentPath: path,
        files: [],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void setSearchQuery(String? query) {
    state = state.copyWith(
      searchQuery: query,
      isSearching: query != null && query.isNotEmpty,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// File provider
final fileProvider =
    StateNotifierProvider<FileNotifier, FileListingState>((ref) {
  return FileNotifier();
});
