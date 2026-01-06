import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../auth/services/auth_service.dart';

/// Menu lateral (Drawer) do app
class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final user = authService.userModel;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header com informações do usuário
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.divider, width: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.voltCyan,
                    backgroundImage: user?.fotoUrl != null
                        ? NetworkImage(user!.fotoUrl!)
                        : null,
                    child: user?.fotoUrl == null
                        ? Text(
                            _getInitials(user?.nome ?? 'U'),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepFinBlue,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Nome
                  Text(
                    user?.nome ?? 'Usuário',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  // Email
                  Text(
                    user?.email ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Menu Items
            _DrawerItem(
              icon: Icons.person_outlined,
              label: 'Perfil',
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.profile);
              },
            ),
            _DrawerItem(
              icon: Icons.help_outline,
              label: 'Ajuda',
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.help);
              },
            ),
            _DrawerItem(
              icon: Icons.info_outline,
              label: 'Sobre o app',
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.about);
              },
            ),

            const Spacer(),

            // Sair
            const Divider(height: 1, color: AppColors.divider),
            _DrawerItem(
              icon: Icons.logout,
              label: 'Sair',
              isDestructive: true,
              onTap: () async {
                final confirmed = await _showLogoutDialog(context);
                if (confirmed && context.mounted) {
                  await authService.signOut();
                  if (context.mounted) {
                    context.go(AppRoutes.welcome);
                  }
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }

  Future<bool> _showLogoutDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.deepFinBlueLight,
            title: const Text('Sair'),
            content: const Text('Tem certeza que deseja sair?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.alertRed,
                ),
                child: const Text('Sair'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.alertRed : AppColors.pureWhite;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}
