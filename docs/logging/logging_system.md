# Système de logging

**Version:** 1.0  
**Date:** 2026-02-06

## Architecture

### LoggerService (créé en v1.1)

```dart
class LoggerService {
  static const int maxLines = 1000;
  static final logs = <LogEntry>[];
  
  static void log(String msg, {required String component, LogLevel level = LogLevel.info}) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      component: component,    // 'ShareEngine', 'TransferVM', 'UI'
      transferId: _currentTransferId,
      message: msg,
      level: level,
    );
    logs.add(entry);
    
    // Trim old
    if (logs.length > maxLines) {
      logs.removeRange(0, logs.length - maxLines);
    }
    
    // Console debug
    print('[$component] $msg');
  }
  
  static String export() => logs.map((e) => e.format()).join('\n');
  static void clear() => logs.clear();
}

enum LogLevel { debug, info, warn, error }
```

### TransferId (correlation)

Chaque transfert reçoit un ID unique:

```dart
final transferId = Uuid().v4();
LoggerService.transferId = transferId;
```

## Évenements clés à logger

```
[ShareEngine] Starting HTTP server...
[ShareEngine] Server OK on 192.168.1.42:45678
[TransferVM] startHost() -> sessionId: abc123...
[TransferVM] startHost() -> autocheck /session passed ✓
[Client] Fetching /session from 192.168.1.42:45678
[Client] Items received: 3 files, total 52.3 MB
[Client] Downloading file 0: document.pdf (15 MB)
[Client] Chunk 0/60: 256 KB recv (0.5% total)
[Client] Chunk 30/60: 256 KB recv (50% total)
[Client] file 0 complete. Hash match: YES ✓
[Client] All transfers complete. TransferId: [uuid]
```

## Affichage UI

### Debug Panel (futur)

Afficher en dev mode:

```
┌─ Transfer Logs ─────────────────┐
│ [ShareEngine] Server OK         │
│ [Client] /session OK            │
│ [Client] 50% complete           │
└─────────────────────────────────┘
```

### Export logs

```dart
// Bouton dans "About" ou settings
final logText = LoggerService.export();
await Share.share(logText, subject: 'SHAREL Logs');
// Sauve dans: /Downloads/sharel_[transferId]_[timestamp].log
```

## Rapport transfert

```json
{
  "transferId": "abc-123-def",
  "hostDevice": "OnePlus 9",
  "clientDevice": "iPhone 13",
  "startTime": "2026-02-06T10:30:00Z",
  "endTime": "2026-02-06T10:35:42Z",
  "duration": 342,
  "filesCount": 3,
  "totalSize": 52300000,
  "successCount": 3,
  "failedCount": 0,
  "status": "success",
  "errors": []
}
```

## Throttling

Sans throttle, progress event = spam → perf ↓.

```dart
final _throttle = Throttle(Duration(milliseconds: 200));

onProgress(bytesReceived, totalBytes) {
  _throttle.run(() {
    // Update UI
    ref.read(progressProvider.notifier).state = 
      bytesReceived / totalBytes;
  });
}
```

## Stockage logs

- **In-memory:** max 1000 lignes (RAM).
- **Export:** fichier texte `.log` (téléchargement).
- **Rotation:** auto clear après 7 jours (futur).

## Débogage à distance

Pour support, user peut:
1. Ouvrir "Debug" dans l'app.
2. "Copy logs".
3. Coller dans issue GitHub.

Contient: transferId, devices, timeline, erreurs.

## Confidentialité

- Pas de mots de passe / tokens dans logs.
- Crypto: si implémenté, masquer clé.
- Chemins fichiers: ok (user devices).

## Checklist

- ✅ LoggerService créé (v1.1).
- ✅ TransferId dans tous les logs.
- ✅ Export UI.
- ✅ Throttle events.
- ✅ Rapport JSON.
