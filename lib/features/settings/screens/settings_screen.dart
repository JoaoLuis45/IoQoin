import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ioqoin/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../services/theme_service.dart';
import '../services/locale_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeService = context.watch<ThemeService>();
    final localeService = context.watch<LocaleService>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        backgroundColor: Theme.of(
          context,
        ).scaffoldBackgroundColor.withValues(alpha: 0.8),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
        children: [
          // Info Card
          _buildInfoCard(context, l10n),
          const SizedBox(height: 32),

          // Theme Settings
          _buildSectionTitle(context, l10n.settingsThemeTitle),
          const SizedBox(height: 16),
          _buildThemeSelector(context, themeService, l10n),

          const SizedBox(height: 32),

          // Language Settings
          _buildSectionTitle(context, l10n.settingsLanguageTitle),
          const SizedBox(height: 16),
          _buildLanguageSelector(context, localeService),

          const SizedBox(height: 32),

          // Tutorial
          _buildTutorialButton(context, l10n),
        ].animate(interval: 50.ms).fadeIn().slideY(begin: 10, end: 0),
      ),
    );
  }

  Widget _buildTutorialButton(BuildContext context, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.pushNamed(
            'onboarding',
            queryParameters: {'replay': 'true'},
          ),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.voltCyan.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_circle_outline,
                    color: AppColors.voltCyan,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    l10n.settingsReplayTutorial,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.voltCyan.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.voltCyan.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.voltCyan.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.perm_device_information,
              color: AppColors.voltCyan,
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsInfoTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.settingsInfoDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildThemeSelector(
    BuildContext context,
    ThemeService themeService,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        _buildOptionTile<ThemeMode>(
          context: context,
          title: l10n.settingsThemeSystem,
          subtitle: 'Automático',
          value: ThemeMode.system,
          groupValue: themeService.themeMode,
          onChanged: (val) => themeService.setThemeMode(val!),
          icon: Icons.brightness_auto_outlined,
        ),
        const SizedBox(height: 12),
        _buildOptionTile<ThemeMode>(
          context: context,
          title: l10n.settingsThemeLight,
          subtitle: 'Claro',
          value: ThemeMode.light,
          groupValue: themeService.themeMode,
          onChanged: (val) => themeService.setThemeMode(val!),
          icon: Icons.light_mode_outlined,
        ),
        const SizedBox(height: 12),
        _buildOptionTile<ThemeMode>(
          context: context,
          title: l10n.settingsThemeDark,
          subtitle: 'Escuro',
          value: ThemeMode.dark,
          groupValue: themeService.themeMode,
          onChanged: (val) => themeService.setThemeMode(val!),
          icon: Icons.dark_mode_outlined,
        ),
      ],
    );
  }

  Widget _buildLanguageSelector(
    BuildContext context,
    LocaleService localeService,
  ) {
    return Column(
      children: [
        _buildOptionTile<String>(
          context: context,
          title: 'Português',
          subtitle: 'Brasil',
          value: 'pt',
          groupValue: localeService.locale.languageCode,
          onChanged: (val) => localeService.setLocale(Locale(val!)),
          emoji: '🇧🇷',
        ),
        const SizedBox(height: 12),
        _buildOptionTile<String>(
          context: context,
          title: 'English',
          subtitle: 'United States',
          value: 'en',
          groupValue: localeService.locale.languageCode,
          onChanged: (val) => localeService.setLocale(Locale(val!)),
          emoji: '🇺🇸',
        ),
        const SizedBox(height: 12),
        _buildOptionTile<String>(
          context: context,
          title: 'Español',
          subtitle: 'España',
          value: 'es',
          groupValue: localeService.locale.languageCode,
          onChanged: (val) => localeService.setLocale(Locale(val!)),
          emoji: '🇪🇸',
        ),
      ],
    );
  }

  Widget _buildOptionTile<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required T value,
    required T groupValue,
    required ValueChanged<T?> onChanged,
    IconData? icon,
    String? emoji,
  }) {
    final isSelected = value == groupValue;
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.voltCyan.withValues(alpha: 0.1)
            : theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.voltCyan : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.voltCyan.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(value),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon or Flag
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.voltCyan
                        : theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: emoji != null
                        ? Text(emoji, style: const TextStyle(fontSize: 24))
                        : Icon(
                            icon,
                            color: isSelected
                                ? AppColors.pureWhite
                                : AppColors.textSecondary,
                            size: 24,
                          ),
                  ),
                ),
                const SizedBox(width: 16),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: isSelected
                              ? theme.textTheme.titleMedium?.color
                              : AppColors.textSecondary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? AppColors.voltCyan
                                : AppColors.textSecondary.withValues(
                                    alpha: 0.5,
                                  ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Check Indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.voltCyan
                          : AppColors.textSecondary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    color: isSelected ? AppColors.voltCyan : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
