import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';
import '../../auth/services/auth_service.dart';
import 'package:ioqoin/l10n/app_localizations.dart';

class NotificationDrawer extends StatelessWidget {
  const NotificationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final notificationService = context.watch<NotificationService>();
    final userId = authService.user?.uid ?? '';
    final l10n = AppLocalizations.of(context)!;

    // Trigger check moved to MainScreen

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.88,
      backgroundColor: Colors.transparent, // Para o efeito de vidro funcionar
      child: Stack(
        children: [
          // Background com Blur (Glassmorphism)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Theme.of(
                context,
              ).scaffoldBackgroundColor.withValues(alpha: 0.95),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header Premium
                _buildHeader(context, notificationService, userId, l10n),

                // Lista de Notificações
                Expanded(
                  child: StreamBuilder<List<NotificationModel>>(
                    stream: notificationService.getNotifications(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return _buildErrorState(snapshot.error, l10n);
                      }

                      final notifications = snapshot.data ?? [];

                      if (notifications.isEmpty) {
                        return _buildEmptyState(context, l10n);
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        itemCount: notifications.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final note = notifications[index];
                          // Animação em cascata para entrada
                          return _buildNotificationItem(
                                context,
                                note,
                                notificationService,
                                l10n,
                              )
                              .animate(delay: (50 * index).ms)
                              .fadeIn()
                              .slideX(begin: 0.1);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    NotificationService service,
    String userId,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  l10n.notificationsTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).iconTheme.color,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).dividerColor.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Actions Row
          Row(
            children: [
              StreamBuilder<int>(
                stream: service.getUnreadCount(userId),
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;
                  return Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: count > 0
                            ? AppColors.alertRed.withValues(alpha: 0.1)
                            : AppColors.successGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: count > 0
                              ? AppColors.alertRed.withValues(alpha: 0.3)
                              : AppColors.successGreen.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            count > 0
                                ? Icons.mark_email_unread_outlined
                                : Icons.check_circle_outline,
                            size: 14,
                            color: count > 0
                                ? AppColors.alertRed
                                : AppColors.successGreen,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              count > 0
                                  ? l10n.notificationsUnread(count)
                                  : l10n.notificationsAllRead,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: count > 0
                                    ? AppColors.alertRed
                                    : AppColors.successGreen,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              Flexible(
                child: TextButton.icon(
                  onPressed: () => service.markAllAsRead(userId),
                  icon: const Icon(Icons.done_all, size: 16),
                  label: Text(
                    l10n.notificationsMarkAllRead,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 48,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 24),
          Text(
            l10n.notificationsEmptyTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.notificationsEmptyMessage,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object? error, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.alertRed,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.notificationsConnectionError,
              style: TextStyle(
                color: AppColors.pureWhite,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${l10n.notificationsErrorHint}\n$error',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    NotificationModel note,
    NotificationService service,
    AppLocalizations l10n,
  ) {
    Color iconColor;
    IconData iconData;
    Color glowColor;

    switch (note.type) {
      case NotificationType.alert:
        iconColor = AppColors.alertRed;
        glowColor = AppColors.alertRed.withValues(alpha: 0.3);
        iconData = Icons.warning_amber_rounded;
        break;
      case NotificationType.success:
        iconColor = AppColors.successGreen;
        glowColor = AppColors.successGreen.withValues(alpha: 0.3);
        iconData = Icons.emoji_events_rounded;
        break;
      case NotificationType.tip:
        iconColor = const Color(0xFFD946EF); // Fuchsia
        glowColor = const Color(0xFFD946EF).withValues(alpha: 0.3);
        iconData = Icons.lightbulb_rounded;
        break;
      case NotificationType.reminder:
      default:
        iconColor = AppColors.primary;
        glowColor = AppColors.primary.withValues(alpha: 0.3);
        iconData = Icons.calendar_today_rounded;
        break;
    }

    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: AppColors.alertRed.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => service.deleteNotification(note.id),
      child: GestureDetector(
        onTap: () {
          if (!note.isRead) service.markAsRead(note.id);
        },
        child: Container(
          decoration: BoxDecoration(
            color: note.isRead
                ? Theme.of(context).cardColor.withValues(alpha: 0.5)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: note.isRead
                  ? Colors.transparent
                  : iconColor.withValues(alpha: 0.4),
              width: 1,
            ),
            boxShadow: note.isRead
                ? []
                : [
                    BoxShadow(
                      color: glowColor,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: -2,
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Side
              Container(
                width: 4,
                height: 80,
                decoration: BoxDecoration(
                  color: note.isRead ? Colors.transparent : iconColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: note.isRead
                        ? Theme.of(context).dividerColor.withValues(alpha: 0.1)
                        : iconColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    iconData,
                    color: note.isRead ? AppColors.textSecondary : iconColor,
                    size: 20,
                  ),
                ),
              ),

              // Content Side
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 14, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              note.title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: note.isRead
                                        ? FontWeight.w500
                                        : FontWeight.w700,
                                  ),
                            ),
                          ),
                          Text(
                            _formatTime(note.createdAt, l10n),
                            style: TextStyle(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.6,
                              ),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        note.body,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return "${diff.inMinutes}m";
      }
      return "${diff.inHours}h";
    } else if (diff.inDays == 1) {
      return l10n.timeYesterday;
    } else if (diff.inDays < 7) {
      return "${diff.inDays}d";
    } else {
      return DateFormat('dd/MM', l10n.localeName).format(time);
    }
  }
}
