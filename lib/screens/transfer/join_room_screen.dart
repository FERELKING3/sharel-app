import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../viewmodel/transfer_viewmodel.dart';

class JoinRoomScreen extends ConsumerStatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  ConsumerState<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends ConsumerState<JoinRoomScreen> with WidgetsBindingObserver {
  late TextEditingController _urlController;
  late MobileScannerController _scannerController;
  bool _scannerReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _urlController = TextEditingController();
    _scannerController = MobileScannerController();
    _checkAndRequestCameraPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndRequestCameraPermission();
    }
  }

  Future<void> _checkAndRequestCameraPermission() async {
    try {
      final status = await Permission.camera.status;
      setState(() {
        _scannerReady = status.isGranted;
      });

      if (status.isDenied) {
        final newStatus = await Permission.camera.request();
        setState(() {
          _scannerReady = newStatus.isGranted;
        });
      }
    } catch (e) {
      debugPrint('[JoinRoomScreen] Camera permission error: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _urlController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _onQRDetected(String value) {
    if (value.isNotEmpty && value.startsWith('http')) {
      setState(() {
        _urlController.text = value;
      });
      HapticFeedback.heavyImpact();
    }
  }

  void _connect() {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrez une URL valide')),
      );
      return;
    }
    if (!url.startsWith('http')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('L\'URL doit commencer par http://')),
      );
      return;
    }
    ref.read(targetServerProvider.notifier).state = url;
    context.push('/transfer/client');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejoindre une room'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : null,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // QR Scanner Section
              if (_scannerReady)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scanner le QR code',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: theme.colorScheme.primary, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(alpha: 0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(17),
                          child: MobileScanner(
                            controller: _scannerController,
                            onDetect: (capture) {
                              for (final barcode in capture.barcodes) {
                                final qrValue = barcode.rawValue ?? '';
                                if (qrValue.isNotEmpty) {
                                  _onQRDetected(qrValue);
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.no_photography, color: theme.colorScheme.error, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            'Permission caméra refusée',
                            style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.error),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _checkAndRequestCameraPermission,
                            child: const Text('Accorder permission'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              // Manual URL Entry Section
              Text(
                'Ou collez l\'adresse manuellement',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  hintText: 'http://192.168.1.5:4567',
                  prefixIcon: const Icon(Icons.link),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _connect,
                  icon: const Icon(Icons.login),
                  label: const Text('Se connecter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
