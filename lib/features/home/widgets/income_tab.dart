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

/// Aba de Receitas
class IncomeTab extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final firestoreService = context.watch<FirestoreService>();

    return Stack(
      fit: StackFit.expand,
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),

            // Gerenciar categorias (Header)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Suas receitas',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    TextButton.icon(
                      onPressed: () => _showFixedManager(context),
                      icon: const Icon(Icons.bookmark_border, size: 18),
                      label: const Text('Fixas'),
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
              ),
            ),

            // Lista de receitas
            StreamBuilder<List<TransactionModel>>(
              stream: firestoreService.getIncomes(
                userId,
                context.watch<EnvironmentService>().currentEnvironment?.id ??
                    '',
                month: month,
                year: year,
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

                final transactions = snapshot.data ?? [];

                if (transactions.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(context),
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
                                onDelete: canAdd
                                    ? () => firestoreService.deleteTransaction(
                                        transaction.id!,
                                      )
                                    : () {},
                                canDelete: canAdd,
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
        if (canAdd)
          Positioned(right: 20, bottom: 20, child: _buildAnimatedFAB(context)),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: AppColors.successGreen.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            canAdd ? 'Nenhuma receita registrada' : 'Nenhuma receita neste mês',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            canAdd ? 'Toque no + para adicionar' : 'Apenas visualização',
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
        userId: userId,
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
        userId: userId,
        transactionType: TransactionType.income,
      ),
    );
  }
}
