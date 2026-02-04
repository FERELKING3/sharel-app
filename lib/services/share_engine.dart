import 'dart:convert';
import 'dart:io';
import 'package:sharel_app/model/selected_item.dart';

class ShareEngine {
  HttpServer? _server;
  final List<SelectedItem> items;
  String sessionId = '';
  int port = 0;
  String localIP = '127.0.0.1';

  ShareEngine(this.items);

  Future<void> start() async {
    try {
      // Start HTTP server on any IPv4
      _server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
      port = _server!.port;
      sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Find local IP address
      localIP = await _getLocalIP();
      
      // Start listening for requests
      _server!.listen(_handleRequest);
      
      // debug print when in debug mode only
      assert(() {
        // ignore: avoid_print
        print('ShareEngine started on http://$localIP:$port');
        return true;
      }());
    } catch (e) {
      assert(() {
        // ignore: avoid_print
        print('ShareEngine error: $e');
        return true;
      }());
      rethrow;
    }
  }

  Future<void> stop() async {
    try {
      await _server?.close(force: true);
      _server = null;
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

  void _handleRequest(HttpRequest req) async {
    try {
      final path = req.uri.path;
      
      // Session metadata endpoint
      if (path == '/session') {
        final meta = items.asMap().entries.map((e) {
          final item = e.value;
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
          };
        }).toList();
        
        req.response.headers.contentType = ContentType.json;
        req.response.write(jsonEncode({'sessionId': sessionId, 'items': meta}));
        await req.response.close();
        return;
      }

      // File download endpoint
      if (path.startsWith('/file/')) {
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
              req.response.statusCode = HttpStatus.notFound;
              await req.response.close();
              return;
            }
            
            final file = File(maybePath);
            if (!file.existsSync()) {
              req.response.statusCode = HttpStatus.notFound;
              await req.response.close();
              return;
            }
            
            req.response.headers.set(HttpHeaders.contentTypeHeader, 'application/octet-stream');
            req.response.headers.set(HttpHeaders.contentLengthHeader, file.lengthSync().toString());
            
            // Stream the file
            await file.openRead().pipe(req.response);
            return;
          }
        }
      }

      // 404
      req.response.statusCode = HttpStatus.notFound;
      req.response.write('Not found');
      await req.response.close();
    } catch (e) {
      assert(() {
        // ignore: avoid_print
        print('Request handler error: $e');
        return true;
      }());
      try {
        req.response.statusCode = HttpStatus.internalServerError;
        req.response.write('Server error');
        await req.response.close();
      } catch (_) {
        // Response already closed
      }
    }
  }
}
