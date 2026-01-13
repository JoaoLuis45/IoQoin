import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ioqoin/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../services/onboarding_service.dart';
import '../../../core/routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  final bool isReplay;

  const OnboardingScreen({super.key, this.isReplay = false});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final pages = [
      _OnboardingPage(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
        icon: Icons.account_balance_wallet_outlined,
        color: AppColors.voltCyan,
      ),
      _OnboardingPage(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
        icon: Icons.pie_chart_outline,
        color: AppColors.successGreen,
      ),
      _OnboardingPage(
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
        icon: Icons.flag_outlined,
        color: AppColors.alertRed,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  AppColors.deepFinBlue.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pages.length,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemBuilder: (context, index) => pages[index],
                  ),
                ),

                // Indicators & Buttons
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Indicators
                      Row(
                        children: List.generate(
                          pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppColors.voltCyan
                                  : AppColors.textSecondary.withValues(
                                      alpha: 0.3,
                                    ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      // Action Button
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage < pages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _finishOnboarding();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          backgroundColor: AppColors.voltCyan,
                          foregroundColor: AppColors.deepFinBlue,
                        ),
                        child: Text(
                          _currentPage == pages.length - 1
                              ? (widget.isReplay
                                    ? l10n.close
                                    : l10n.onboardingGetStarted)
                              : l10n.next,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Skip Button
          if (!widget.isReplay && _currentPage < pages.length - 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 20,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: Text(
                  l10n.skip,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _finishOnboarding() {
    if (widget.isReplay) {
      Navigator.pop(context);
    } else {
      context.read<OnboardingService>().markAsSeen();
      // If used in GoRouter redirect, identifying change might be auto.
      // Or we manually navigate to Welcome.
      // But typically, if we are in Onboarding route, update service triggers a refresh?
      // Need to ensuring OnboardingService is a Listenable for router.
      // For now, let's just go to Welcome screen manually just in case.
      context.go(AppRoutes.welcome);
    }
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(icon, size: 80, color: color),
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),

          const SizedBox(height: 48),

          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

          const SizedBox(height: 16),

          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}
