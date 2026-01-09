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
import 'package:ioqoin/l10n/app_localizations.dart';

class FixedTransactionManagerSheet extends StatefulWidget {
  final String userId;
  final TransactionType transactionType;

  const FixedTransactionManagerSheet({
    super.key,
    required this.userId,
    required this.transactionType,
  });

  @override
  State<FixedTransactionManagerSheet> createState() =>
      _FixedTransactionManagerSheetState();
}

class _FixedTransactionManagerSheetState
    extends State<FixedTransactionManagerSheet> {
  bool _isAdding = false;
  final _valueController = TextEditingController();
  final _descriptionController = TextEditingController();
  CategoryModel? _selectedCategory;
  bool _isSubmitting = false;

  bool get isExpense => widget.transactionType == TransactionType.expense;
  Color get accentColor =>
      isExpense ? AppColors.alertRed : AppColors.successGreen;

  @override
  void dispose() {
    _valueController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _isAdding = false;
      _valueController.clear();
      _descriptionController.clear();
      _selectedCategory = null;
    });
  }

  Future<void> _submit(
    FirestoreService firestoreService,
    String envId,
    AppLocalizations l10n,
  ) async {
    final valueText = _valueController.text.trim().replaceAll(',', '.');
    final value = double.tryParse(valueText);

    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.enterValidValue),
          backgroundColor: AppColors.alertRed,
        ),
      );
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectCategoryError),
          backgroundColor: AppColors.alertRed,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final model = FixedTransactionModel(
        userId: widget.userId,
        environmentId: envId,
        categoryId: _selectedCategory!.id!,
        categoryName: _selectedCategory!.nome,
        categoryIcon: _selectedCategory!.icone,
        valor: value,
        descricao: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        tipo: widget.transactionType,
      );

      final id = await firestoreService.addFixedTransaction(model);

      if (!mounted) return;

      if (id != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.templateSavedSuccess),
            backgroundColor: AppColors.successGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        _resetForm();
      } else {
        throw Exception('Falha ao salvar');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.saveError(e.toString())),
          backgroundColor: AppColors.alertRed,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = context.watch<FirestoreService>();
    final envId =
        context.watch<EnvironmentService>().currentEnvironment?.id ?? '';
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Handle
            Container(
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.divider.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isExpense ? Icons.bookmark_border : Icons.star_border,
                      color: accentColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isExpense
                              ? l10n.fixedExpensesTitle
                              : l10n.fixedIncomeTitle,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.manageTemplatesSubtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isAdding)
                    IconButton(
                      onPressed: _resetForm,
                      icon: Icon(
                        Icons.close_rounded,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).cardColor,
                      ),
                    ),
                ],
              ),
            ),

            const Divider(color: AppColors.divider, height: 1),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isAdding
                    ? _buildAddForm(firestoreService, envId, l10n)
                    : _buildList(firestoreService, envId, l10n),
              ),
            ),

            // FAB Flutuante para Adicionar se não estiver adicionando
            if (!_isAdding)
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => _isAdding = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: accentColor.withValues(alpha: 0.4),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: Text(
                      l10n.createNewFixedButton,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
    FirestoreService firestoreService,
    String envId,
    AppLocalizations l10n,
  ) {
    return StreamBuilder<List<FixedTransactionModel>>(
      stream: firestoreService.getFixedTransactions(
        widget.userId,
        envId,
        widget.transactionType,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Check for specific error (like missing index)
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.alertRed,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.loadError,
                    style: TextStyle(
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${l10n.permissionOrIndexError}\n${snapshot.error}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.copy_all_outlined,
                    size: 48,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.noTemplatesFound,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    l10n.createTemplatesTip,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Dismissible(
              key: Key(item.id!),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.alertRed,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: Theme.of(context).dialogBackgroundColor,
                    title: Text(
                      l10n.deleteTemplateTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    content: Text(
                      l10n.deleteTemplateMessage,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(l10n.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(
                          l10n.deleteButton,
                          style: TextStyle(color: AppColors.alertRed),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onDismissed: (_) {
                firestoreService.deleteFixedTransaction(item.id!);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.templateRemoved)));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.divider.withValues(alpha: 0.05),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        CategoryIcons.getIcon(
                          item.categoryIcon,
                          isExpense: isExpense,
                        ),
                        color: accentColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.categoryName,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                          ),
                          if (item.descricao != null &&
                              item.descricao!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                item.descricao!,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'R\$ ${item.valor.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: (50 * index).ms).slideX();
          },
        );
      },
    );
  }

  Widget _buildAddForm(
    FirestoreService firestoreService,
    String envId,
    AppLocalizations l10n,
  ) {
    final categoriesStream = isExpense
        ? firestoreService.getExpenseCategories(widget.userId, envId)
        : firestoreService.getIncomeCategories(widget.userId, envId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Valor
          _buildLabel(l10n.defaultAmountLabel),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accentColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'R\$',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _valueController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0,00',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.3),
                      ),
                      isDense: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Categorias
          _buildLabel(l10n.categoryLabel),
          StreamBuilder<List<CategoryModel>>(
            stream: categoriesStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final categories = snapshot.data!;
              if (categories.isEmpty) {
                return Text(l10n.noCategoriesFound);
              }

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: categories.map((cat) {
                  final isSelected = _selectedCategory?.id == cat.id;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? accentColor
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? accentColor : Colors.transparent,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: accentColor.withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CategoryIcons.getIcon(
                              cat.icone,
                              isExpense: isExpense,
                            ),
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            cat.nome,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 32),

          // Descrição
          _buildLabel(l10n.descriptionOptionalLabel),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Ex: Aluguel do Apartamento',
                prefixIcon: Icon(Icons.notes, color: AppColors.textSecondary),
              ),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),

          const SizedBox(height: 40),

          // Botão Salvar
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isSubmitting
                  ? null
                  : () => _submit(firestoreService, envId, l10n),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      l10n.saveTemplateButton,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
