import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/subscription_icons.dart';
import '../models/subscription_model.dart';

/// Card de assinatura
class SubscriptionCard extends StatelessWidget {
  final SubscriptionModel subscription;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = subscription.ativo;
    final color = isActive ? AppColors.voltCyan : AppColors.textSecondary;

    return Dismissible(
      key: Key(subscription.id ?? ''),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async => true,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.alertRed,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete_outline,
          color: AppColors.pureWhite,
          size: 28,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? color.withValues(alpha: 0.3) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Ícone
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isActive ? 0.15 : 0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                SubscriptionIcons.getIcon(subscription.icone),
                color: color,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            // Informações
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subscription.nome,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isActive
                          ? Theme.of(context).textTheme.titleMedium?.color
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.voltCyan.withValues(alpha: 0.15)
                              : AppColors.textSecondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          subscription.frequencia.label,
                          style: TextStyle(
                            color: isActive
                                ? AppColors.voltCyan
                                : AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isActive)
                        Flexible(
                          child: Text(
                            'Cobra em ${subscription.diasAteCobranca} dias',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      else
                        Text(
                          'Pausada',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Valor e toggle
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'R\$ ${subscription.valor.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isActive
                        ? AppColors.alertRed
                        : AppColors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onToggle,
                  child: Container(
                    width: 44,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.voltCyan
                          : AppColors.textSecondary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment: isActive
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.pureWhite,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
