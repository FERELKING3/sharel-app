import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sharel_app/l10n/app_localizations.dart';
import '../../core/theme/design_system.dart';
import '../../services/mdns_service.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodel/transfer_viewmodel.dart';

class DiscoveryPage extends ConsumerStatefulWidget {
  const DiscoveryPage({super.key});

  @override
  ConsumerState<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends ConsumerState<DiscoveryPage> {
  final MDnsService _mdns = MDnsService();
  final List<MdnsHost> _hosts = [];
  StreamSubscription<MdnsHost>? _sub;
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    _startDiscovery();
  }

  Future<void> _startDiscovery() async {
    setState(() => _scanning = true);
    _sub = _mdns.hosts.listen((host) {
      if (!_hosts.any((h) => h.ip == host.ip && h.port == host.port)) {
        setState(() => _hosts.add(host));
      }
    });
    await _mdns.startDiscovery();
    setState(() => _scanning = false);
  }

  @override
  void dispose() {
    _sub?.cancel();
    _mdns.stopDiscovery();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Découvrir', style: theme.textTheme.headlineMedium),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t?.labelReceive ?? 'Recevoir', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppTheme.spacing12),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scanner un QR'),
                  onPressed: () async {
                    final result = await context.push<String>('/transfer/scan');
                    if (result != null) {
                      // push client flow
                      context.push('/transfer/join', extra: null);
                    }
                  },
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.link),
                  label: const Text('Entrer une adresse'),
                  onPressed: () => context.push('/transfer/join'),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: _scanning ? const Icon(Icons.refresh) : const Icon(Icons.refresh_outlined),
                  onPressed: () async {
                    setState(() {
                      _hosts.clear();
                    });
                    await _mdns.stopDiscovery();
                    await _startDiscovery();
                  },
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing12),
            Expanded(
              child: _hosts.isEmpty
                  ? Center(
                      child: _scanning
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [CircularProgressIndicator(), SizedBox(height: 12), Text('Recherche d\'appareils...')],
                            )
                          : const Text('Aucun appareil trouvé. Essayez Scanner QR ou entrer l\'adresse.'),
                    )
                  : ListView.separated(
                      itemCount: _hosts.length,
                      separatorBuilder: (_, __) => const Divider(height: 8),
                      itemBuilder: (context, index) {
                        final h = _hosts[index];
                        return ListTile(
                          leading: const Icon(Icons.wifi_tethering),
                          title: Text(h.name),
                          subtitle: Text('${h.ip}:${h.port}'),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      // set provider and open client
                                      ref.read(targetServerProvider.notifier).state = 'http://${h.ip}:${h.port}';
                                      context.push('/transfer/client');
                                    },
                                    child: const Text('Se connecter'),
                                  ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
