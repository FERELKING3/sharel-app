# Performance et robustesse

**Version:** 1.0  
**Date:** 2026-02-06

## Chunking et streaming

### Implémentation actuelle
- Serveur: lit fichier entier avec `RandomAccessFile.read()` et stream par chunks de **64 KB**.
- Client: reçoit par chunks et écrit via `RandomAccessFile.writeFrom()`.

### Futur (v1.1)
- Paramètre tunable: `chunkSize` (defaut: 256 KB pour réseau LAN).
- Adapter sur latence mesurée.

## Throttling logs/progress

### Problème
Emetteur events progress à chaque chunk → flood UI.

### Solution implémentée
- Throttle: une notification progress par **200 ms**.
- Batch logs:: max 100 lignes avant export.

### Code pattern

```dart
final _progressThrottle = Throttle(Duration(milliseconds: 200));
onProgress(bytesReceived) {
  _progressThrottle.run(() {
    ref.read(progressProvider.notifier).state = bytesReceived / totalSize;
  });
}
```

## Timeouts et retry

### Défaut recommandé

```dart
const Duration connectTimeout = Duration(seconds: 10);
const Duration readTimeout = Duration(seconds: 30);
const int maxRetries = 3;
const Duration retryDelay = Duration(seconds: 2);
```

### Stratégie backoff exponentiel

Retry 1: 2s, Retry 2: 4s, Retry 3: 8s.

## Multi-clients (future)

### Limitation actuelle
- 1 client à la fois.
- Pas de file d'attente.

### Futur (v2.0)
- Queue clients: max 5.
- Partage fichier (offsets) via semaphore ou lock.
- Headers `Range` (HTTP 206 Partial Content).

## Resume et Range

### Implémentation (v1.1)

```dart
// Serveur
if (request.headers.value('range') != null) {
  // Parse Range: bytes=0-1000
  // Retourner 206 Partial Content + data
}

// Client
final existingSize = tmpFile.lengthSync();
final req = HttpClientRequest();
req.headers.add('Range', 'bytes=${existingSize}-');
```

### Cas d'usage
- Wi‑Fi coupée → reconnecter, reprendre au byte N.
- Économiser bande passante.
