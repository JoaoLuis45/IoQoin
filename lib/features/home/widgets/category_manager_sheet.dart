import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/category_icons.dart';
import '../../shared/services/firestore_service.dart';
import '../models/category_model.dart';

/// Sheet para gerenciar categorias (CRUD)
class CategoryManagerSheet extends StatefulWidget {
  final String userId;
  final CategoryType categoryType;

  const CategoryManagerSheet({
    super.key,
    required this.userId,
    required this.categoryType,
  });

  @override
  State<CategoryManagerSheet> createState() => _CategoryManagerSheetState();
}

class _CategoryManagerSheetState extends State<CategoryManagerSheet> {
  final _nameController = TextEditingController();
  String _selectedIcon = 'outros';
  bool _isAdding = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get isExpense => widget.categoryType == CategoryType.expense;

  @override
  Widget build(BuildContext context) {
    final firestoreService = context.watch<FirestoreService>();
    final icons = CategoryIcons.getAllIcons(isExpense: isExpense);
    final color = isExpense ? AppColors.alertRed : AppColors.successGreen;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
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
                    'Categorias de ${isExpense ? 'Despesas' : 'Receitas'}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.divider),

            // Formulário para adicionar
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nova categoria',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),

                  // Campo de nome
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Nome da categoria',
                      prefixIcon: Icon(Icons.label_outline),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),

                  const SizedBox(height: 16),

                  // Seletor de ícone
                  Text(
                    'Selecione um ícone',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  SizedBox(
                    height: 56,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: icons.length,
                      itemBuilder: (context, index) {
                        final entry = icons.entries.elementAt(index);
                        final isSelected = _selectedIcon == entry.key;

                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedIcon = entry.key);
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color.withValues(alpha: 0.2)
                                  : AppColors.deepFinBlueLight,
                              borderRadius: BorderRadius.circular(12),
                              border: isSelected
                                  ? Border.all(color: color, width: 2)
                                  : null,
                            ),
                            child: Icon(
                              entry.value,
                              color: isSelected
                                  ? color
                                  : AppColors.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Botão adicionar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isAdding
                          ? null
                          : () {
                              FocusScope.of(context).unfocus();
                              _addCategory(firestoreService);
                            },
                      style: ElevatedButton.styleFrom(backgroundColor: color),
                      child: _isAdding
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.pureWhite,
                              ),
                            )
                          : const Text('Adicionar categoria'),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.divider),

            // Lista de categorias existentes
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text(
                    'Suas categorias',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),

            Expanded(
              child: StreamBuilder<List<CategoryModel>>(
                stream: isExpense
                    ? firestoreService.getExpenseCategories(widget.userId)
                    : firestoreService.getIncomeCategories(widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.voltCyan,
                      ),
                    );
                  }

                  final categories = snapshot.data ?? [];

                  if (categories.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 60,
                            color: color.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Nenhuma categoria criada',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Adicione categorias acima',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.textSecondary.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _buildCategoryItem(
                            context,
                            category,
                            firestoreService,
                            color,
                          )
                          .animate(delay: Duration(milliseconds: index * 30))
                          .fadeIn()
                          .slideX(begin: 0.05);
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

  Widget _buildCategoryItem(
    BuildContext context,
    CategoryModel category,
    FirestoreService firestoreService,
    Color color,
  ) {
    final icon = CategoryIcons.getIcon(category.icone, isExpense: isExpense);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.deepFinBlueLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.nome,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            color: AppColors.textSecondary,
            onPressed: () =>
                _showEditDialog(context, category, firestoreService),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            color: AppColors.alertRed,
            onPressed: () =>
                _confirmDelete(context, category, firestoreService),
          ),
        ],
      ),
    );
  }

  Future<void> _addCategory(FirestoreService firestoreService) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o nome da categoria')),
      );
      return;
    }

    setState(() => _isAdding = true);

    final category = CategoryModel(
      userId: widget.userId,
      nome: name,
      icone: _selectedIcon,
      tipo: widget.categoryType,
    );

    final id = await firestoreService.addCategory(category);

    setState(() => _isAdding = false);

    if (id != null) {
      _nameController.clear();
      _selectedIcon = 'outros';
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Categoria adicionada!')));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao adicionar categoria')),
        );
      }
    }
  }

  Future<void> _showEditDialog(
    BuildContext context,
    CategoryModel category,
    FirestoreService firestoreService,
  ) async {
    final controller = TextEditingController(text: category.nome);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.deepFinBlueLight,
        title: const Text('Editar categoria'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nome da categoria'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != category.nome) {
      final updated = category.copyWith(nome: newName);
      await firestoreService.updateCategory(updated);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    CategoryModel category,
    FirestoreService firestoreService,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.deepFinBlueLight,
        title: const Text('Excluir categoria'),
        content: Text('Deseja excluir "${category.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.alertRed),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await firestoreService.deleteCategory(category.id!);
    }
  }
}
