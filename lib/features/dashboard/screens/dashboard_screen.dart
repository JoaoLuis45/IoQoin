import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/services/auth_service.dart';
import '../../home/models/transaction_model.dart';
import '../../shared/services/firestore_service.dart';

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

    if (userId == null) return const Center(child: CircularProgressIndicator());

    // Memoização Manual do Stream para evitar recriação e reset de scroll ao dar setState
    if (_transactionsStream == null ||
        userId != _lastUserId ||
        _selectedYear != _lastYear) {
      _transactionsStream = firestoreService.getTransactionsByYear(
        userId,
        _selectedYear,
      );
      _lastUserId = userId;
      _lastYear = _selectedYear;
    }

    // Lista de anos para o dropdown (ano atual e anterior)
    final currentYear = DateTime.now().year;
    final years = [currentYear, currentYear - 1, currentYear - 2];

    return Scaffold(
      backgroundColor: AppColors.deepFinBlue, // Dark Theme
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

          return CustomScrollView(
            slivers: [
              // Header Flutuante
              SliverAppBar(
                backgroundColor: AppColors.deepFinBlue,
                elevation: 0,
                floating: true,
                title: Row(
                  children: [
                    Image.asset('assets/images/logo.png', height: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Dashboards',
                      style: TextStyle(
                        color: AppColors.pureWhite,
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
                      color: AppColors.deepFinBlueLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.voltCyan.withValues(alpha: 0.3),
                      ),
                    ),
                    child: DropdownButton<int>(
                      value: _selectedYear,
                      dropdownColor: AppColors.deepFinBlueLight,
                      underline: const SizedBox(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.voltCyan,
                      ),
                      style: const TextStyle(
                        color: AppColors.pureWhite,
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
                    _buildSectionTitle('Visão Geral Mensal'),
                    const SizedBox(height: 16),
                    _buildMonthlyComparisonChart(transactions),

                    const SizedBox(height: 32),
                    _buildSectionTitle('Despesas por Categoria'),
                    const SizedBox(height: 16),
                    _buildCategoryPieChart(
                      transactions,
                      isExpense: true,
                      touchedIndex: _touchedExpenseIndex,
                      onTouch: (index) =>
                          setState(() => _touchedExpenseIndex = index),
                    ),

                    const SizedBox(height: 32),
                    _buildSectionTitle('Receitas por Categoria'),
                    const SizedBox(height: 16),
                    _buildCategoryPieChart(
                      transactions,
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
        color: AppColors.deepFinBlueLight.withValues(
          alpha: 0.3,
        ), // Fundo do gráfico
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.1)),
      ),
      child: transactions.isEmpty
          ? const Center(
              child: Text(
                'Sem dados',
                style: TextStyle(color: AppColors.textSecondary),
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

  Widget _buildCategoryPieChart(
    List<TransactionModel> transactions, {
    required bool isExpense,
    required int touchedIndex,
    required Function(int) onTouch,
  }) {
    // Filtrar transações pelo tipo
    final filtered = transactions
        .where((t) => isExpense ? t.isExpense : t.isIncome)
        .toList();

    if (filtered.isEmpty) {
      return Container(
        height: 250,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.deepFinBlueLight.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.1)),
        ),
        child: const Text(
          'Sem dados',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    // Agrupar por nome da categoria
    final Map<String, double> totalsByCategory = {};
    double totalValue = 0;

    for (var t in filtered) {
      totalsByCategory[t.categoryName] =
          (totalsByCategory[t.categoryName] ?? 0) + t.valor;
      totalValue += t.valor;
    }

    // Gerar seções
    // Definir uma paleta de cores para variar nas categorias
    final List<Color> colors = [
      isExpense ? AppColors.alertRed : AppColors.successGreen, // Cor principal
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    List<PieChartSectionData> sections = [];
    final entries = totalsByCategory.entries.toList();

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final value = entry.value;
      final categoryName = entry.key;

      final isTouched = i == touchedIndex;
      final percentage = (value / totalValue) * 100;

      // Mostrar labels apenas para fatias > 5% OU se estiver tocado
      final showTitle = percentage > 5 || isTouched;

      // Título mostra % e R$ se tocado
      String title = '';
      if (isTouched) {
        title =
            '${percentage.toStringAsFixed(0)}%\nR\$${value.toStringAsFixed(2)}';
      } else if (showTitle) {
        title = '${percentage.toStringAsFixed(0)}%';
      }

      // Aumentei o raio de destaque para 70.0 para feedback mais claro
      final double radius = isTouched ? 70.0 : 50.0;
      final double fontSize = isTouched ? 14.0 : 12.0;

      sections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: value,
          title: title,
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
          ),
          badgeWidget: showTitle
              ? _Badge(
                  categoryName,
                  size: isTouched ? 40 : 30, // Aumenta badge se tocado
                  borderColor: colors[i % colors.length],
                )
              : null,
          badgePositionPercentageOffset: 1.4, // Afasta um pouco mais
        ),
      );
    }

    return Container(
      height: 350, // Aumentei altura para acomodar interação
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.deepFinBlueLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.1)),
      ),
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: sections,
          pieTouchData: PieTouchData(
            enabled: true,
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              // Se não houver toque em seção válida
              if (pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                // Se o usuário clicar fora (TapUp no fundo), desmarca
                if (event is FlTapUpEvent && touchedIndex != -1) {
                  onTouch(-1);
                }
                return;
              }

              // Se houver clique em seção
              if (event is FlTapUpEvent) {
                final index =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                // Toggle: clicar na mesma desmarca, clicar em outra marca
                if (index == touchedIndex) {
                  onTouch(-1);
                } else {
                  onTouch(index);
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text, {required this.size, required this.borderColor});
  final String text;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size * 3, // Largura para caber texto
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: size * 0.4,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
