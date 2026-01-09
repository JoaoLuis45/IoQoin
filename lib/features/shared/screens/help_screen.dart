import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ioqoin/l10n/app_localizations.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    // Lista de FAQs
    final List<Map<String, String>> _faqs = [
      {
        'question': AppLocalizations.of(context)!.helpFaq1Question,
        'answer': AppLocalizations.of(context)!.helpFaq1Answer,
      },
      {
        'question': AppLocalizations.of(context)!.helpFaq2Question,
        'answer': AppLocalizations.of(context)!.helpFaq2Answer,
      },
      {
        'question': AppLocalizations.of(context)!.helpFaq3Question,
        'answer': AppLocalizations.of(context)!.helpFaq3Answer,
      },
      {
        'question': AppLocalizations.of(context)!.helpFaq4Question,
        'answer': AppLocalizations.of(context)!.helpFaq4Answer,
      },
      {
        'question': AppLocalizations.of(context)!.helpFaq5Question,
        'answer': AppLocalizations.of(context)!.helpFaq5Answer,
      },
      {
        'question': AppLocalizations.of(context)!.helpFaq6Question,
        'answer': AppLocalizations.of(context)!.helpFaq6Answer,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.helpTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Cabeçalho
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.voltCyan.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.help_outline,
                    size: 40,
                    color: AppColors.voltCyan,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.helpHeaderTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.helpHeaderSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),

          const SizedBox(height: 32),

          // FAQ List
          ..._faqs.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _buildFaqItem(item['question']!, item['answer']!)
                .animate(delay: Duration(milliseconds: index * 100))
                .fadeIn()
                .slideX(begin: 0.1);
          }),

          const SizedBox(height: 32),

          // Contato (Placeholder)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.voltCyan.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.helpContactTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.helpContactSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () async {
                      const phoneNumber = '5581997947843';
                      final url = Uri.parse('https://wa.me/$phoneNumber');
                      try {
                        if (!await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        )) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.helpWhatsappError,
                                ),
                                backgroundColor: AppColors.alertRed,
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.helpWhatsappError,
                              ),
                              backgroundColor: AppColors.alertRed,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.chat),
                    label: Text(
                      AppLocalizations.of(context)!.helpWhatsappButton,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 600.ms),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            question,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          iconColor: AppColors.voltCyan,
          collapsedIconColor: AppColors.textSecondary,
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Text(
              answer,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
