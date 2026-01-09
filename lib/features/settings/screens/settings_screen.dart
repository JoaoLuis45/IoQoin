import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Info Card
          _buildInfoCard(context, l10n),
          const SizedBox(height: 24),

          // Theme Settings
          _buildSectionTitle(context, l10n.settingsThemeTitle),
          const SizedBox(height: 12),
          _buildThemeCard(context, themeService, l10n),

          const SizedBox(height: 24),

          // Language Settings
          _buildSectionTitle(context, l10n.settingsLanguageTitle),
          const SizedBox(height: 12),
          _buildLanguageCard(context, localeService),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.voltCyan.withValues(alpha: 0.2)),
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
          const SizedBox(width: 16),
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
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildThemeCard(
    BuildContext context,
    ThemeService themeService,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildRadioTile<ThemeMode>(
            context,
            title: l10n.settingsThemeSystem,
            value: ThemeMode.system,
            groupValue: themeService.themeMode,
            onChanged: (val) => themeService.setThemeMode(val!),
            icon: Icons.brightness_auto,
          ),
          const Divider(height: 1, indent: 56, endIndent: 20),
          _buildRadioTile<ThemeMode>(
            context,
            title: l10n.settingsThemeLight,
            value: ThemeMode.light,
            groupValue: themeService.themeMode,
            onChanged: (val) => themeService.setThemeMode(val!),
            icon: Icons.light_mode,
          ),
          const Divider(height: 1, indent: 56, endIndent: 20),
          _buildRadioTile<ThemeMode>(
            context,
            title: l10n.settingsThemeDark,
            value: ThemeMode.dark,
            groupValue: themeService.themeMode,
            onChanged: (val) => themeService.setThemeMode(val!),
            icon: Icons.dark_mode,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, LocaleService localeService) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildRadioTile<String>(
            context,
            title: 'Português',
            value: 'pt',
            groupValue: localeService.locale.languageCode,
            onChanged: (val) => localeService.setLocale(Locale(val!)),
            icon: Icons
                .language, // Flag icons could be better here if assets exist
            isFirst: true,
          ),
          const Divider(height: 1, indent: 56, endIndent: 20),
          _buildRadioTile<String>(
            context,
            title: 'English',
            value: 'en',
            groupValue: localeService.locale.languageCode,
            onChanged: (val) => localeService.setLocale(Locale(val!)),
            icon: Icons.language,
          ),
          const Divider(height: 1, indent: 56, endIndent: 20),
          _buildRadioTile<String>(
            context,
            title: 'Español',
            value: 'es',
            groupValue: localeService.locale.languageCode,
            onChanged: (val) => localeService.setLocale(Locale(val!)),
            icon: Icons.language,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRadioTile<T>(
    BuildContext context, {
    required String title,
    required T value,
    required T groupValue,
    required ValueChanged<T?> onChanged,
    required IconData icon,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.only(
        topLeft: isFirst ? const Radius.circular(16) : Radius.zero,
        topRight: isFirst ? const Radius.circular(16) : Radius.zero,
        bottomLeft: isLast ? const Radius.circular(16) : Radius.zero,
        bottomRight: isLast ? const Radius.circular(16) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.voltCyan.withValues(alpha: 0.1)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected
                    ? AppColors.voltCyan
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isSelected
                      ? AppColors.voltCyan
                      : Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.voltCyan,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
