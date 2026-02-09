import 'dart:async';
import 'dart:io';

import 'package:multicast_dns/multicast_dns.dart';
import 'dart:convert';

// Multicast settings for UDP fallback advertisement
const _kMulticastAddress = '224.0.0.251';
const _kMulticastPort = 5354; // use 5354 for fallback (avoid 5353 collisions)

class MdnsHost {
  final String name;
  final String ip;
  final int port;
  final Map<String, String> txt;

  MdnsHost({required this.name, required this.ip, required this.port, required this.txt});
}

class MDnsService {
  static final MDnsService _instance = MDnsService._internal();

  factory MDnsService() => _instance;

  MDnsService._internal();

  MDnsClient? _client;
  final StreamController<MdnsHost> _hostsController = StreamController.broadcast();
  Stream<MdnsHost> get hosts => _hostsController.stream;
  bool _isRunning = false;
  RawDatagramSocket? _udpSocket;
  Timer? _advertTimer;

  Future<void> startDiscovery({Duration timeout = const Duration(seconds: 3)}) async {
    if (_isRunning) return;
    _isRunning = true;

    _client = MDnsClient();
    try {
      await _client!.start();

      // Lookup PTR records for service _sharel._tcp.local
      await for (final PtrResourceRecord ptr in _client!.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer('_sharel._tcp'),
      ).timeout(timeout)) {
        try {
          // Resolve SRV
          await for (final SrvResourceRecord srv in _client!.lookup<SrvResourceRecord>(
            ResourceRecordQuery.service(ptr.domainName),
          )) {
            // Resolve TXT
            final txtMap = <String, String>{};
            await for (final TxtResourceRecord txt in _client!.lookup<TxtResourceRecord>(
              ResourceRecordQuery.text(ptr.domainName),
            )) {
              for (final entry in txt.text) {
                final parts = entry.split('=');
                if (parts.length == 2) txtMap[parts[0]] = parts[1];
              }
            }

            // Resolve A/AAAA
            await for (final IPAddressResourceRecord addr in _client!.lookup<IPAddressResourceRecord>(
              ResourceRecordQuery.addressIPv4(srv.target),
            )) {
              final host = MdnsHost(
                name: ptr.domainName,
                ip: addr.address.address,
                port: srv.port,
                txt: txtMap,
              );
              _hostsController.add(host);
            }
          }
        } catch (e) {
          // ignore individual record errors
        }
      }
    } catch (e) {
      // Discovery timed out or failed; simply stop
    }

    // Start UDP multicast listener fallback
    try {
      _udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, _kMulticastPort);
      _udpSocket!.joinMulticast(InternetAddress(_kMulticastAddress));
      _udpSocket!.listen((event) {
        if (event == RawSocketEvent.read) {
          final dg = _udpSocket!.receive();
          if (dg == null) return;
          try {
            final s = utf8.decode(dg.data);
            final map = jsonDecode(s) as Map<String, dynamic>;
            if (map['service'] == 'sharel') {
              final host = MdnsHost(
                name: map['name'] ?? 'sharel',
                ip: map['ip'] ?? dg.address.address,
                port: map['port'] ?? 0,
                txt: (map['txt'] as Map?)?.cast<String, String>() ?? {},
              );
              _hostsController.add(host);
            }
          } catch (_) {}
        }
      });
    } catch (e) {
      // ignore UDP failures
    }
  }

  Future<void> stopDiscovery() async {
    try {
      await _client?.stop();
    } catch (_) {}
    _client = null;
    _isRunning = false;
    try {
      _udpSocket?.close();
    } catch (_) {}
    _udpSocket = null;
  }

  void dispose() {
    _hostsController.close();
  }

  /// Publish a lightweight UDP multicast advertisement as a fallback for environments
  /// where native mDNS registration is not available. Sends a small JSON payload
  /// regularly on the multicast group.
  Future<void> publishService({required String name, required int port, Map<String, String>? txt}) async {
    try {
      _advertTimer?.cancel();
      final sock = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      _udpSocket = sock;
      final payload = jsonEncode({
        'service': 'sharel',
        'name': name,
        'ip': await _getLocalIP(),
        'port': port,
        'txt': txt ?? {},
      });

      // send immediately then periodically
      void sendOnce() {
        try {
          final data = utf8.encode(payload);
          sock.send(data, InternetAddress(_kMulticastAddress), _kMulticastPort);
        } catch (_) {}
      }

      sendOnce();
      _advertTimer = Timer.periodic(const Duration(seconds: 2), (_) => sendOnce());
    } catch (e) {
      // ignore
    }
  }

  Future<void> stopPublishing() async {
    try {
      _advertTimer?.cancel();
      _advertTimer = null;
      _udpSocket?.close();
      _udpSocket = null;
    } catch (_) {}
  }
}
