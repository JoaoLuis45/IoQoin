import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/category_icons.dart';
import '../../auth/services/auth_service.dart';
import '../../home/models/category_model.dart';
import '../../shared/services/firestore_service.dart';

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

    // Se não tiver usuário logado, retorna loading
    if (userId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: AppColors.deepFinBlue, // Dark theme para consistência
      body: Column(
        children: [
          // Abas superiores (Despesas / Receitas)
          // Usando uma cor ligeiramente diferente para distinguir do corpo, mas ainda escura
          Container(
            color: AppColors.deepFinBlueLight,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.voltCyan,
              labelColor: AppColors.voltCyan,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: const [
                Tab(text: 'Despesas', icon: Icon(Icons.money_off)),
                Tab(text: 'Receitas', icon: Icon(Icons.attach_money)),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCategoryList(userId, CategoryType.expense),
                _buildCategoryList(userId, CategoryType.income),
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
              label: const Text('Nova Categoria'),
            ),
    );
  }

  Widget _buildCategoryList(String userId, CategoryType type) {
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
            color: AppColors.deepFinBlueLight.withValues(alpha: 0.3),
            border: const Border(
              bottom: BorderSide(color: AppColors.divider, width: 0.5),
            ),
          ),
          child: _isAdding
              ? _buildForm(firestoreService, userId, type, themeColor)
              : null,
        ),

        // Lista de Categorias
        Expanded(
          child: StreamBuilder<List<CategoryModel>>(
            stream: firestoreService.getCategoriesStream(userId, type),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Erro ao carregar categorias',
                    style: TextStyle(color: AppColors.alertRed),
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
                      const Text(
                        'Nenhuma categoria encontrada',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
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
                          backgroundColor: AppColors.deepFinBlue,
                          title: const Text(
                            'Excluir categoria?',
                            style: TextStyle(color: AppColors.pureWhite),
                          ),
                          content: const Text(
                            'Isso não excluirá as transações existentes.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(color: AppColors.voltCyan),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text(
                                'Excluir',
                                style: TextStyle(color: AppColors.alertRed),
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
                              'Categoria "${category.nome}" excluída',
                              style: const TextStyle(
                                color: AppColors.pureWhite,
                              ),
                            ),
                            backgroundColor: AppColors.deepFinBlueLight,
                          ),
                        );
                      }
                    },
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: themeColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getIconData(category.icone, isExpense),
                          color: themeColor,
                        ),
                      ),
                      // Texto deve ser branco no tema escuro
                      title: Text(
                        category.nome,
                        style: const TextStyle(color: AppColors.pureWhite),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        color: AppColors.textSecondary,
                        onPressed: () => _startEditing(category),
                      ),
                    ),
                  ).animate().fadeIn(delay: (50 * index).ms).slideX();
                },
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
                _isEditing ? 'Editar Categoria' : 'Nova Categoria',
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
            style: const TextStyle(color: AppColors.pureWhite),
            cursorColor: AppColors.voltCyan,
            decoration: InputDecoration(
              hintText: 'Nome da categoria',
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              prefixIcon: Icon(
                _getIconData(_selectedIcon, isExpense),
                color: themeColor,
              ),
              filled: true,
              fillColor:
                  AppColors.deepFinBlueLight, // Input contrastante mas escuro
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
                          : AppColors.deepFinBlueLight,
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
              _isEditing ? 'Salvar Alterações' : 'Adicionar',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
