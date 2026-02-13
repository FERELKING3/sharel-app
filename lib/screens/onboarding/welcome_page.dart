import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import '../../services/storage_service.dart';
import '../../services/permission_service.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/design_system.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late LiquidController _liquidController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _liquidController = LiquidController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _liquidController.animateToPage(
        page: _currentPage + 1,
        duration: 600,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    // Request permissions one more time
    try {
      await PermissionService.requestAllFilesAccess();
      debugPrint('[WelcomePage] Permissions requested in onboarding');
    } catch (e) {
      debugPrint('[WelcomePage] Permission request error: $e');
    }

    // Ensure SHAREL folder is created
    try {
      await StorageService().initialize();
      debugPrint('[WelcomePage] Storage initialized');
    } catch (e) {
      debugPrint('[WelcomePage] Storage initialization error: $e');
    }

    // Mark onboarding completed
    try {
      await StorageService().setCompletedOnboarding();
      debugPrint('[WelcomePage] Onboarding marked as completed');
    } catch (e) {
      debugPrint('[WelcomePage] Onboarding flag error: $e');
    }

    // Navigate to home
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    final pages = [
      _buildWelcomeSlide(
        title: t?.labelSend ?? 'Envoyer',
        description:
            'Partagez vos fichiers instantanément avec d\'autres appareils via WiFi',
        icon: Icons.send_rounded,
        color: AppColors.sendColor,
      ),
      _buildWelcomeSlide(
        title: t?.labelReceive ?? 'Recevoir',
        description:
            'Recevez des fichiers en toute sécurité de vos amis et collègues',
        icon: Icons.cloud_download_rounded,
        color: AppColors.receiveColor,
      ),
      _buildWelcomeSlide(
        title: t?.labelFiles ?? 'Fichiers',
        description: 'Gérez et organisez tous vos fichiers partagés',
        icon: Icons.folder_open_rounded,
        color: AppColors.filesColor,
      ),
      _buildWelcomeSlide(
        title: 'Prêt à commencer?',
        description:
            'SHAREL rend le partage de fichiers facile, rapide et sécurisé',
        icon: Icons.check_circle_rounded,
        color: AppColors.primary,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe(
            pages: pages,
            liquidController: _liquidController,
            fullTransitionValue: 400,
            enableSideReveal: true,
            waveType: WaveType.liquidReveal,
            onPageChangeCallback: (page) {
              setState(() => _currentPage = page);
            },
            enableLoop: false,
            ignoreUserGestureWhileAnimating: true,
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: _currentPage == index ? 28 : 10,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: _currentPage == index
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ).animate().scale(duration: const Duration(milliseconds: 300)),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: _skipOnboarding,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.08),
                          foregroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Passer',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 36,
                            vertical: 14,
                          ),
                          backgroundColor: AppColors.primary,
                          elevation: 4,
                          shadowColor: AppColors.primary.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _currentPage == 3 ? 'Démarrer' : 'Suivant',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSlide({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.05),
            color.withValues(alpha: 0.02),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.12),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 72,
                color: color,
              ),
            )
                .animate()
                .scale(duration: const Duration(milliseconds: 700))
                .shimmer(duration: const Duration(milliseconds: 2000)),
            const SizedBox(height: 48),
            Text(
              title,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 500))
                .slideY(begin: 0.3, duration: const Duration(milliseconds: 500)),
            const SizedBox(height: 20),
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: color,
              ),
            )
                .animate()
                .scaleX(duration: const Duration(milliseconds: 800))
                .then()
                .shimmer(duration: const Duration(milliseconds: 1500)),
            const SizedBox(height: 24),
            Text(
              description,
              style: TextStyle(
                fontSize: 17,
                color: AppColors.textGrey,
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 700))
                .slideY(begin: 0.2, duration: const Duration(milliseconds: 700)),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
