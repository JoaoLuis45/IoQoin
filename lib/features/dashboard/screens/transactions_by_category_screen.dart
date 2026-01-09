import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/category_icons.dart';
import '../../auth/services/auth_service.dart';
import '../../environments/services/environment_service.dart';
import '../../home/models/transaction_model.dart';
import '../../shared/services/firestore_service.dart';

class TransactionsByCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final bool isExpense;

  const TransactionsByCategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.categoryIcon = 'outros',
    required this.isExpense,
  });

  @override
  State<TransactionsByCategoryScreen> createState() =>
      _TransactionsByCategoryScreenState();
}

class _TransactionsByCategoryScreenState
    extends State<TransactionsByCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Filtros
  DateTimeRange? _dateRange;
  double? _minValue;
  double? _maxValue;

  // Filtros temporais rápidos
  int? _selectedMonth;
  int? _selectedYear;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.deepFinBlue,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filtrar Transações',
                    style: TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filtro de Mês
                  const Text(
                    'Mês',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 12,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final month = index + 1;
                        final isSelected = _selectedMonth == month;
                        return FilterChip(
                          label: Text(_getMonthName(month)),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setModalState(() {
                              _selectedMonth = selected ? month : null;
                            });
                          },
                          backgroundColor: AppColors.deepFinBlueLight,
                          selectedColor: AppColors.voltCyan.withValues(
                            alpha: 0.3,
                          ),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.voltCyan
                                : AppColors.pureWhite,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.voltCyan
                                  : Colors.transparent,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Filtro de Ano
                  const Text(
                    'Ano',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final year = DateTime.now().year - index;
                        final isSelected = _selectedYear == year;
                        return FilterChip(
                          label: Text(year.toString()),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setModalState(() {
                              _selectedYear = selected ? year : null;
                            });
                          },
                          backgroundColor: AppColors.deepFinBlueLight,
                          selectedColor: AppColors.voltCyan.withValues(
                            alpha: 0.3,
                          ),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.voltCyan
                                : AppColors.pureWhite,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.voltCyan
                                  : Colors.transparent,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  const SizedBox(height: 24),

                  // Botão Selecionar Data
                  const Text(
                    'Período Customizado',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: AppColors.voltCyan,
                                  onPrimary: AppColors.deepFinBlue,
                                  surface: AppColors.deepFinBlue,
                                  onSurface: AppColors.pureWhite,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setModalState(() {
                            _dateRange = picked;
                            // Se selecionar range, limpa mês/ano rápidos para evitar conflito visual
                            _selectedMonth = null;
                            _selectedYear = null;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.date_range,
                        color: AppColors.voltCyan,
                      ),
                      label: Text(
                        _dateRange == null
                            ? 'Selecionar período'
                            : '${DateFormat('dd/MM/yyyy').format(_dateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(_dateRange!.end)}',
                        style: const TextStyle(color: AppColors.pureWhite),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.voltCyan.withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Filtro de Valor (Min / Max)
                  const Text(
                    'Faixa de Valor',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (val) {
                            _minValue = double.tryParse(
                              val.replaceAll(',', '.'),
                            );
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: const TextStyle(color: AppColors.pureWhite),
                          decoration: InputDecoration(
                            hintText: 'Mínimo',
                            prefixText: 'R\$ ',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.deepFinBlueLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        '-',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          onChanged: (val) {
                            _maxValue = double.tryParse(
                              val.replaceAll(',', '.'),
                            );
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: const TextStyle(color: AppColors.pureWhite),
                          decoration: InputDecoration(
                            hintText: 'Máximo',
                            prefixText: 'R\$ ',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.deepFinBlueLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Botões de Ação
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedMonth = null;
                              _selectedYear = null;
                              _dateRange = null;
                              _minValue = null;
                              _maxValue = null;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Limpar',
                            style: TextStyle(color: AppColors.alertRed),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            setState(() {
                              // Atualiza estado principal com valores do modal
                              // Note: _minValue and _maxValue are already updated via onChanged callbacks
                              // _dateRange is updated via setModalState
                            });
                            Navigator.pop(context);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.voltCyan,
                          ),
                          child: const Text(
                            'Aplicar',
                            style: TextStyle(color: AppColors.deepFinBlue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
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
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = context.watch<FirestoreService>();
    final authService = context.watch<AuthService>();
    final environmentService = context.watch<EnvironmentService>();
    final userId = authService.userModel?.uid;
    final envId = environmentService.currentEnvironment?.id;

    if (userId == null || envId == null) {
      return const Scaffold(
        backgroundColor: AppColors.deepFinBlue,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final themeColor = widget.isExpense
        ? AppColors.alertRed
        : AppColors.successGreen;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.deepFinBlue,
        appBar: AppBar(
          backgroundColor: AppColors.deepFinBlue,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isExpense
                    ? 'Despesas da Categoria'
                    : 'Receitas da Categoria',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                widget.categoryName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pureWhite,
                ),
              ),
            ],
          ),
          iconTheme: const IconThemeData(color: AppColors.pureWhite),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            // Barra de Pesquisa e Filtro
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val.toLowerCase();
                        });
                      },
                      style: const TextStyle(color: AppColors.pureWhite),
                      decoration: InputDecoration(
                        hintText: 'Pesquisar descrição...',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: AppColors.deepFinBlueLight.withValues(
                          alpha: 0.5,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: _openFilterModal,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (_selectedMonth != null || _selectedYear != null)
                            ? AppColors.voltCyan.withValues(alpha: 0.2)
                            : AppColors.deepFinBlueLight.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              (_selectedMonth != null || _selectedYear != null)
                              ? AppColors.voltCyan
                              : Colors.transparent,
                        ),
                      ),
                      child: Icon(
                        Icons.filter_list_rounded,
                        color: (_selectedMonth != null || _selectedYear != null)
                            ? AppColors.voltCyan
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Chips de Filtros Ativos (Opcional - mas bom UX)
            if (_selectedMonth != null || _selectedYear != null)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    if (_selectedMonth != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(_getMonthName(_selectedMonth!)),
                          backgroundColor: AppColors.deepFinBlueLight,
                          labelStyle: const TextStyle(
                            color: AppColors.voltCyan,
                          ),
                          deleteIcon: const Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.voltCyan,
                          ),
                          onDeleted: () =>
                              setState(() => _selectedMonth = null),
                          side: BorderSide(
                            color: AppColors.voltCyan.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    if (_selectedYear != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(_selectedYear.toString()),
                          backgroundColor: AppColors.deepFinBlueLight,
                          labelStyle: const TextStyle(
                            color: AppColors.voltCyan,
                          ),
                          deleteIcon: const Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.voltCyan,
                          ),
                          onDeleted: () => setState(() => _selectedYear = null),
                          side: BorderSide(
                            color: AppColors.voltCyan.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 8),

            // Lista
            Expanded(
              child: StreamBuilder<List<TransactionModel>>(
                stream: firestoreService.getTransactionsByCategory(
                  userId,
                  envId,
                  widget.categoryId,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Erro ao carregar dados',
                        style: TextStyle(color: AppColors.alertRed),
                      ),
                    );
                  }

                  var list = snapshot.data ?? [];

                  // Aplicar Filtros Client-Side
                  if (_searchQuery.isNotEmpty) {
                    list = list
                        .where(
                          (t) => (t.descricao ?? '').toLowerCase().contains(
                            _searchQuery,
                          ),
                        )
                        .toList();
                  }

                  if (_selectedMonth != null) {
                    list = list
                        .where((t) => t.data.month == _selectedMonth)
                        .toList();
                  }

                  if (_selectedYear != null) {
                    list = list
                        .where((t) => t.data.year == _selectedYear)
                        .toList();
                  }

                  if (_dateRange != null) {
                    list = list
                        .where(
                          (t) =>
                              t.data.isAfter(
                                _dateRange!.start.subtract(
                                  const Duration(days: 1),
                                ),
                              ) &&
                              t.data.isBefore(
                                _dateRange!.end.add(const Duration(days: 1)),
                              ),
                        )
                        .toList();
                  }

                  if (_minValue != null) {
                    list = list.where((t) => t.valor >= _minValue!).toList();
                  }

                  if (_maxValue != null) {
                    list = list.where((t) => t.valor <= _maxValue!).toList();
                  }
                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Nenhuma transação encontrada',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(
                      bottom: 30,
                      left: 16,
                      right: 16,
                      top: 8,
                    ),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final transaction = list[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.deepFinBlueLight.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.pureWhite.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: themeColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CategoryIcons.getIcon(
                                  widget.categoryIcon,
                                  isExpense: widget.isExpense,
                                ),
                                color: themeColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transaction.descricao != null &&
                                            transaction.descricao!.isNotEmpty
                                        ? transaction.descricao!
                                        : widget.categoryName,
                                    style: const TextStyle(
                                      color: AppColors.pureWhite,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(transaction.data),
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'R\$ ${transaction.valor.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: themeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
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
}
