import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/category_icons.dart';
import '../../shared/services/firestore_service.dart';
import '../../environments/services/environment_service.dart';
import '../models/category_model.dart';
import '../models/fixed_transaction_model.dart';
import '../models/transaction_model.dart';

/// Sheet para adicionar receita ou despesa
class AddTransactionSheet extends StatefulWidget {
  final String userId;
  final TransactionType transactionType;

  const AddTransactionSheet({
    super.key,
    required this.userId,
    required this.transactionType,
  });

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet>
    with SingleTickerProviderStateMixin {
  final _valueController = TextEditingController();
  final _descriptionController = TextEditingController();
  CategoryModel? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  // Tags de valores rápidos
  static const List<double> _quickValues = [20, 50, 100, 200, 500, 1000];

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool get isExpense => widget.transactionType == TransactionType.expense;
  Color get accentColor =>
      isExpense ? AppColors.alertRed : AppColors.successGreen;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    _descriptionController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = context.watch<FirestoreService>();
    final envId =
        context.watch<EnvironmentService>().currentEnvironment?.id ?? '';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: AppColors.deepFinBlue,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Adicionar ${isExpense ? 'Despesa' : 'Receita'}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transações Fixas (Templates)
                    _buildFixedTransactionsSelector(firestoreService, envId),

                    const SizedBox(height: 24),

                    // Campo de valor
                    _buildValueInput(),

                    const SizedBox(height: 20),

                    // Tags de valores rápidos
                    _buildQuickValueTags(),

                    const SizedBox(height: 24),

                    // Seletor de categoria
                    _buildCategorySelector(firestoreService, envId),

                    const SizedBox(height: 24),

                    // Campo de descrição
                    _buildDescriptionField(),

                    const SizedBox(height: 24),

                    // Seletor de data
                    _buildDateSelector(),

                    const SizedBox(height: 40),

                    // Botão de adicionar
                    _buildSubmitButton(firestoreService, envId),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFixedTransactionsSelector(
    FirestoreService firestoreService,
    String envId,
  ) {
    return StreamBuilder<List<FixedTransactionModel>>(
      stream: firestoreService.getFixedTransactions(
        widget.userId,
        envId,
        widget.transactionType,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty)
          return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transações Fixas (Preenchimento Rápido)',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      // Preencher o formulário
                      _valueController.text = item.valor.toStringAsFixed(2);
                      if (item.descricao != null) {
                        _descriptionController.text = item.descricao!;
                      }

                      // Ajustar Tipo de Transação para Tipo de Categoria
                      final categoryType = item.tipo == TransactionType.income
                          ? CategoryType.income
                          : CategoryType.expense;

                      setState(() {
                        _selectedCategory = CategoryModel(
                          id: item.categoryId,
                          userId: item.userId,
                          nome: item.categoryName,
                          icone: item.categoryIcon,
                          tipo: categoryType,
                        );
                      });

                      // Feedback visual
                      HapticFeedback.lightImpact();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.deepFinBlueLight,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.3),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Icon(
                            CategoryIcons.getIcon(
                              item.categoryIcon,
                              isExpense: isExpense,
                            ),
                            size: 16,
                            color: accentColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.categoryName,
                            style: const TextStyle(
                              color: AppColors.pureWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    ).animate().fadeIn();
  }

  Widget _buildValueInput() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.deepFinBlueLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        children: [
          Text(
            'Valor',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'R\$',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _valueController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                  decoration: InputDecoration(
                    hintText: '0,00',
                    hintStyle: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: accentColor.withValues(alpha: 0.3),
                    ),
                    border: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1);
  }

  Widget _buildQuickValueTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Valores rápidos',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _quickValues.map((value) {
            return GestureDetector(
              onTap: () {
                _valueController.text = value.toStringAsFixed(0);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.deepFinBlueLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'R\$ ${value.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ).animate(delay: 100.ms).fadeIn();
  }

  Widget _buildCategorySelector(
    FirestoreService firestoreService,
    String envId,
  ) {
    final stream = isExpense
        ? firestoreService.getExpenseCategories(widget.userId, envId)
        : firestoreService.getIncomeCategories(widget.userId, envId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categoria',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: AppColors.textSecondary),
            ),
            if (_selectedCategory == null)
              Text(
                'Selecione uma categoria',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.alertRed.withValues(alpha: 0.8),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        StreamBuilder<List<CategoryModel>>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.voltCyan),
              );
            }

            final categories = snapshot.data ?? [];

            if (categories.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.alertRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.alertRed.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.warning_amber_outlined,
                      color: AppColors.alertRed,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nenhuma categoria disponível',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.alertRed,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Crie categorias primeiro em "Categorias"',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = _selectedCategory?.id == category.id;
                  final icon = CategoryIcons.getIcon(
                    category.icone,
                    isExpense: isExpense,
                  );

                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedCategory = category);
                    },
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? accentColor.withValues(alpha: 0.2)
                            : AppColors.deepFinBlueLight,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? Border.all(color: accentColor, width: 2)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            color: isSelected
                                ? accentColor
                                : AppColors.textSecondary,
                            size: 28,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category.nome,
                            style: TextStyle(
                              fontSize: 11,
                              color: isSelected
                                  ? accentColor
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    ).animate(delay: 200.ms).fadeIn();
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descrição (opcional)',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            hintText: 'Ex: Compra no supermercado',
            prefixIcon: Icon(Icons.notes_outlined),
          ),
          maxLines: 2,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    ).animate(delay: 300.ms).fadeIn();
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.deepFinBlueLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, color: accentColor),
                const SizedBox(width: 12),
                Text(
                  _formatDate(_selectedDate),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    ).animate(delay: 400.ms).fadeIn();
  }

  Widget _buildSubmitButton(FirestoreService firestoreService, String envId) {
    return Center(
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _selectedCategory != null ? _pulseAnimation.value : 1.0,
            child: GestureDetector(
              onTap: _isSubmitting
                  ? null
                  : () => _submit(firestoreService, envId),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _selectedCategory != null
                        ? [accentColor, accentColor.withValues(alpha: 0.8)]
                        : [
                            AppColors.textSecondary,
                            AppColors.textSecondary.withValues(alpha: 0.8),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: _selectedCategory != null
                      ? [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : null,
                ),
                child: _isSubmitting
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.pureWhite,
                          strokeWidth: 3,
                        ),
                      )
                    : const Icon(
                        Icons.check,
                        color: AppColors.pureWhite,
                        size: 40,
                      ),
              ),
            ),
          );
        },
      ),
    ).animate(delay: 500.ms).fadeIn().scale(begin: const Offset(0.8, 0.8));
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: accentColor,
              onPrimary: AppColors.deepFinBlue,
              surface: AppColors.deepFinBlueLight,
              onSurface: AppColors.pureWhite,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (selectedDay == today) {
      return 'Hoje';
    } else if (selectedDay == yesterday) {
      return 'Ontem';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  Future<void> _submit(FirestoreService firestoreService, String envId) async {
    // Validações
    final valueText = _valueController.text.trim().replaceAll(',', '.');
    final value = double.tryParse(valueText);

    if (value == null || value <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Digite um valor válido')));
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione uma categoria')));
      return;
    }

    setState(() => _isSubmitting = true);

    final transaction = TransactionModel(
      userId: widget.userId,
      environmentId: envId,
      categoryId: _selectedCategory!.id!,
      categoryName: _selectedCategory!.nome,
      valor: value,
      descricao: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      tipo: widget.transactionType,
      data: _selectedDate,
    );

    final id = await firestoreService.addTransaction(transaction);

    setState(() => _isSubmitting = false);

    if (id != null && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${isExpense ? 'Despesa' : 'Receita'} adicionada com sucesso!',
          ),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao adicionar. Tente novamente.')),
      );
    }
  }
}
