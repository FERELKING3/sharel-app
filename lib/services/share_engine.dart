import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sharel_app/model/selected_item.dart';
import 'package:sharel_app/services/storage_service.dart';
import 'package:sharel_app/services/logger_service.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import 'package:sharel_app/services/mdns_service.dart';

class ShareEngine {
  HttpServer? _server;
  final List<SelectedItem> items;
  late final String sessionId;
  late final String sessionToken;
  late final DateTime tokenExpiry;
  int port = 0;
  String localIP = '127.0.0.1';
  Map<int, String>? _hashCache; // {index: sha256}
  
  static const protocolVersion = '1.0';
  static const tokenExpirationMinutes = 30;

  ShareEngine(this.items) {
    sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    sessionToken = Uuid().v4();
    tokenExpiry = DateTime.now().add(Duration(minutes: tokenExpirationMinutes));
  }

  Future<void> _log(String message) async {
    debugPrint('[ShareEngine] $message');
    LoggerService.log(message, component: 'ShareEngine');
    try {
      await StorageService().writeLog('transfer', message);
    } catch (_) {
      // Fail silently if file logging fails
    }
  }

  Future<Map<int, String>> _computeHashes() async {
    final hashes = <int, String>{};
    for (int i = 0; i < items.length; i++) {
      try {
        // Simplified: compute hash for files only
        // In production, use proper file I/O
        hashes[i] = sha256.convert(utf8.encode('item_$i')).toString();
      } catch (_) {
        hashes[i] = 'unknown';
      }
    }
    return hashes;
  }

  Future<void> start() async {
    try {
      await _log('Starting ShareEngine...');
      
      // Pre-compute hashes
      _hashCache = await _computeHashes();
      
      // Start HTTP server on any IPv4
      await _log('Binding server to anyIPv4:0...');
      _server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
      port = _server!.port;
      await _log('Server bound to port $port');
      
      // Find local IP address
      localIP = await _getLocalIP();
      await _log('Local IP detected: $localIP');
      
      // Start listening for requests
      _server!.listen(_handleRequest);
      await _log('Listening for requests...');

      // Quick self-check: verify the server responds to /session locally.
      // This helps detect binding/networking issues early (throws on failure).
      final uri = Uri.parse('http://$localIP:$port/session?token=$sessionToken');
      final client = HttpClient();
      var ok = false;
      // retry a few times because the server loop starts asynchronously
      for (var attempt = 0; attempt < 5; attempt++) {
        try {
          final req = await client.getUrl(uri).timeout(const Duration(seconds: 2));
          final res = await req.close().timeout(const Duration(seconds: 2));
          if (res.statusCode == HttpStatus.ok) {
            ok = true;
            await res.drain();
            break;
          }
        } catch (_) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
      }
      client.close(force: true);
      if (!ok) {
        // if the self-check fails, stop the server and throw
        await stop();
        await _log('ERROR: Self-check failed - /session not reachable');
        throw Exception('ShareEngine self-check failed: /session not reachable');
      }
      
      await _log('✓ Successfully started on http://$localIP:$port');
      await _log('Session ID: $sessionId');
      await _log('Session token: ${sessionToken.substring(0, 8)}...');
      await _log('Items count: ${items.length}');
      await _log('[SERVER_READY] Server is ready to receive connections at http://$localIP:$port/session?token=$sessionToken');
      // Publish service via mDNS/UDP fallback so clients can discover this host
      try {
        await MDnsService().publishService(
          name: 'SHAREL Device',
          port: port,
          txt: {
            'session': sessionId,
            'token': sessionToken.substring(0, 8),
          },
        );
        await _log('Published mDNS/UDP advertisement');
      } catch (e) {
        await _log('Failed to publish mDNS advertisement: $e');
      }
    } catch (e) {
      await _log('✗ CRITICAL ERROR during startup: $e');
      rethrow;
    }
  }

  Future<void> stop() async {
    try {
      await _server?.close(force: true);
      _server = null;
      try {
        await MDnsService().stopPublishing();
      } catch (_) {}
    } catch (e) {
      assert(() {
        // ignore: avoid_print
        print('Error stopping server: $e');
        return true;
      }());
    }
  }

  Future<String> _getLocalIP() async {
    try {
      // List all network interfaces
      final interfaces = await NetworkInterface.list();
      
      for (final interface in interfaces) {
        for (final addr in interface.addresses) {
          // Look for IPv4 addresses that are not loopback
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            return addr.address;
          }
        }
      }
    } catch (e) {
      assert(() {
        // ignore: avoid_print
        print('Error getting network interface: $e');
        return true;
      }());
    }
    
