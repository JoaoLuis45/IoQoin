import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../shared/services/firestore_service.dart';
import '../../environments/services/environment_service.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import 'package:ioqoin/l10n/app_localizations.dart';

class FilterTransactionSheet extends StatefulWidget {
  final TransactionType transactionType;
  final DateTime initialDate; // Start of month usually
  final DateTime finalDate; // End of month usually
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final double? filterMinValue;
  final double? filterMaxValue;
  final List<String> selectedCategoryIds;
  final Function(DateTime?, DateTime?, double?, double?, List<String>) onApply;

  const FilterTransactionSheet({
    super.key,
    required this.transactionType,
    required this.initialDate,
    required this.finalDate,
    this.filterStartDate,
    this.filterEndDate,
    this.filterMinValue,
    this.filterMaxValue,
    required this.selectedCategoryIds,
    required this.onApply,
  });

  @override
  State<FilterTransactionSheet> createState() => _FilterTransactionSheetState();
}

class _FilterTransactionSheetState extends State<FilterTransactionSheet> {
  late DateTime? _startDate;
  late DateTime? _endDate;
  late TextEditingController _minController;
  late TextEditingController _maxController;
  late List<String> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _startDate = widget.filterStartDate;
    _endDate = widget.filterEndDate;
    _minController = TextEditingController(
      text: widget.filterMinValue?.toStringAsFixed(2) ?? '',
    );
    _maxController = TextEditingController(
      text: widget.filterMaxValue?.toStringAsFixed(2) ?? '',
    );
    _selectedCategories = List.from(widget.selectedCategoryIds);
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _minController.clear();
      _maxController.clear();
      _selectedCategories.clear();
    });
  }

  void _applyFilters() {
    final minVal = double.tryParse(_minController.text.replaceAll(',', '.'));
    final maxVal = double.tryParse(_maxController.text.replaceAll(',', '.'));

    widget.onApply(_startDate, _endDate, minVal, maxVal, _selectedCategories);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isExpense = widget.transactionType == TransactionType.expense;
    final primaryColor = isExpense
        ? AppColors.alertRed
        : AppColors.successGreen;
    final envService = context.read<EnvironmentService>();
    final userId =
        context.read<EnvironmentService>().currentEnvironment?.userId ?? '';
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(20),
        // Altura dinamica mas com limite para não quebrar em telas pequenas
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle visual
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Título e Limpar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isExpense ? l10n.filterExpensesTitle : l10n.filterIncomeTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    l10n.cleanFilters,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filtro de Período
                    Text(
                      '${l10n.periodLabel} (${DateFormat('MMMM yyyy', l10n.localeName).format(widget.initialDate)})',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDatePicker(
                            context,
                            label: l10n.dateFrom,
                            selectedDate: _startDate,
                            firstDate: widget.initialDate,
                            lastDate: widget.finalDate,
                            onSelect: (date) =>
                                setState(() => _startDate = date),
                            primaryColor: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDatePicker(
                            context,
                            label: l10n.dateTo,
                            selectedDate: _endDate,
                            firstDate: widget.initialDate,
                            lastDate: widget.finalDate,
                            onSelect: (date) => setState(() => _endDate = date),
                            primaryColor: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Filtro de Valor
                    Text(
                      l10n.valueLabel,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildValueField(
                            controller: _minController,
                            label: l10n.minLabel,
                            primaryColor: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildValueField(
                            controller: _maxController,
                            label: l10n.maxLabel,
                            primaryColor: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Filtro de Categorias
                    Text(
                      l10n.categoriesLabel,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    StreamBuilder<List<CategoryModel>>(
                      stream: context
                          .read<FirestoreService>()
                          .getCategoriesStream(
                            userId,
                            envService.currentEnvironment?.id ?? '',
                            isExpense
                                ? CategoryType.expense
                                : CategoryType.income,
                          ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        }

                        final categories = snapshot.data!;
                        if (categories.isEmpty) {
                          return Text(
                            l10n.noCategoriesFound,
                            style: TextStyle(color: AppColors.textSecondary),
                          );
                        }

                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: categories.map((category) {
                            final isSelected = _selectedCategories.contains(
                              category.id,
                            );
                            return FilterChip(
                              label: Text(category.nome),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    if (category.id != null) {
                                      _selectedCategories.add(category.id!);
                                    }
                                  } else {
                                    _selectedCategories.remove(category.id);
                                  }
                                });
                              },
                              backgroundColor: Theme.of(context).cardColor,
                              selectedColor: primaryColor.withValues(
                                alpha: 0.2,
                              ),
                              checkmarkColor: primaryColor,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? primaryColor
                                    : Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.color,
                                fontSize: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected
                                      ? primaryColor
                                      : AppColors.textSecondary.withValues(
                                          alpha: 0.3,
                                        ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Botão Aplicar
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shadowColor: primaryColor.withValues(alpha: 0.4),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  l10n.applyFiltersButton,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context, {
    required String label,
    required DateTime? selectedDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required Function(DateTime?) onSelect,
    required Color primaryColor,
  }) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? firstDate,
          firstDate: firstDate,
          lastDate: lastDate,
          builder: (context, child) {
            return child!;
          },
        );
        if (picked != null) {
          onSelect(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedDate != null
                ? primaryColor
                : AppColors.textSecondary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: selectedDate != null
                  ? primaryColor
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              selectedDate != null
                  ? DateFormat('dd/MM').format(selectedDate)
                  : label,
              style: TextStyle(
                color: selectedDate != null
                    ? Theme.of(context).textTheme.bodyMedium?.color
                    : AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueField({
    required TextEditingController controller,
    required String label,
    required Color primaryColor,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixText: 'R\$ ',
        prefixStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
