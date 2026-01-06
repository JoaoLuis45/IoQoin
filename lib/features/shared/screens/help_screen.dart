import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Tela de Ajuda (placeholder)
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Ajuda'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.help_outlined,
              size: 80,
              color: AppColors.voltCyan.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text('Ajuda', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Em breve: tire suas dúvidas\nsobre o IoQoin',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