    // Fallback to loopback if no local IP found
    return '127.0.0.1';
  }

  Uri getLocalUri() {
    return Uri.parse('http://$localIP:$port');
  }

  bool _validateToken(String? token) {
    if (token == null) return false;
    if (token != sessionToken) return false;
    if (DateTime.now().isAfter(tokenExpiry)) return false;
    return true;
  }

  void _handleRequest(HttpRequest req) async {
    try {
      final path = req.uri.path;
      final token = req.uri.queryParameters['token'];
      final method = req.method.toUpperCase();

      // Root endpoint - HTML page
      if (path == '/' && method == 'GET') {
        req.response.headers.contentType = ContentType.html;
        req.response.write('''<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SHAREL Host</title>
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
    .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
    h1 { color: #0066FF; margin-top: 0; }
    p { color: #666; line-height: 1.6; }
    .endpoint { background: #f9f9f9; padding: 12px; margin: 8px 0; border-left: 4px solid #0066FF; font-family: monospace; font-size: 13px; }
    .status { padding: 12px; background: #e8f5e9; border-radius: 8px; color: #2e7d32; margin: 16px 0; }
    a { color: #0066FF; text-decoration: none; }
    a:hover { text-decoration: underline; }
  </style>
</head>
<body>
  <div class="container">
    <h1>🚀 SHAREL Host</h1>
    <div class="status">✓ Serveur actif et prêt à recevoir des fichiers</div>
    <p><strong>Adresse serveur:</strong> http://$localIP:$port</p>
    <h3>Endpoints disponibles:</h3>
    <div class="endpoint">GET /session - Métadonnées de transfert (JSON)</div>
    <div class="endpoint">GET /file/:index - Télécharger un fichier</div>
    <div class="endpoint">POST /handshake - Validation de session</div>
    <p><strong>Informations de session:</strong></p>
    <ul>
      <li>Session ID: <code>$sessionId</code></li>
      <li>Fichiers: <code>${items.length}</code></li>
      <li>Expire: <code>${tokenExpiry.toIso8601String()}</code></li>
    </ul>
    <p><a href="/session">→ Afficher les métadonnées JSON</a></p>
  </div>
</body>
</html>''');
        await req.response.close();
        return;
      }

      // Session metadata endpoint with token validation
      if (path == '/session' && method == 'GET') {
        // Validate token (optional in v1.0, required in v1.1)
        if (!_validateToken(token)) {
          assert(() {
            // ignore: avoid_print
            print('[ShareEngine] Warning: /session accessed without valid token');
            LoggerService.log('Warning: /session accessed without valid token', component: 'ShareEngine');
            return true;
          }());
        }

        final meta = items.asMap().entries.map((e) {
          final item = e.value;
          final hash = _hashCache?[e.key] ?? 'unknown';
          return {
            'index': e.key,
            'name': item.map(
              contact: (_) => 'contact',
              file: (f) => f.name,
              video: (v) => v.title,
              photo: (p) => p.path.split('/').last,
              music: (m) => m.title,
              app: (a) => a.name,
            ),
            'size': item.map(
              contact: (_) => 0,
              file: (f) => f.size,
              video: (v) => 0,
              photo: (p) => 0,
              music: (m) => 0,
              app: (a) => 0,
            ),
            'hash': hash,
          };
        }).toList();

        req.response.headers.contentType = ContentType.json;
        req.response.write(jsonEncode({
          'app': 'sharel',
          'role': 'host',
          'protocol': protocolVersion,
          'sessionId': sessionId,
          'deviceName': 'SHAREL Device',
          'filesExpected': items.length,
          'expiresAt': tokenExpiry.toIso8601String(),
          'itemsCount': items.length,
          'items': meta,
        }));
        await req.response.close();
        LoggerService.log('GET /session - ${items.length} items returned', component: 'ShareEngine');
        return;
      }

      // Handshake endpoint - validate token and session
      if (path == '/handshake' && method == 'POST') {
        if (!_validateToken(token)) {
          req.response.statusCode = HttpStatus.unauthorized;
          req.response.headers.contentType = ContentType.json;
          req.response.write(jsonEncode({
            'status': 'error',
            'message': 'Invalid or expired token',
          }));
          await req.response.close();
          LoggerService.log('POST /handshake - Unauthorized', component: 'ShareEngine');
          return;
        }

        req.response.statusCode = HttpStatus.ok;
        req.response.headers.contentType = ContentType.json;
        req.response.write(jsonEncode({
          'status': 'success',
          'sessionId': sessionId,
          'message': 'Session validated',
        }));
        await req.response.close();
        LoggerService.log('POST /handshake - Session validated', component: 'ShareEngine');
        return;
      }

      // File download endpoint
      if (path.startsWith('/file/') && method == 'GET') {
        final parts = path.split('/');
        if (parts.length >= 3) {
          final idx = int.tryParse(parts[2]);
          if (idx != null && idx >= 0 && idx < items.length) {
            final item = items[idx];
            final maybePath = item.map(
              contact: (_) => null,
              file: (f) => f.path,
              video: (v) => v.path,
              photo: (p) => p.path,
              music: (m) => m.path,
              app: (a) => null,
            );

            if (maybePath == null) {
              LoggerService.log('GET /file/$idx - Item has no path (contact/app)', component: 'ShareEngine');
              req.response.statusCode = HttpStatus.notFound;
              await req.response.close();
              return;
            }

            final file = File(maybePath);
            if (!file.existsSync()) {
              LoggerService.log('GET /file/$idx - File not found: $maybePath', component: 'ShareEngine');
              req.response.statusCode = HttpStatus.notFound;
              await req.response.close();
              return;
            }

            req.response.headers.set(HttpHeaders.contentTypeHeader, 'application/octet-stream');
            req.response.headers.set(HttpHeaders.contentLengthHeader, file.lengthSync().toString());

            // Stream the file
            LoggerService.log('GET /file/$idx - Streaming file: ${file.path} (${file.lengthSync()} bytes)', component: 'ShareEngine');
            await file.openRead().pipe(req.response);
            return;
          }
        }
      }

      // 404
      LoggerService.log('$method $path - Not found', component: 'ShareEngine');
      req.response.statusCode = HttpStatus.notFound;
      req.response.headers.contentType = ContentType.html;
      req.response.write('<html><body><h1>404 Not Found</h1><p>SHAREL Server - $path not found</p></body></html>');
      await req.response.close();
    } catch (e) {
      assert(() {
        // ignore: avoid_print
        print('Request handler error: $e');
        LoggerService.log('Error in request handler: $e', component: 'ShareEngine');
        return true;
      }());
      try {
        req.response.statusCode = HttpStatus.internalServerError;
        req.response.headers.contentType = ContentType.json;
        req.response.write(jsonEncode({'status': 'error', 'message': 'Server error'}));
        await req.response.close();
      } catch (_) {
        // Response already closed
      }
    }
  }
}
