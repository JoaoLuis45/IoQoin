import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../shared/services/firestore_service.dart';
import '../../environments/services/environment_service.dart';
import '../models/transaction_model.dart';
import '../widgets/add_transaction_sheet.dart';
import '../widgets/fixed_transaction_manager_sheet.dart';
import '../widgets/transaction_card.dart';
import '../widgets/filter_transaction_sheet.dart';
import 'package:ioqoin/l10n/app_localizations.dart';

/// Aba de Receitas
class IncomeTab extends StatefulWidget {
  final String userId;
  final int month;
  final int year;
  final bool canAdd;

  const IncomeTab({
    super.key,
    required this.userId,
    required this.month,
    required this.year,
    this.canAdd = true,
  });

  @override
  State<IncomeTab> createState() => _IncomeTabState();
}

class _IncomeTabState extends State<IncomeTab> {
  // Filtros
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  double? _filterMinValue;
  double? _filterMaxValue;
  List<String> _selectedCategoryIds = [];

  bool get _hasActiveFilters =>
      _filterStartDate != null ||
      _filterEndDate != null ||
      _filterMinValue != null ||
      _filterMaxValue != null ||
      _selectedCategoryIds.isNotEmpty;

  void _showFilterSheet() {
    // Definir limites do mês atual para o date picker
    final firstDate = DateTime(widget.year, widget.month, 1);
    final lastDate = DateTime(widget.year, widget.month + 1, 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => FilterTransactionSheet(
        transactionType: TransactionType.income,
        initialDate: firstDate,
        finalDate: lastDate,
        filterStartDate: _filterStartDate,
        filterEndDate: _filterEndDate,
        filterMinValue: _filterMinValue,
        filterMaxValue: _filterMaxValue,
        selectedCategoryIds: _selectedCategoryIds,
        onApply: (start, end, min, max, categories) {
          setState(() {
            _filterStartDate = start;
            _filterEndDate = end;
            _filterMinValue = min;
            _filterMaxValue = max;
            _selectedCategoryIds = categories;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = context.watch<FirestoreService>();
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      fit: StackFit.expand,
      children: [
        CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),

            // Header (Título e Botões)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.yourIncomeTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    Row(
                      children: [
                        // Botão Filtrar
                        TextButton.icon(
                          onPressed: _showFilterSheet,
                          icon: Icon(
                            _hasActiveFilters
                                ? Icons.filter_alt
                                : Icons.filter_alt_outlined,
                            size: 18,
                            color: _hasActiveFilters
                                ? AppColors.voltCyan
                                : AppColors.textSecondary,
                          ),
                          label: Text(
                            '${l10n.filterLabel}${_hasActiveFilters ? " •" : ""}',
                            style: TextStyle(
                              color: _hasActiveFilters
                                  ? AppColors.voltCyan
                                  : AppColors.textSecondary,
                              fontWeight: _hasActiveFilters
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: _hasActiveFilters
                                ? AppColors.voltCyan.withValues(alpha: 0.1)
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Botão Fixas
                        TextButton.icon(
                          onPressed: () => _showFixedManager(context),
                          icon: const Icon(Icons.bookmark_border, size: 18),
                          label: Text(l10n.fixedLabel),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.successGreen,
                            backgroundColor: AppColors.successGreen.withValues(
                              alpha: 0.1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Lista de receitas
            StreamBuilder<List<TransactionModel>>(
              stream: firestoreService.getIncomes(
                widget.userId,
                context.watch<EnvironmentService>().currentEnvironment?.id ??
                    '',
                month: widget.month,
                year: widget.year,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.voltCyan,
                      ),
                    ),
                  );
                }

                var transactions = snapshot.data ?? [];

                // Aplicar filtros no cliente
                if (_hasActiveFilters) {
                  transactions = transactions.where((t) {
                    // Filtro de Data
                    if (_filterStartDate != null &&
                        t.data.isBefore(
                          _filterStartDate!.subtract(const Duration(days: 1)),
                        )) {
                      return false;
                    }
                    if (_filterEndDate != null &&
                        t.data.isAfter(
                          _filterEndDate!.add(const Duration(days: 1)),
                        )) {
                      return false;
                    }

                    // Filtro de Valor
                    if (_filterMinValue != null && t.valor < _filterMinValue!) {
                      return false;
                    }
                    if (_filterMaxValue != null && t.valor > _filterMaxValue!) {
                      return false;
                    }

                    // Filtro de Categoria
                    if (_selectedCategoryIds.isNotEmpty &&
                        !_selectedCategoryIds.contains(t.categoryId)) {
                      return false;
                    }

                    return true;
                  }).toList();
                }

                if (transactions.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(context, l10n),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final transaction = transactions[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:
                          TransactionCard(
                                transaction: transaction,
                                onDelete: widget.canAdd
                                    ? () => firestoreService.deleteTransaction(
                                        transaction.id!,
                                      )
                                    : () {},
                                canDelete: widget.canAdd,
                              )
                              .animate(
                                delay: Duration(milliseconds: index * 50),
                              )
                              .fadeIn()
                              .slideX(begin: 0.1),
                    );
                  }, childCount: transactions.length),
                );
              },
            ),

            // Espaço final para não cobrir o item com FAB
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),

        // FAB
        if (widget.canAdd)
          Positioned(right: 20, bottom: 20, child: _buildAnimatedFAB(context)),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    // Se tiver filtros ativos e lista vazia, muda a mensagem
    final isFiltered = _hasActiveFilters;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFiltered
                ? Icons.filter_list_off
                : Icons.account_balance_wallet_outlined,
            size: 80,
            color: AppColors.successGreen.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            isFiltered
                ? l10n.noIncomeFound
                : (widget.canAdd
                      ? l10n.noIncomeRegistered
                      : l10n.noIncomeThisMonth),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            isFiltered
                ? l10n.adjustFiltersTip
                : (widget.canAdd ? l10n.tapToAddTip : l10n.viewOnlyLabel),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 500.ms),
    );
  }

  Widget _buildAnimatedFAB(BuildContext context) {
    return GestureDetector(
          onTap: () => _showAddTransaction(context),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.successGreen, Color(0xFF00E88F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.successGreen.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: AppColors.pureWhite, size: 32),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.05, 1.05),
          duration: 1500.ms,
          curve: Curves.easeInOut,
        );
  }

  void _showFixedManager(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FixedTransactionManagerSheet(
        userId: widget.userId,
        transactionType: TransactionType.income,
      ),
    );
  }

  void _showAddTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTransactionSheet(
        userId: widget.userId,
        transactionType: TransactionType.income,
      ),
    );
  }
}
