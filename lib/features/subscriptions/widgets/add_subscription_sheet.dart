import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/subscription_icons.dart';
import '../../shared/services/firestore_service.dart';
import '../models/subscription_model.dart';

/// Sheet para adicionar nova assinatura
class AddSubscriptionSheet extends StatefulWidget {
  final String userId;

  const AddSubscriptionSheet({super.key, required this.userId});

  @override
  State<AddSubscriptionSheet> createState() => _AddSubscriptionSheetState();
}

class _AddSubscriptionSheetState extends State<AddSubscriptionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _valorController = TextEditingController();

  String _selectedIcon = 'subscriptions';
  SubscriptionFrequency _selectedFrequency = SubscriptionFrequency.monthly;
  int _diaCobranca = 10;
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.deepFinBlue,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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

                Center(
                  child: Text(
                    'Nova Assinatura',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                const SizedBox(height: 24),

                // Nome
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome da assinatura',
                    hintText: 'Ex: Netflix, Spotify',
                    prefixIcon: Icon(Icons.subscriptions_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite um nome';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Valor
                TextFormField(
                  controller: _valorController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    hintText: '0,00',
                    prefixText: 'R\$ ',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite um valor';
                    }
                    final parsed = double.tryParse(value.replaceAll(',', '.'));
                    if (parsed == null || parsed <= 0) {
                      return 'Valor inválido';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Frequência
                Text(
                  'Frequência',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: SubscriptionFrequency.values.map((freq) {
                    final isSelected = freq == _selectedFrequency;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedFrequency = freq),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(
                            right: freq != SubscriptionFrequency.yearly ? 8 : 0,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.voltCyan.withValues(alpha: 0.2)
                                : AppColors.deepFinBlueLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.voltCyan
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            freq.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.voltCyan
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Dia de cobrança
                Text(
                  'Dia de cobrança',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _diaCobranca.toDouble(),
                        min: 1,
                        max: 28,
                        divisions: 27,
                        activeColor: AppColors.voltCyan,
                        inactiveColor: AppColors.deepFinBlueLight,
                        onChanged: (value) {
                          setState(() => _diaCobranca = value.round());
                        },
                      ),
                    ),
                    Container(
                      width: 48,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.voltCyan.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$_diaCobranca',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.voltCyan,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Seletor de ícone
                Text(
                  'Ícone',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: SubscriptionIcons.allKeys.length,
                    itemBuilder: (context, index) {
                      final key = SubscriptionIcons.allKeys[index];
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
                                : AppColors.deepFinBlueLight,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.voltCyan
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            SubscriptionIcons.getIcon(key),
                            color: isSelected
                                ? AppColors.voltCyan
                                : AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Botão criar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _createSubscription,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.deepFinBlue,
                            ),
                          )
                        : const Text('Adicionar assinatura'),
                  ),
                ).animate().fadeIn(delay: 200.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createSubscription() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final firestoreService = context.read<FirestoreService>();
      final valor = double.parse(_valorController.text.replaceAll(',', '.'));

      final subscription = SubscriptionModel(
        userId: widget.userId,
        nome: _nomeController.text.trim(),
        icone: _selectedIcon,
        valor: valor,
        frequencia: _selectedFrequency,
        diaCobranca: _diaCobranca,
      );

      await firestoreService.addSubscription(subscription);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Assinatura adicionada!'),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: AppColors.alertRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
