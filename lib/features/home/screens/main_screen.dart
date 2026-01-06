import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../goals/screens/goals_screen.dart';
import '../../subscriptions/screens/subscriptions_screen.dart';
import '../../categories/screens/categories_screen.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../shared/widgets/drawer_menu.dart';
import '../screens/home_screen.dart';
import '../../notifications/widgets/notification_drawer.dart';
import '../../notifications/services/notification_service.dart';
import '../../auth/services/auth_service.dart';
import 'package:provider/provider.dart';

/// Tela principal com Bottom Navigation Bar animada (5 abas)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2; // Home (índice 2: [Dash, Metas, Home, Cat, Inscr])
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    // Verificar notificações diárias ao iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthService>().user?.uid;
      if (userId != null) {
        context.read<NotificationService>().checkDailyNotifications(userId);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logo.png', height: 28),
              const SizedBox(width: 8),
              const Text('IoQoin'),
            ],
          ),
          actions: [
            // Badge com contagem de não lidas
            StreamBuilder<int>(
              stream: context.read<NotificationService>().getUnreadCount(
                context.read<AuthService>().user?.uid ?? '',
              ),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                    if (count > 0)
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
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
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
        drawer: const DrawerMenu(),
        endDrawer: const NotificationDrawer(), // Menu de Notificações
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            DashboardScreen(), // 0
            GoalsScreen(), // 1
            HomeScreen(), // 2 (Home)
            CategoriesScreen(), // 3
            SubscriptionsScreen(), // 4
          ],
        ),
        bottomNavigationBar: _buildAnimatedBottomNav(),
      ),
    );
  }

  Widget _buildAnimatedBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.deepFinBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                icon: Icons.bar_chart_rounded,
                activeIcon: Icons.bar_chart,
                index: 0,
                label: 'Dash',
              ),
              _buildNavItem(
                icon: Icons.flag_outlined,
                activeIcon: Icons.flag,
                index: 1,
                label: 'Metas',
              ),
              _buildCenterNavItem(), // Home (2)
              _buildNavItem(
                icon: Icons.category_outlined,
                activeIcon: Icons.category,
                index: 3,
                label: 'Categ.',
              ),
              _buildNavItem(
                icon: Icons.subscriptions_outlined,
                activeIcon: Icons.subscriptions,
                index: 4,
                label: 'Inscr.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required int index,
    required String label,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.voltCyan.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isSelected ? activeIcon : icon,
            key: ValueKey(isSelected),
            color: isSelected ? AppColors.voltCyan : AppColors.textSecondary,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildCenterNavItem() {
    final isSelected = _currentIndex == 2; // Home index is 2

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Container(
        width: isSelected ? 70 : 64,
        height: isSelected ? 70 : 64,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [AppColors.voltCyan, AppColors.voltCyanDark]
                : [AppColors.deepFinBlueLight, AppColors.deepFinBlueLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.voltCyan.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Icon(
          isSelected ? Icons.home : Icons.home_outlined,
          color: isSelected ? AppColors.deepFinBlue : AppColors.textSecondary,
          size: 28,
        ),
      ),
    );
  }
}
