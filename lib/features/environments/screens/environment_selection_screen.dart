import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:ioqoin/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/services/auth_service.dart';
import '../../invites/services/invite_service.dart';
import '../../invites/models/invite_model.dart';
import '../models/environment_model.dart';
import '../services/environment_service.dart';
import '../../../../core/constants/global_keys.dart';
import 'environment_form_screen.dart';
import '../../../../core/utils/icon_utils.dart';

class EnvironmentSelectionScreen extends StatelessWidget {
  const EnvironmentSelectionScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final userId = authService.user?.uid ?? '';
    final userTag = authService.userModel?.userTag ?? '';
    final envService = context.watch<EnvironmentService>();
    final inviteService = context.watch<InviteService>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.myEnvironmentsTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (userTag.isNotEmpty)
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: userTag));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.tagCopied),
                      backgroundColor: AppColors.successGreen,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tag: $userTag',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.voltCyan.withValues(alpha: 0.9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.copy_rounded,
                        size: 12,
                        color: AppColors.voltCyan.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              )
            else
              Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.voltCyan.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.generatingId,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.voltCyan.withValues(alpha: 0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        actions: [
          StreamBuilder<List<InviteModel>>(
            stream: inviteService.watchMyInvites(userId),
            builder: (context, snapshot) {
              final invites = snapshot.data ?? [];
              final hasInvites = invites.isNotEmpty;

              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.mail_outline),
                    onPressed: () =>
                        _showPendingInvites(context, invites, l10n),
                  ),
                  if (hasInvites)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.alertRed,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 8,
                          minHeight: 8,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<List<EnvironmentModel>>(
        stream: envService.getUserEnvironments(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                l10n.errorLoadingEnvironments,
                style: const TextStyle(color: AppColors.alertRed),
              ),
            );
          }

          final environments = snapshot.data ?? [];

          return CustomScrollView(
            slivers: [
              // Premium Info Section
              SliverToBoxAdapter(child: _buildInfoSection(context, l10n)),

              // Title
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    l10n.yourEnvironmentsSection,
                    style: TextStyle(
                      color: AppColors.voltCyan,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              // Environment List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final env = environments[index];
                    final isSelected =
                        env.id == envService.currentEnvironment?.id;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildEnvironmentCard(
                        context,
                        env,
                        isSelected,
                        userId,
                        l10n,
                      ),
                    );
                  }, childCount: environments.length),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ).animate().fadeIn(duration: 300.ms);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const EnvironmentFormScreen(),
            ),
          );
        },
        backgroundColor: AppColors.voltCyan,
        child: const Icon(Icons.add, color: AppColors.deepFinBlue),
      ),
    );
  }

  // ... (Info methods unchanged)
  Widget _buildInfoSection(BuildContext context, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF2A2D3E), // Darker shade
                  AppColors.deepFinBlueLight.withValues(alpha: 0.8),
                ]
              : [
                  Theme.of(context).cardColor,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.voltCyan.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.voltCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.layers_outlined,
                  color: AppColors.voltCyan,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  l10n.howItWorksTitle,
                  style: const TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.howItWorksDescription,
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            icon: Icons.person_outline,
            text: l10n.personalEnvironment,
          ),
          const SizedBox(height: 8),
          _buildInfoItem(icon: Icons.work_outline, text: l10n.workEnvironment),
          const SizedBox(height: 8),
          _buildInfoItem(
            icon: Icons.flight_takeoff,
            text: l10n.travelEnvironment,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.voltCyan.withValues(alpha: 0.7), size: 16),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnvironmentCard(
    BuildContext context,
    EnvironmentModel env,
    bool isSelected,
    String currentUserId,
    AppLocalizations l10n,
  ) {
    final color = Color(int.parse(env.colorHex));
    final isShared = env.isShared;

    return Card(
      elevation: 0,
      color: isSelected
          ? color.withValues(alpha: 0.15)
          : Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isShared
                    ? Icons.groups
                    : IconUtils.getEnvironmentIcon(env.iconCodePoint),
                color: color,
                size: 24,
              ),
            ),
            if (isShared)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.deepFinBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.share,
                    size: 12,
                    color: AppColors.pureWhite,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          env.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (env.isDefault)
              Text(
                l10n.defaultTag,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            if (isShared)
              Text(
                l10n.sharedTag,
                style: TextStyle(
                  color: AppColors.voltCyan.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isShared) // Only show invite button for owned environments
              IconButton(
                icon: const Icon(Icons.person_add, color: AppColors.voltCyan),
                onPressed: () => _showInviteDialog(context, env, l10n),
                tooltip: l10n.inviteTooltip,
              )
            else // Show leave button for shared environments
              IconButton(
                icon: const Icon(Icons.exit_to_app, color: AppColors.alertRed),
                onPressed: () => _confirmLeaveEnvironment(context, env, l10n),
                tooltip: l10n.leaveTooltip,
              ),
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.textSecondary),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        EnvironmentFormScreen(environment: env),
                  ),
                );
              },
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: color)
            else
              IconButton(
                icon: const Icon(Icons.login, color: AppColors.voltCyan),
                onPressed: () {
                  context.read<EnvironmentService>().setEnvironment(env);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
        onTap: () {
          context.read<EnvironmentService>().setEnvironment(env);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showInviteDialog(
    BuildContext parentContext,
    EnvironmentModel env,
    AppLocalizations l10n,
  ) {
    final tagController = TextEditingController();
    final inviteService = parentContext.read<InviteService>();
    final authService = parentContext.read<AuthService>();

    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(dialogContext).dialogBackgroundColor,
        title: Text(
          l10n.inviteUserTitle,
          style: Theme.of(dialogContext).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.inviteUserMessage(env.name),
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tagController,
              style: Theme.of(dialogContext).textTheme.bodyLarge,
              decoration: InputDecoration(
                labelText: l10n.userTagLabel,
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                hintText: '#XXXXX',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textSecondary),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.voltCyan),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.voltCyan,
            ),
            onPressed: () async {
              try {
                debugPrint('InviteDialog: Botão Enviar pressionado.');
                final tag = tagController.text.trim();
                if (tag.isEmpty) return;

                Navigator.pop(dialogContext); // Close dialog

                final error = await inviteService.sendInvite(
                  fromUserId: authService.user!.uid,
                  fromUserName: authService.userModel?.nome ?? 'Usuário',
                  toUserTag: tag,
                  environment: env,
                );

                if (error == null) {
                  rootScaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(
                      content: Text(l10n.inviteSentSuccess),
                      backgroundColor: AppColors.successGreen,
                    ),
                  );
                } else {
                  rootScaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(
                      content: Text(error),
                      backgroundColor: AppColors.alertRed,
                    ),
                  );
                }
              } catch (e) {
                debugPrint('InviteDialog: Erro crítico na UI: $e');
                rootScaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBar(
                    content: Text('Erro interno ao processar: $e'),
                    backgroundColor: AppColors.alertRed,
                  ),
                );
              }
            },
            child: Text(
              l10n.send,
              style: const TextStyle(color: AppColors.deepFinBlue),
            ),
          ),
        ],
      ),
    );
  }

  void _showPendingInvites(
    BuildContext context,
    List<InviteModel> invites,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.pendingInvitesTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (invites.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    l10n.noPendingInvites,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                itemCount: invites.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final invite = invites[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.voltCyan.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invite.environmentName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.invitedBy(invite.fromUserName),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                final service = context.read<InviteService>();
                                await service.rejectInvite(invite.id);
                                if (context.mounted) Navigator.pop(context);
                              },
                              child: Text(
                                l10n.decline,
                                style: const TextStyle(
                                  color: AppColors.alertRed,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.voltCyan,
                              ),
                              onPressed: () async {
                                final service = context.read<InviteService>();
                                final auth = context.read<AuthService>();
                                await service.acceptInvite(
                                  invite,
                                  auth.user!.uid,
                                );
                                if (context.mounted) Navigator.pop(context);
                              },
                              child: Text(
                                l10n.accept,
                                style: const TextStyle(
                                  color: AppColors.deepFinBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _confirmLeaveEnvironment(
    BuildContext parentContext,
    EnvironmentModel env,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(dialogContext).dialogBackgroundColor,
        title: Text(
          l10n.leaveEnvironmentTitle,
          style: Theme.of(dialogContext).textTheme.titleLarge,
        ),
        content: Text(
          l10n.leaveEnvironmentMessage(env.name),
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.alertRed,
            ),
            onPressed: () async {
              Navigator.pop(dialogContext); // Close dialog
              try {
                final inviteService = parentContext.read<InviteService>();
                final authService = parentContext.read<AuthService>();

                final success = await inviteService.leaveSharedEnvironment(
                  env.id!,
                  authService.user!.uid,
                );

                if (success) {
                  rootScaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(
                      content: Text(l10n.leaveSuccess),
                      backgroundColor: AppColors.successGreen,
                    ),
                  );
                } else {
                  rootScaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(
                      content: Text(l10n.leaveError),
                      backgroundColor: AppColors.alertRed,
                    ),
                  );
                }
              } catch (e) {
                rootScaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBar(
                    content: Text('Erro: $e'),
                    backgroundColor: AppColors.alertRed,
                  ),
                );
              }
            },
            child: Text(
              l10n.leaveButton,
              style: const TextStyle(color: AppColors.pureWhite),
            ),
          ),
        ],
      ),
    );
  }
}
