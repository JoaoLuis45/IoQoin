import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/services/auth_service.dart';
import '../../shared/services/firestore_service.dart';
import '../widgets/expense_tab.dart';
import '../widgets/income_tab.dart';

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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final authService = context.read<AuthService>();
    final firestoreService = context.read<FirestoreService>();
    final userId = authService.user?.uid ?? '';

    return Column(
      children: [
        // Seletor de mês + Resumo
        _buildMonthSelector(userId, firestoreService),

        const SizedBox(height: 16),

        // Tip se não for mês atual
        if (!_isCurrentMonth) _buildPastMonthTip(),

        // TabBar customizada
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.deepFinBlueLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildTab(
                  index: 0,
                  icon: Icons.trending_down,
                  label: 'Despesas',
                ),
              ),
              Expanded(
                child: _buildTab(
                  index: 1,
                  icon: Icons.trending_up,
                  label: 'Receitas',
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1),

        const SizedBox(height: 16),

        // Conteúdo das abas
        Expanded(
          child: IndexedStack(
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
      ],
    );
  }

  Widget _buildMonthSelector(String userId, FirestoreService firestoreService) {
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
                onTap: _showMonthPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
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
                        size: 18,
                        color: _isCurrentMonth
                            ? AppColors.voltCyan
                            : AppColors.warningYellow,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getMonthName(_selectedMonth, _selectedYear),
                        style: TextStyle(
                          color: _isCurrentMonth
                              ? AppColors.voltCyan
                              : AppColors.warningYellow,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 18,
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

          const SizedBox(height: 16),

          // Resumo
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  label: 'Despesas',
                  streamValue: firestoreService.watchMonthlyExpenseTotal(
                    userId,
                    month: _selectedMonth,
                    year: _selectedYear,
                  ),
                  color: AppColors.alertRed,
                  icon: Icons.arrow_downward,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: AppColors.divider.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildSummaryItem(
                  label: 'Receitas',
                  streamValue: firestoreService.watchMonthlyIncomeTotal(
                    userId,
                    month: _selectedMonth,
                    year: _selectedYear,
                  ),
                  color: AppColors.successGreen,
                  icon: Icons.arrow_upward,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2);
  }

  Widget _buildPastMonthTip() {
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
              'Modo visualização: não é possível adicionar transações em meses passados.',
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

  void _showMonthPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.deepFinBlue,
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
              'Selecionar Mês',
              style: Theme.of(context).textTheme.titleLarge,
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
                            : AppColors.pureWhite,
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
                            child: const Text(
                              'Atual',
                              style: TextStyle(
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
    final months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    return '${months[month - 1]} $year';
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

  Widget _buildSummaryItem({
    required String label,
    required Stream<double> streamValue,
    required Color color,
    required IconData icon,
  }) {
    return StreamBuilder<double>(
      stream: streamValue,
      builder: (context, snapshot) {
        final value = snapshot.data ?? 0;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'R\$ ${value.toStringAsFixed(2)}',
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}
