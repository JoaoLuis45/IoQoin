import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/goal_icons.dart';
import '../../shared/services/firestore_service.dart';
import '../models/goal_model.dart';
import 'package:ioqoin/l10n/app_localizations.dart';

/// Sheet para adicionar novo objetivo
class AddGoalSheet extends StatefulWidget {
  final String userId;

  const AddGoalSheet({super.key, required this.userId});

  @override
  State<AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends State<AddGoalSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _valorController = TextEditingController();

  String _selectedIcon = 'savings';
  DateTime _dataLimite = DateTime.now().add(const Duration(days: 90));
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
          24,
          16,
          24,
          24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
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

                const SizedBox(height: 20),

                // Título
                Center(
                  child: Text(
                    l10n.newGoalTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                const SizedBox(height: 24),

                // Nome
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: l10n.goalNameLabel,
                    hintText: l10n.goalNameHint,
                    prefixIcon: const Icon(Icons.flag_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.goalNameRequired;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Valor alvo
                TextFormField(
                  controller: _valorController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.targetAmountLabel,
                    hintText: '0,00',
                    prefixText: 'R\$ ',
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.targetAmountRequired;
                    }
                    final parsed = double.tryParse(value.replaceAll(',', '.'));
                    if (parsed == null || parsed <= 0) {
                      return l10n.invalidAmountError;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Seletor de ícone
                Text(
                  l10n.iconLabel,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: GoalIcons.allKeys.length,
                    itemBuilder: (context, index) {
                      final key = GoalIcons.allKeys[index];
                      final isSelected = key == _selectedIcon;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedIcon = key),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 52,
                          height: 52,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.voltCyan.withValues(alpha: 0.2)
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.voltCyan
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            GoalIcons.getIcon(key),
                            color: isSelected
                                ? AppColors.voltCyan
                                : AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Data limite
                Text(
                  l10n.deadlineDateLabel,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: AppColors.voltCyan,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formatDate(_dataLimite, l10n),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Spacer(),
                        Text(
                          l10n.daysRemaining(
                            _dataLimite
                                .difference(DateTime.now())
                                .inDays
                                .toString(),
                          ),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Botão criar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _createGoal,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.deepFinBlue,
                            ),
                          )
                        : Text(l10n.createGoalButton),
                  ),
                ).animate().fadeIn(delay: 200.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    return DateFormat.yMMMd(l10n.localeName).format(date);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataLimite,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.voltCyan,
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
      setState(() => _dataLimite = picked);
    }
  }

  Future<void> _createGoal() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final firestoreService = context.read<FirestoreService>();
      final valor = double.parse(_valorController.text.replaceAll(',', '.'));

      final goal = GoalModel(
        userId: widget.userId,
        nome: _nomeController.text.trim(),
        icone: _selectedIcon,
        valorAlvo: valor,
        dataLimite: _dataLimite,
      );

      await firestoreService.addGoal(goal);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.goalCreatedSuccess),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.createGoalError(e.toString())),
            backgroundColor: AppColors.alertRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
