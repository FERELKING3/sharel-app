import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class MediaState {
  final List<AssetEntity> assets;
  final bool isLoading;
  final String? error;
  final bool hasMore;

  MediaState({
    this.assets = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
  });

  MediaState copyWith({
    List<AssetEntity>? assets,
    bool? isLoading,
    String? error,
    bool? hasMore,
  }) {
    return MediaState(
      assets: assets ?? this.assets,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class VideosViewModel extends StateNotifier<MediaState> {
  VideosViewModel() : super(MediaState()) {
    loadVideos();
  }

  Future<void> loadVideos() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Request platform-appropriate permission
      PermissionStatus permission;
      if (Platform.isAndroid) {
        permission = await Permission.storage.request();
      } else {
        permission = await Permission.photos.request();
      }
      if (!permission.isGranted) {
        state = state.copyWith(
          isLoading: false,
          error: 'Permission denied',
        );
        return;
      }

      final albums = await PhotoManager.getAssetPathList(type: RequestType.video);
      if (albums.isNotEmpty) {
        final assets = await albums.first.getAssetListPaged(page: 0, size: 50);
        state = state.copyWith(
          assets: assets,
          isLoading: false,
          hasMore: assets.length == 50,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoading: true);

    try {
      final albums = await PhotoManager.getAssetPathList(type: RequestType.video);
      if (albums.isNotEmpty) {
        final page = (state.assets.length / 50).floor();
        final newAssets = await albums.first.getAssetListPaged(page: page, size: 50);
        state = state.copyWith(
          assets: [...state.assets, ...newAssets],
          isLoading: false,
          hasMore: newAssets.length == 50,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

class PhotosViewModel extends StateNotifier<MediaState> {
  PhotosViewModel() : super(MediaState()) {
    loadPhotos();
  }

  Future<void> loadPhotos() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Request platform-appropriate permission
      PermissionStatus permission;
      if (Platform.isAndroid) {
        permission = await Permission.storage.request();
      } else {
        permission = await Permission.photos.request();
      }
      if (!permission.isGranted) {
        state = state.copyWith(
          isLoading: false,
          error: 'Permission denied',
        );
        return;
      }

      final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
      if (albums.isNotEmpty) {
        final assets = await albums.first.getAssetListPaged(page: 0, size: 50);
        state = state.copyWith(
          assets: assets,
          isLoading: false,
          hasMore: assets.length == 50,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoading: true);

    try {
      final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
      if (albums.isNotEmpty) {
        final page = (state.assets.length / 50).floor();
        final newAssets = await albums.first.getAssetListPaged(page: page, size: 50);
        state = state.copyWith(
          assets: [...state.assets, ...newAssets],
          isLoading: false,
          hasMore: newAssets.length == 50,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final videosProvider = StateNotifierProvider<VideosViewModel, MediaState>(
  (ref) => VideosViewModel(),
);

final photosProvider = StateNotifierProvider<PhotosViewModel, MediaState>(
  (ref) => PhotosViewModel(),
);