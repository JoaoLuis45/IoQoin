import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/services/auth_service.dart';
import '../../shared/services/firestore_service.dart';
import '../../shared/services/sync_service.dart';
import '../../environments/services/environment_service.dart';
import '../models/subscription_model.dart';
import '../widgets/add_subscription_sheet.dart';
import '../widgets/subscription_card.dart';

import 'package:ioqoin/l10n/app_localizations.dart';

/// Tela de Inscrições (Assinaturas Recorrentes)
class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final firestoreService = context.watch<FirestoreService>();
    final userId = authService.user?.uid ?? '';
    final envId =
        context.watch<EnvironmentService>().currentEnvironment?.id ?? '';

    return Column(
      children: [
        // Header com resumo
        _buildHeader(context, userId, firestoreService),

        const SizedBox(height: 16),

        // Lista de inscrições
        Expanded(
          child: StreamBuilder<List<SubscriptionModel>>(
            stream: firestoreService.getSubscriptions(userId, envId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.voltCyan),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    AppLocalizations.of(
                      context,
                    )!.goalsLoadError(snapshot.error.toString()),
                  ),
                );
              }

              final subscriptions = snapshot.data ?? [];

              if (subscriptions.isEmpty) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<SyncService>().reload();
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                backgroundColor: AppColors.deepFinBlueLight,
                color: AppColors.voltCyan,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  itemCount: subscriptions.length,
                  itemBuilder: (context, index) {
                    final subscription = subscriptions[index];
                    return SubscriptionCard(
                          subscription: subscription,
                          onToggle: () => _toggleSubscription(
                            context,
                            firestoreService,
                            subscription,
                          ),
                          onDelete: () => _confirmDelete(
                            context,
                            firestoreService,
                            subscription,
                          ),
                        )
                        .animate(delay: Duration(milliseconds: index * 50))
                        .fadeIn()
                        .slideX(begin: 0.1);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    String userId,
    FirestoreService firestoreService,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColors.deepFinBlueLight,
                  AppColors.deepFinBlueLight.withValues(alpha: 0.8),
                ]
              : [
                  Theme.of(context).cardColor,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.voltCyan.withValues(alpha: 0.2)
              : Theme.of(context).dividerColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.subscriptionsTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              IconButton(
                onPressed: () => _showAddSubscriptionSheet(context),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.voltCyan.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add, color: AppColors.voltCyan),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.subscriptionsSubtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          // Total mensal
          StreamBuilder<List<SubscriptionModel>>(
            stream: firestoreService.getSubscriptions(
              userId,
              context.watch<EnvironmentService>().currentEnvironment?.id ?? '',
            ),
            builder: (context, snapshot) {
              final subscriptions = snapshot.data ?? [];
              final total = subscriptions
                  .where((s) => s.ativo)
                  .fold<double>(0, (sum, s) => sum + s.valorMensal);

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.subscriptionsTotalMonthly,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'R\$ ${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.alertRed,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.voltCyan.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.subscriptionsActiveCount(
                        subscriptions.where((s) => s.ativo).length,
                      ),
                      style: const TextStyle(
                        color: AppColors.voltCyan,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.voltCyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.subscriptions_outlined,
              size: 50,
              color: AppColors.voltCyan.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.subscriptionsEmptyTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.subscriptionsEmptyMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showAddSubscriptionSheet(context),
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context)!.subscriptionsAddButton),
          ),
        ],
      ).animate().fadeIn(duration: 500.ms),
    );
  }

  void _showAddSubscriptionSheet(BuildContext context) {
    final authService = context.read<AuthService>();
    final userId = authService.user?.uid;

    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.userUnidentifiedError),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) => AddSubscriptionSheet(userId: userId),
    );
  }

  void _toggleSubscription(
    BuildContext context,
    FirestoreService firestoreService,
    SubscriptionModel subscription,
  ) async {
    await firestoreService.updateSubscription(
      subscription.copyWith(ativo: !subscription.ativo),
    );
  }

  void _confirmDelete(
    BuildContext context,
    FirestoreService firestoreService,
    SubscriptionModel subscription,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Text(
          AppLocalizations.of(context)!.subscriptionsDeleteTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          AppLocalizations.of(
            context,
          )!.subscriptionsDeleteMessage(subscription.nome),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              await firestoreService.deleteSubscription(subscription.id!);
              if (context.mounted) Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.alertRed),
            child: Text(AppLocalizations.of(context)!.deleteButton),
          ),
        ],
      ),
    );
  }
}
