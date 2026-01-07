import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/services/auth_service.dart';
import '../../shared/services/firestore_service.dart';
import '../../environments/services/environment_service.dart';
import '../models/subscription_model.dart';
import '../widgets/add_subscription_sheet.dart';
import '../widgets/subscription_card.dart';

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
                  child: Text('Erro ao carregar inscrições: ${snapshot.error}'),
                );
              }

              final subscriptions = snapshot.data ?? [];

              if (subscriptions.isEmpty) {
                return _buildEmptyState(context);
              }

              return ListView.builder(
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
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.deepFinBlueLight,
            AppColors.deepFinBlueLight.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.voltCyan.withValues(alpha: 0.2),
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
                  'Minhas Assinaturas',
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
            'Acompanhe seus gastos recorrentes',
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
                        'Total mensal',
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
                      '${subscriptions.where((s) => s.ativo).length} ativas',
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
            'Nenhuma assinatura cadastrada',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione suas assinaturas\npara acompanhar os gastos',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showAddSubscriptionSheet(context),
            icon: const Icon(Icons.add),
            label: const Text('Adicionar assinatura'),
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
        const SnackBar(content: Text('Erro: Usuário não identificado')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
        backgroundColor: AppColors.deepFinBlueLight,
        title: const Text('Excluir assinatura'),
        content: Text('Deseja excluir "${subscription.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await firestoreService.deleteSubscription(subscription.id!);
              if (context.mounted) Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.alertRed),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
