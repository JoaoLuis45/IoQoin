import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/services/auth_service.dart';
import '../models/environment_model.dart';
import '../services/environment_service.dart';

class EnvironmentFormScreen extends StatefulWidget {
  final EnvironmentModel? environment;

  const EnvironmentFormScreen({super.key, this.environment});

  @override
  State<EnvironmentFormScreen> createState() => _EnvironmentFormScreenState();
}

class _EnvironmentFormScreenState extends State<EnvironmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late int _selectedIconCode;
  late String _selectedColorHex;
  bool _isDefault = false;
  bool _isLoading = false;

  final List<String> _colors = [
    '0xFF2196F3', // Blue
    '0xFF4CAF50', // Green
    '0xFFF44336', // Red
    '0xFFFFEB3B', // Yellow
    '0xFF9C27B0', // Purple
    '0xFFFF9800', // Orange
    '0xFF00BCD4', // Cyan
    '0xFF795548', // Brown
  ];

  final List<int> _icons = [
    58536, // person
    57534, // home
    57685, // work
    59404, // shopping_cart
    59501, // travel
    57560, // savings
    59640, // restaurant
    57563, // directions_car
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.environment?.name ?? '',
    );
    _selectedIconCode = widget.environment?.iconCodePoint ?? _icons.first;
    _selectedColorHex = widget.environment?.colorHex ?? _colors.first;
    _isDefault = widget.environment?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final envService = context.read<EnvironmentService>();
      final userId = context.read<AuthService>().user!.uid;

      if (widget.environment == null) {
        // Create
        await envService.createEnvironment(
          userId: userId,
          name: _nameController.text.trim(),
          iconCodePoint: _selectedIconCode,
          colorHex: _selectedColorHex,
          isDefault: _isDefault,
        );
      } else {
        // Update
        final updatedEnv = widget.environment!.copyWith(
          name: _nameController.text.trim(),
          iconCodePoint: _selectedIconCode,
          colorHex: _selectedColorHex,
          isDefault: _isDefault,
        );
        await envService.updateEnvironment(updatedEnv);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _delete() async {
    if (widget.environment == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.deepFinBlueLight,
        title: const Text(
          'Excluir Ambiente',
          style: TextStyle(color: AppColors.pureWhite),
        ),
        content: const Text(
          'Tem certeza? Isso não apagará as transações associadas por enquanto (serão inacessíveis).',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: AppColors.alertRed),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      final envService = context.read<EnvironmentService>();
      await envService.deleteEnvironment(
        widget.environment!.userId,
        widget.environment!.id!,
      );
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepFinBlue,
      appBar: AppBar(
        title: Text(
          widget.environment == null ? 'Novo Ambiente' : 'Editar Ambiente',
        ),
        backgroundColor: AppColors.deepFinBlue,
        foregroundColor: AppColors.pureWhite,
        actions: [
          if (widget.environment != null)
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.alertRed),
              onPressed: _isLoading ? null : _delete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nome
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.pureWhite),
                decoration: InputDecoration(
                  labelText: 'Nome do Ambiente',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.textSecondary,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.voltCyan),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe um nome' : null,
              ),

              const SizedBox(height: 24),

              // Cor
              const Text(
                'Cor',
                style: TextStyle(color: AppColors.pureWhite, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _colors.map((colorHex) {
                  final color = Color(int.parse(colorHex));
                  final isSelected = _selectedColorHex == colorHex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColorHex = colorHex),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: AppColors.pureWhite, width: 3)
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: AppColors.pureWhite)
                          : null,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Ícone
              const Text(
                'Ícone',
                style: TextStyle(color: AppColors.pureWhite, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _icons.map((code) {
                  final isSelected = _selectedIconCode == code;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIconCode = code),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.voltCyan.withValues(alpha: 0.2)
                            : AppColors.deepFinBlueLight,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: AppColors.voltCyan)
                            : null,
                      ),
                      child: Icon(
                        IconData(code, fontFamily: 'MaterialIcons'),
                        color: isSelected
                            ? AppColors.voltCyan
                            : AppColors.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Default Checkbox
              SwitchListTile(
                title: const Text(
                  'Definir como padrão',
                  style: TextStyle(color: AppColors.pureWhite),
                ),
                value: _isDefault,
                activeColor: AppColors.voltCyan,
                onChanged: (v) => setState(() => _isDefault = v),
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 40),

              // Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.voltCyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: AppColors.deepFinBlue,
                        )
                      : Text(
                          widget.environment == null
                              ? 'CRIAR AMBIENTE'
                              : 'SALVAR ALTERAÇÕES',
                          style: const TextStyle(
                            color: AppColors.deepFinBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
