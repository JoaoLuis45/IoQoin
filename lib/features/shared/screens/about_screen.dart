import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:ioqoin/l10n/app_localizations.dart';

/// Tela Sobre o App
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppLocalizations.of(context)!.aboutTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.voltCyan, AppColors.voltCyanDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.voltCyan.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'iQ',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepFinBlue,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text('iQoin', style: Theme.of(context).textTheme.displaySmall),

            const SizedBox(height: 8),

            Text(
              AppLocalizations.of(context)!.drawerVersion,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),

            const SizedBox(height: 48),

            // Descrição
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.aboutDescriptionTitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    AppLocalizations.of(context)!.aboutDescriptionSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.voltCyan,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.aboutDescriptionBody,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Features
            _FeatureItem(
              icon: Icons.account_balance_wallet,
              title: AppLocalizations.of(context)!.aboutFeatureExpenses,
              description: AppLocalizations.of(
                context,
              )!.aboutFeatureExpensesDesc,
            ),
            _FeatureItem(
              icon: Icons.flag,
              title: AppLocalizations.of(context)!.aboutFeatureGoals,
              description: AppLocalizations.of(context)!.aboutFeatureGoalsDesc,
            ),
            _FeatureItem(
              icon: Icons.subscriptions,
              title: AppLocalizations.of(context)!.aboutFeatureSubscriptions,
              description: AppLocalizations.of(
                context,
              )!.aboutFeatureSubscriptionsDesc,
            ),

            const SizedBox(height: 48),

            Text(
              AppLocalizations.of(context)!.aboutCopyright,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.voltCyan.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.voltCyan, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
