import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/services/auth_service.dart';
import '../../home/models/transaction_model.dart';
import '../../shared/services/firestore_service.dart';
import '../../shared/services/sync_service.dart';
import '../../environments/services/environment_service.dart';
import 'transactions_by_category_screen.dart';
import 'package:ioqoin/l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedYear = DateTime.now().year;
  int _touchedExpenseIndex = -1;
  int _touchedIncomeIndex = -1;

  // Variáveis para memoização do Stream
  Stream<List<TransactionModel>>? _transactionsStream;
  String? _lastUserId;
  String? _lastEnvId;
  int? _lastYear;

  // Mapa de meses para labels
  final List<String> _months = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final firestoreService = context.watch<FirestoreService>();
    final userId = authService.userModel?.uid;
    final envId =
        context.watch<EnvironmentService>().currentEnvironment?.id ?? '';

    if (userId == null) return const Center(child: CircularProgressIndicator());

    // Memoização Manual do Stream para evitar recriação e reset de scroll ao dar setState
    if (_transactionsStream == null ||
        userId != _lastUserId ||
        envId != _lastEnvId ||
        _selectedYear != _lastYear) {
      _transactionsStream = firestoreService.getTransactionsByYear(
        userId,
        envId,
        _selectedYear,
      );
      _lastUserId = userId;
      _lastEnvId = envId;
      _lastYear = _selectedYear;
    }

    // Lista de anos para o dropdown (ano atual e anterior)
    final currentYear = DateTime.now().year;
    final years = [currentYear, currentYear - 1, currentYear - 2];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: StreamBuilder<List<TransactionModel>>(
        stream: _transactionsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar dados',
                style: const TextStyle(color: AppColors.alertRed),
              ),
            );
          }

          final transactions = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<SyncService>().reload();
              await Future.delayed(const Duration(milliseconds: 500));
            },
            backgroundColor: Theme.of(context).cardColor,
            color: AppColors.voltCyan,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Header Flutuante
                SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  floating: true,
                  title: Row(
                    children: [
                      Image.asset('assets/images/logo.png', height: 24),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.dashboardTitle,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.titleLarge?.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? AppColors.voltCyan.withValues(alpha: 0.3)
                              : AppColors.deepFinBlue.withValues(alpha: 0.1),
                        ),
                      ),
                      child: DropdownButton<int>(
                        value: _selectedYear,
                        dropdownColor: Theme.of(context).cardColor,
                        underline: const SizedBox(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.voltCyan,
                        ),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.bold,
                        ),
                        items: years.map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text('$year'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedYear = val);
                        },
                      ),
                    ),
                  ],
                ),

                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildSectionTitle(
                        AppLocalizations.of(context)!.dashboardMonthlyOverview,
                      ),
                      const SizedBox(height: 16),
                      _buildMonthlyComparisonChart(transactions),

                      const SizedBox(height: 32),
                      _buildSectionTitle(
                        AppLocalizations.of(
                          context,
                        )!.dashboardExpenseByCategory,
                      ),
                      const SizedBox(height: 16),
                      DashboardCategoryChart(
                        transactions: transactions,
                        isExpense: true,
                        touchedIndex: _touchedExpenseIndex,
                        onTouch: (index) =>
                            setState(() => _touchedExpenseIndex = index),
                      ),

                      const SizedBox(height: 32),
                      _buildSectionTitle(
                        AppLocalizations.of(context)!.dashboardIncomeByCategory,
                      ),
                      const SizedBox(height: 16),
                      DashboardCategoryChart(
                        transactions: transactions,
                        isExpense: false,
                        touchedIndex: _touchedIncomeIndex,
                        onTouch: (index) =>
                            setState(() => _touchedIncomeIndex = index),
                      ),

                      const SizedBox(height: 100),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.voltCyan,
      ),
    );
  }

  Widget _buildMonthlyComparisonChart(List<TransactionModel> transactions) {
    // Processamento dos dados
    // Maps: monthIndex (0..11) -> total
    final Map<int, double> incomeByMonth = {};
    final Map<int, double> expenseByMonth = {};

    // Inicializa com 0
    for (int i = 0; i < 12; i++) {
      incomeByMonth[i] = 0;
      expenseByMonth[i] = 0;
    }

    // Soma
    for (var t in transactions) {
      // t.data.month é 1..12, convertendo para index 0..11
      final monthIndex = t.data.month - 1;
      if (t.isIncome) {
        incomeByMonth[monthIndex] = (incomeByMonth[monthIndex] ?? 0) + t.valor;
      } else {
        expenseByMonth[monthIndex] =
            (expenseByMonth[monthIndex] ?? 0) + t.valor;
      }
    }

    // Calcula maxY para escala
    double maxY = 0;
    for (int i = 0; i < 12; i++) {
      if (incomeByMonth[i]! > maxY) maxY = incomeByMonth[i]!;
      if (expenseByMonth[i]! > maxY) maxY = expenseByMonth[i]!;
    }
    if (maxY == 0) maxY = 100; // Fallback para não quebrar gráfico vazio
    maxY = maxY * 1.2; // 20% de margem no topo

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).cardColor.withValues(alpha: 0.5), // Fundo do gráfico
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.1)),
      ),
      child: transactions.isEmpty
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.dashboardNoData,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            )
          : BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.deepFinBlueLight,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.toStringAsFixed(2),
                        const TextStyle(color: AppColors.pureWhite),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= 12 || index % 2 != 0) {
                          return const SizedBox();
                        }

                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            _months[index],
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 5,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.textSecondary.withValues(alpha: 0.1),
                    strokeWidth: 1,
                  ),
                ),
                barGroups: List.generate(12, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: incomeByMonth[index] ?? 0,
                        color: AppColors.successGreen,
                        width: 6,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      BarChartRodData(
                        toY: expenseByMonth[index] ?? 0,
                        color: AppColors.alertRed,
                        width: 6,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  );
                }),
              ),
            ),
    );
  }
}

