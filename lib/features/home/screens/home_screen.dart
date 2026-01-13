import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:ioqoin/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/services/auth_service.dart';
import '../../shared/services/firestore_service.dart';
import '../../shared/services/sync_service.dart';
import '../../environments/services/environment_service.dart';
import '../widgets/expense_tab.dart';
import '../widgets/income_tab.dart';
import '../../../../core/utils/icon_utils.dart';
import '../../environments/screens/environment_selection_screen.dart';

/// Tela Home com abas de Receitas e Despesas e seletor de mês
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  int _currentTabIndex = 0;

  // Mês e ano selecionados (inicia no mês atual)
  late int _selectedMonth;
  late int _selectedYear;

  // Lista de meses disponíveis (12 meses anteriores + atual)
  late List<DateTime> _availableMonths;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;
    _buildAvailableMonths();
  }

  void _buildAvailableMonths() {
    final now = DateTime.now();
    _availableMonths = [];

    // Adiciona 12 meses anteriores + mês atual (13 no total)
    for (int i = 12; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      _availableMonths.add(date);
    }
  }

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _selectedMonth == now.month && _selectedYear == now.year;
  }

  @override
  bool get wantKeepAlive => true;

  // Chave para identificar a posição da TabBar (limite do header)
  final GlobalKey _tabBarKey = GlobalKey();
  bool _shouldAllowRefresh = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final l10n = AppLocalizations.of(context)!;
    final authService = context.read<AuthService>();
    final firestoreService = context.read<FirestoreService>();
    final userId = authService.user?.uid ?? '';

    return DefaultTabController(
      length: 2,
      child: Listener(
        onPointerDown: (event) {
          // Verifica se o toque começou acima ou na TabBar
          final renderBox =
              _tabBarKey.currentContext?.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final position = renderBox.localToGlobal(Offset.zero);
            // Considera o final da TabBar como o limite
            final limitY = position.dy + renderBox.size.height;

            // Permite refresh apenas se o toque for acima do limite
            // (no Header, Mês ou TabBar)
            _shouldAllowRefresh = event.position.dy <= limitY;
          } else {
            // Fallback caso não encontre a renderBox
            _shouldAllowRefresh = true;
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<SyncService>().reload();
            await Future.delayed(const Duration(milliseconds: 500));
          },
          notificationPredicate: (notification) {
            // Aceita se permitido pelo hit-test E se for uma notificação de profundidade rasa (0 ou 1)
            // NestedScrollView as vezes emite depth 1 para o outer scroll view dependendo da estrutura
            return _shouldAllowRefresh && notification.depth <= 1;
          },
          backgroundColor: Theme.of(context).cardColor,
          color: AppColors.voltCyan,
          child: NestedScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // Header (Ambiente)
                SliverToBoxAdapter(
                  child: _buildHeader(
                    context,
                    context.watch<EnvironmentService>(),
                    l10n,
                  ),
                ),

                // Seletor de mês + Resumo
                SliverToBoxAdapter(
                  child: _buildMonthSelector(userId, firestoreService, l10n),
                ),

                // Tip se não for mês atual
                if (!_isCurrentMonth)
                  SliverToBoxAdapter(child: _buildPastMonthTip(l10n))
                else
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // TabBar customizada (Pinned)
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    context,
                  ),
                  sliver: SliverPersistentHeader(
                    pinned: true,
                    delegate: _HomeTabBarDelegate(
                      key: _tabBarKey,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).shadowColor.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTab(
                                index: 0,
                                icon: Icons.trending_down,
                                label: l10n.expenses,
                              ),
                            ),
                            Expanded(
                              child: _buildTab(
                                index: 1,
                                icon: Icons.trending_up,
                                label: l10n.income,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: IndexedStack(
              index: _currentTabIndex,
              children: [
                ExpenseTab(
                  userId: userId,
                  month: _selectedMonth,
                  year: _selectedYear,
                  canAdd: _isCurrentMonth,
                ),
                IncomeTab(
                  userId: userId,
                  month: _selectedMonth,
                  year: _selectedYear,
                  canAdd: _isCurrentMonth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    EnvironmentService envService,
    AppLocalizations l10n,
  ) {
    if (envService.isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.voltCyan,
            ),
          ),
        ),
      );
    }

    final currentEnv = envService.currentEnvironment;
    final color = currentEnv != null
        ? Color(int.parse(currentEnv.colorHex))
        : AppColors.textSecondary;
    final name = currentEnv?.name ?? l10n.selectEnvironment;
    final icon = currentEnv != null
        ? IconUtils.getEnvironmentIcon(currentEnv.iconCodePoint)
        : Icons.add_circle_outline;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EnvironmentSelectionScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                // Environment Icon Badge
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),

                // Environment Text Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.currentEnvironment,
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        name,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.titleLarge?.color,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Action Indicator
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.1),
                    ),
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: AppColors.voltCyan,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2);
  }

  Widget _buildMonthSelector(
    String userId,
    FirestoreService firestoreService,
    AppLocalizations l10n,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isCurrentMonth
              ? AppColors.voltCyan.withValues(alpha: 0.2)
              : AppColors.warningYellow.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Navegação de mês
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botão anterior
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: _canGoBack ? _goToPreviousMonth : null,
                icon: Icon(
                  Icons.chevron_left,
                  color: _canGoBack
                      ? AppColors.voltCyan
                      : AppColors.textSecondary.withValues(alpha: 0.3),
                ),
              ),

              // Mês e ano
              GestureDetector(
                onTap: () => _showMonthPicker(l10n),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _isCurrentMonth
                        ? AppColors.voltCyan.withValues(alpha: 0.15)
                        : AppColors.warningYellow.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 16,
                        color: _isCurrentMonth
                            ? AppColors.voltCyan
                            : AppColors.warningYellow,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getMonthName(_selectedMonth, _selectedYear),
                        style: TextStyle(
                          color: _isCurrentMonth
                              ? AppColors.voltCyan
                              : AppColors.warningYellow,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 16,
                        color: _isCurrentMonth
                            ? AppColors.voltCyan
                            : AppColors.warningYellow,
                      ),
                    ],
                  ),
                ),
              ),

              // Botão próximo
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: _canGoForward ? _goToNextMonth : null,
                icon: Icon(
                  Icons.chevron_right,
                  color: _canGoForward
                      ? AppColors.voltCyan
                      : AppColors.textSecondary.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          // Resumo Financeiro (Saldo, Receitas, Despesas)
          StreamBuilder<Map<String, double>>(
            stream: firestoreService.watchMonthlyFinancials(
              userId,
              context.watch<EnvironmentService>().currentEnvironment?.id ?? '',
              month: _selectedMonth,
              year: _selectedYear,
            ),
            builder: (context, snapshot) {
              final data =
                  snapshot.data ??
                  {'income': 0.0, 'expense': 0.0, 'balance': 0.0};
              final income = data['income'] ?? 0.0;
              final expense = data['expense'] ?? 0.0;
              final balance = data['balance'] ?? 0.0;

              return Column(
                children: [
                  // Saldo (Compacto)
                  _buildSummaryValue(
                    label: l10n.balance,
                    value: balance,
                    color: AppColors.voltCyan,
                    icon: Icons.account_balance_wallet,
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: double.infinity,
                    height: 1,
                    color: AppColors.divider.withValues(alpha: 0.2),
                  ),

                  // Receitas vs Despesas
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryValue(
                          label: l10n.expenses,
                          value: expense,
                          color: AppColors.alertRed,
                          icon: Icons.arrow_downward,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: AppColors.divider.withValues(alpha: 0.2),
                      ),
                      Expanded(
                        child: _buildSummaryValue(
                          label: l10n.income,
                          value: income,
                          color: AppColors.successGreen,
                          icon: Icons.arrow_upward,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2);
  }

  Widget _buildPastMonthTip(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.warningYellow.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warningYellow.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.warningYellow, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.viewModeTip,
              style: TextStyle(color: AppColors.warningYellow, fontSize: 12),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  bool get _canGoBack {
    final firstAvailable = _availableMonths.first;
    return !(_selectedMonth == firstAvailable.month &&
        _selectedYear == firstAvailable.year);
  }

  bool get _canGoForward {
    final now = DateTime.now();
    return !(_selectedMonth == now.month && _selectedYear == now.year);
  }

  void _goToPreviousMonth() {
    setState(() {
      if (_selectedMonth == 1) {
        _selectedMonth = 12;
        _selectedYear--;
      } else {
        _selectedMonth--;
      }
    });
  }

  void _goToNextMonth() {
    setState(() {
      if (_selectedMonth == 12) {
        _selectedMonth = 1;
        _selectedYear++;
      } else {
        _selectedMonth++;
      }
    });
  }

  void _showMonthPicker(AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.selectMonth,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: _availableMonths.length,
                itemBuilder: (context, index) {
                  // Inverter a ordem para mostrar mais recente primeiro
                  final date =
                      _availableMonths[_availableMonths.length - 1 - index];
                  final isSelected =
                      date.month == _selectedMonth &&
                      date.year == _selectedYear;
                  final now = DateTime.now();
                  final isCurrent =
                      date.month == now.month && date.year == now.year;

                  return ListTile(
                    leading: Icon(
                      isCurrent ? Icons.calendar_today : Icons.calendar_month,
                      color: isSelected
                          ? AppColors.voltCyan
                          : AppColors.textSecondary,
                    ),
                    title: Text(
                      _getMonthName(date.month, date.year),
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.voltCyan
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isCurrent
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.voltCyan.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              l10n.currentTag,
                              style: const TextStyle(
                                color: AppColors.voltCyan,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : null,
                    selected: isSelected,
                    selectedTileColor: AppColors.voltCyan.withValues(
                      alpha: 0.1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedMonth = date.month;
                        _selectedYear = date.year;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month, int year) {
    final date = DateTime(year, month);
    final locale = Localizations.localeOf(context).toString();
    return '${DateFormat.MMMM(locale).format(date)} $year';
  }

  Widget _buildTab({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentTabIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentTabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.voltCyan, AppColors.voltCyanDark],
                )
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? AppColors.deepFinBlue
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isSelected
                    ? AppColors.deepFinBlue
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryValue({
    required String label,
    required double value,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color.withValues(alpha: 0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'R\$ ${value.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _HomeTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Key? key;

  _HomeTabBarDelegate({required this.child, this.key});

  @override
  double get minExtent => 80.0; // Altura aproximada da tab bar + margens

  @override
  double get maxExtent => 80.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      key: key,
      color: Theme.of(context).scaffoldBackgroundColor,
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_HomeTabBarDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
