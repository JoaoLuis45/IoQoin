import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/category_icons.dart';
import '../../auth/services/auth_service.dart';
import '../../home/models/category_model.dart';
import '../../shared/services/firestore_service.dart';
import '../../shared/services/sync_service.dart';
import '../../environments/services/environment_service.dart';
import '../../dashboard/screens/transactions_by_category_screen.dart';
import 'package:ioqoin/l10n/app_localizations.dart';

/// Tela dedicada para gestão de categorias (CRUD)
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _nameController = TextEditingController();

  // Ícone padrão inicial
  String _selectedIcon = 'outros';

  // Controle de UI
  bool _isAdding = false;

  // Controle de edição
  String? _editingCategoryId;
  bool get _isEditing => _editingCategoryId != null;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _selectedIcon = 'outros';
      _isAdding = false;
      _editingCategoryId = null;
      FocusScope.of(context).unfocus();
    });
  }

  void _startEditing(CategoryModel category) {
    setState(() {
      _nameController.text = category.nome;
      _selectedIcon = category.icone;
      _editingCategoryId = category.id;
      _isAdding = true; // Reusa o formulário de adição
    });
  }

  /// Helper para obter o IconData correto usando a classe utilitária
  IconData _getIconData(String iconName, bool isExpense) {
    return CategoryIcons.getIcon(iconName, isExpense: isExpense);
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final userId = authService.userModel?.uid;
    final envId =
        context.watch<EnvironmentService>().currentEnvironment?.id ?? '';

    // Se não tiver usuário logado, retorna loading
    if (userId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Abas superiores (Despesas / Receitas)
          // Usando uma cor ligeiramente diferente para distinguir do corpo, mas ainda escura
          Container(
            color: Theme.of(context).cardColor,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.voltCyan,
              labelColor: AppColors.voltCyan,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: [
                Tab(
                  text: AppLocalizations.of(context)!.categoriesTabExpenses,
                  icon: const Icon(Icons.money_off),
                ),
                Tab(
                  text: AppLocalizations.of(context)!.categoriesTabIncome,
                  icon: const Icon(Icons.attach_money),
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCategoryList(userId, envId, CategoryType.expense),
                _buildCategoryList(userId, envId, CategoryType.income),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _isAdding
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _isAdding = true;
                  _editingCategoryId = null;
                  _nameController.clear();
                  _selectedIcon = 'outros';
                });
              },
              backgroundColor: AppColors.voltCyan,
              foregroundColor: AppColors.deepFinBlue,
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.categoriesNewCategory),
            ),
    );
  }

  Widget _buildCategoryList(String userId, String envId, CategoryType type) {
    final firestoreService = context.watch<FirestoreService>();
    final isExpense = type == CategoryType.expense;
    final themeColor = isExpense ? AppColors.alertRed : AppColors.successGreen;

    return Column(
      children: [
        // Formulário de Adição/Edição (Animate height)
        AnimatedContainer(
          duration: 300.ms,
          height: _isAdding ? null : 0,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withValues(alpha: 0.3),
            // border: const Border(
            //   bottom: BorderSide(color: AppColors.divider, width: 0.5),
            // ), // REMOVIDO: Linha branca feia
            borderRadius: BorderRadius.circular(
              16,
            ), // Rounded for form container too if visible
          ),
          child: _isAdding
              ? _buildForm(firestoreService, userId, envId, type, themeColor)
              : null,
        ),

        // Tip de ajuda Redesenhado
        if (!_isAdding)
          Container(
            margin: const EdgeInsets.only(bottom: 24, top: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.voltCyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.voltCyan.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.touch_app_outlined,
                  size: 16,
                  color: AppColors.voltCyan.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.categoriesHistoryTip,
                  style: TextStyle(
                    color: AppColors.voltCyan.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

        // Lista de Categorias
        Expanded(
          child: StreamBuilder<List<CategoryModel>>(
            stream: firestoreService.getCategoriesStream(userId, envId, type),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.categoriesLoadError,
                    style: const TextStyle(color: AppColors.alertRed),
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
                        size: 64,
                        color: AppColors.textSecondary.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.categoriesEmpty,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<SyncService>().reload();
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                backgroundColor: Theme.of(context).cardColor,
                color: AppColors.voltCyan,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 80, top: 8),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    // category.id deve existir se veio do Firestore
                    final catId = category.id;

                    return Dismissible(
                      key: Key(catId ?? 'cat_$index'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: AppColors.alertRed,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Theme.of(
                              ctx,
                            ).dialogBackgroundColor,
                            title: Text(
                              AppLocalizations.of(
                                context,
                              )!.categoriesDeleteTitle,
                              style: Theme.of(ctx).textTheme.titleLarge,
                            ),
                            content: Text(
                              AppLocalizations.of(
                                context,
                              )!.categoriesDeleteMessage,
                              style: Theme.of(ctx).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: Text(
                                  AppLocalizations.of(context)!.cancel,
                                  style: const TextStyle(
                                    color: AppColors.voltCyan,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text(
                                  AppLocalizations.of(context)!.deleteButton,
                                  style: const TextStyle(
                                    color: AppColors.alertRed,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) {
                        if (catId != null) {
                          firestoreService.deleteCategory(catId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(
                                  context,
                                )!.categoriesDeleted(category.nome),
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              backgroundColor: Theme.of(context).cardColor,
                            ),
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).dividerColor.withValues(alpha: 0.1),
                          ),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: themeColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getIconData(category.icone, isExpense),
                              color: themeColor,
                              size: 20,
                            ),
                          ),
                          // Texto deve ser branco no tema escuro
                          title: Text(
                            category.nome,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            color: AppColors.textSecondary,
                            onPressed: () => _startEditing(category),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          onTap: () {
                            if (catId != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TransactionsByCategoryScreen(
                                        categoryId: catId,
                                        categoryName: category.nome,
                                        categoryIcon: category.icone,
                                        isExpense: isExpense,
                                      ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ).animate().fadeIn(delay: (50 * index).ms).slideX();
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildForm(
    FirestoreService firestoreService,
    String userId,
    String envId,
    CategoryType type,
    Color themeColor,
  ) {
    final isExpense = type == CategoryType.expense;
    final iconsMap = CategoryIcons.getAllIcons(isExpense: isExpense);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                _isEditing
                    ? AppLocalizations.of(context)!.categoriesEditCategory
                    : AppLocalizations.of(context)!.categoriesNewCategory,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.voltCyan, // Destaque
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: _resetForm,
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            style: Theme.of(context).textTheme.bodyLarge,
            cursorColor: AppColors.voltCyan,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.categoriesNameHint,
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              prefixIcon: Icon(
                _getIconData(_selectedIcon, isExpense),
                color: themeColor,
              ),
              filled: true,
              fillColor: Theme.of(
                context,
              ).cardColor, // Input contrastante mas escuro
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
                borderSide: BorderSide(
                  color: AppColors.voltCyan.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Seletor de Ícones
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: iconsMap.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final iconKey = iconsMap.keys.elementAt(index);
                final iconData = iconsMap.values.elementAt(index);
                final isSelected = _selectedIcon == iconKey;

                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = iconKey),
                  child: AnimatedContainer(
                    duration: 200.ms,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? themeColor
                          : Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? themeColor
                            : AppColors.divider.withValues(alpha: 0.1),
                        width: isSelected ? 0 : 1,
                      ),
                    ),
                    child: Icon(
                      iconData,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Botão Salvar/Adicionar
          FilledButton(
            onPressed: () async {
              if (_nameController.text.trim().isEmpty) return;

              final name = _nameController.text.trim();

              if (_isEditing) {
                // Update
                final updatedCategory = CategoryModel(
                  id: _editingCategoryId,
                  userId: userId,
                  environmentId: envId,
                  nome: name,
                  icone: _selectedIcon,
                  tipo: type,
                );
                await firestoreService.updateCategory(updatedCategory);
              } else {
                // Add
                final category = CategoryModel(
                  id: null, // Firestore gera ID
                  userId: userId,
                  environmentId: envId,
                  nome: name,
                  icone: _selectedIcon,
                  tipo: type,
                );
                await firestoreService.addCategory(category);
              }
              _resetForm();
            },
            style: FilledButton.styleFrom(
              backgroundColor: themeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _isEditing
                  ? AppLocalizations.of(context)!.categoriesSaveButton
                  : AppLocalizations.of(context)!.categoriesAddButton,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
