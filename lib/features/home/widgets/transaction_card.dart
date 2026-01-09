import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/category_icons.dart';
import '../models/transaction_model.dart';
import 'package:ioqoin/l10n/app_localizations.dart';

/// Card de transação (receita ou despesa)
class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onDelete;
  final bool canDelete;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.onDelete,
    this.canDelete = true,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.isExpense;
    final color = isExpense ? AppColors.alertRed : AppColors.successGreen;
    final icon = CategoryIcons.getIcon(
      transaction.categoryName.toLowerCase().replaceAll(' ', '_'),
      isExpense: isExpense,
    );
    final l10n = AppLocalizations.of(context)!;

    final cardWidget = Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          // Ícone da categoria
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),

          const SizedBox(width: 16),

          // Informações
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.categoryName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(transaction.data, l10n),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (transaction.descricao != null &&
                        transaction.descricao!.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          transaction.descricao!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Valor
          Text(
            '${isExpense ? '-' : '+'} R\$ ${transaction.valor.toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    // Se não pode deletar, retorna apenas o card
    if (!canDelete) {
      return cardWidget;
    }

    // Com Dismissible para deletar
    return Dismissible(
      key: Key(transaction.id ?? ''),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmation(context, l10n);
      },
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
      child: cardWidget,
    );
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return l10n.today;
    } else if (transactionDate == yesterday) {
      return l10n.yesterday;
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  Future<bool> _showDeleteConfirmation(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
            title: Text(l10n.deleteTransactionTitle),
            content: Text(l10n.deleteTransactionMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.alertRed,
                ),
                child: Text(l10n.deleteButton),
              ),
            ],
          ),
        ) ??
        false;
  }
}