class DashboardCategoryChart extends StatefulWidget {
  final List<TransactionModel> transactions;
  final bool isExpense;
  final int touchedIndex;
  final Function(int) onTouch;

  const DashboardCategoryChart({
    super.key,
    required this.transactions,
    required this.isExpense,
    required this.touchedIndex,
    required this.onTouch,
  });

  @override
  State<DashboardCategoryChart> createState() => _DashboardCategoryChartState();
}

class _DashboardCategoryChartState extends State<DashboardCategoryChart> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filtrar transações pelo tipo
    final filtered = widget.transactions
        .where((t) => widget.isExpense ? t.isExpense : t.isIncome)
        .toList();

    if (filtered.isEmpty) {
      return Container(
        height: 250,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline_rounded,
              size: 48,
              color: AppColors.textSecondary.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.dashboardNoData,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // Agrupar por nome da categoria
    final Map<String, double> totalsByCategory = {};
    final Map<String, String> categoryIds = {};
    double totalValue = 0;

    for (var t in filtered) {
      totalsByCategory[t.categoryName] =
          (totalsByCategory[t.categoryName] ?? 0) + t.valor;
      categoryIds[t.categoryName] = t.categoryId;
      totalValue += t.valor;
    }

    // Ordenar por valor decrescente
    final entries = totalsByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Definir uma paleta de cores PREMIUM e EXTENSA
    final List<Color> colors = [
      widget.isExpense
          ? const Color(0xFFFF453A)
          : const Color(0xFF30D158), // iOS Red / Green
      const Color(0xFF0A84FF), // iOS Blue
      const Color(0xFFFF9F0A), // iOS Orange
      const Color(0xFFBF5AF2), // iOS Purple
      const Color(0xFFFFD60A), // iOS Yellow
      const Color(0xFF64D2FF), // iOS Teal/Cyan
      const Color(0xFFFF375F), // iOS Pink
      const Color(0xFF5E5CE6), // iOS Indigo
      const Color(0xFFAC8E68), // Brown
      const Color(0xFF2D2D2D), // Dark Gray
      const Color(0xFFE5E5EA), // Light Gray
    ];

    List<PieChartSectionData> sections = [];

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final value = entry.value;

      final isTouched = i == widget.touchedIndex;
      final percentage = (value / totalValue) * 100;
      final showTitle = percentage > 4 || isTouched;

      final double radius = isTouched ? 65.0 : 55.0;
      final double fontSize = isTouched ? 16.0 : 12.0;
      final color = colors[i % colors.length];

      sections.add(
        PieChartSectionData(
          color: color,
          value: value,
          title: showTitle ? '${percentage.toStringAsFixed(0)}%' : '',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            shadows: [
              Shadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 4),
            ],
          ),
          badgeWidget: null,
          borderSide: isTouched
              ? const BorderSide(color: Colors.white, width: 2)
              : BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).cardColor.withValues(alpha: 0.5), // Fundo sutil
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.05)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          // Gráfico
          SizedBox(
            height: 260,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 45,
                    sections: sections,
                    pieTouchData: PieTouchData(
                      enabled: true,
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        if (pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          if (event is FlTapUpEvent &&
                              widget.touchedIndex != -1) {
                            widget.onTouch(-1);
                          }
                          return;
                        }

                        if (event is FlTapUpEvent) {
                          final index = pieTouchResponse
                              .touchedSection!
                              .touchedSectionIndex;
                          if (index == widget.touchedIndex) {
                            widget.onTouch(-1);
                          } else {
                            widget.onTouch(index);
                          }
                        }
                      },
                    ),
                  ),
                ),
                // Texto central contextual
                if (widget.touchedIndex != -1 &&
                    widget.touchedIndex < entries.length)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          entries[widget.touchedIndex].key,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${((entries[widget.touchedIndex].value / totalValue) * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: colors[widget.touchedIndex % colors.length],
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Legenda Scrollável (Max Height para não explodir a tela)
          Container(
            constraints: const BoxConstraints(maxHeight: 220),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              radius: const Radius.circular(8),
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                shrinkWrap: true,
                itemCount: entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  final categoryName = entry.key;
                  final categoryId = categoryIds[categoryName] ?? '';
                  final value = entry.value;
                  final percentage = (value / totalValue) * 100;
                  final isTouched = index == widget.touchedIndex;
                  final color = colors[index % colors.length];

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => widget.onTouch(isTouched ? -1 : index),
                      onLongPress: () {
                        if (categoryId.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionsByCategoryScreen(
                                categoryId: categoryId,
                                categoryName: categoryName,
                                isExpense: widget.isExpense,
                                // categoryIcon not provided, will use default 'outros'
                              ),
                            ),
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isTouched
                              ? color.withValues(alpha: 0.15)
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isTouched
                                ? color.withValues(alpha: 0.5)
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Percentual em destaque
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${percentage.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Nome da Categoria
                            Expanded(
                              child: Text(
                                categoryName,
                                style: TextStyle(
                                  color: isTouched
                                      ? Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.color
                                      : Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withValues(alpha: 0.9),
                                  fontWeight: isTouched
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Valor Monetário
                            Text(
                              'R\$ ${value.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color
                                    ?.withValues(alpha: 0.8),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.of(context)!.dashboardTouchDetails,
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
