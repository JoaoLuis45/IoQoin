import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../auth/services/auth_service.dart';

/// Menu lateral (Drawer) do app com visual aprimorado
class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final user = authService.userModel;

    // Obtém o user do Auth para garantir photoURL atualizado (caso userModel esteja defasado)
    final authUser = authService.user;
    final photoUrl = authUser?.photoURL ?? user?.fotoUrl;
    final displayName = authUser?.displayName ?? user?.nome ?? 'Usuário';
    final email = authUser?.email ?? user?.email ?? '';

    return Drawer(
      backgroundColor: AppColors.deepFinBlue,
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header com Gradiente
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.deepFinBlueLight, AppColors.deepFinBlue],
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.deepFinBlueLight, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo e Nome do App
                Row(
                  children: [
                    Image.asset('assets/images/logo.png', height: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'iQoin',
                      style: TextStyle(
                        color: AppColors.pureWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Perfil do Usuário
                Row(
                  children: [
                    // Avatar com Glow
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.voltCyan.withValues(alpha: 0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border.all(color: AppColors.voltCyan, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.deepFinBlue,
                        backgroundImage: photoUrl != null
                            ? NetworkImage(photoUrl)
                            : null,
                        // Força refresh visual se URL mudar
                        key: ValueKey(photoUrl),
                        child: photoUrl == null
                            ? Text(
                                _getInitials(displayName),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.voltCyan,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Textos do Usuário
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              color: AppColors.pureWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: TextStyle(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.8,
                              ),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (user?.userTag != null &&
                              user!.userTag!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(text: user!.userTag!),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Tag copiada!'),
                                    backgroundColor: AppColors.successGreen,
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.voltCyan.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: AppColors.voltCyan.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      user!.userTag!,
                                      style: TextStyle(
                                        color: AppColors.voltCyan,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.copy_rounded,
                                      size: 10,
                                      color: AppColors.voltCyan,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ] else ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    color: AppColors.voltCyan.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Gerando ID...',
                                  style: TextStyle(
                                    color: AppColors.voltCyan.withValues(
                                      alpha: 0.7,
                                    ),
                                    fontSize: 10,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Itens do Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              children: [
                _StyledDrawerItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Meu Perfil',
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.profile);
                  },
                ),
                const SizedBox(height: 8),
                _StyledDrawerItem(
                  icon: Icons.help_outline_rounded,
                  label: 'Ajuda',
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.help);
                  },
                ),
                const SizedBox(height: 8),
                _StyledDrawerItem(
                  icon: Icons.info_outline_rounded,
                  label: 'Sobre o iQoin',
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.about);
                  },
                ),
              ],
            ),
          ),

          // Footer (Versão e Logout)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Divider(color: AppColors.deepFinBlueLight),
                const SizedBox(height: 16),
                _StyledDrawerItem(
                  icon: Icons.logout_rounded,
                  label: 'Sair da conta',
                  isDestructive: true,
                  onTap: () async {
                    final confirmed = await _showLogoutDialog(context);
                    if (confirmed && context.mounted) {
                      await authService.signOut();
                      // Redirecionamento automático via GoRouter listener
                    }
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Versão 1.0.0',
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: AppColors.voltCyan, width: 0.5),
            ),
            title: const Text(
              'Confirmar saída',
              style: TextStyle(color: AppColors.pureWhite),
            ),
            content: const Text(
              'Tem certeza que deseja desconectar sua conta?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.alertRed.withValues(alpha: 0.2),
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

class _StyledDrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _StyledDrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.alertRed : AppColors.pureWhite;
    final iconColor = isDestructive ? AppColors.alertRed : AppColors.voltCyan;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: iconColor.withValues(alpha: 0.2),
        highlightColor: iconColor.withValues(alpha: 0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // Opcional: Adicionar fundo sutil se quiser destacar cards
            // color: AppColors.deepFinBlueLight.withValues(alpha: 0.3),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
