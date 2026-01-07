import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  // Lista de FAQs
  final List<Map<String, String>> _faqs = [
    {
      'question': 'Como adiciono uma nova transação?',
      'answer':
          'Na tela inicial, toque na aba "Despesas" ou "Receitas" e use o botão "+" no canto inferior direito. Preencha os dados e salve.',
    },
    {
      'question': 'Posso editar uma transação?',
      'answer':
          'Atualmente, para garantir a integridade dos dados, recomendamos excluir a transação incorreta (deslizando para a esquerda) e criar uma nova.',
    },
    {
      'question': 'Como funcionam os Objetivos?',
      'answer':
          'Na aba "Objetivos", você pode criar metas financeiras (ex: Viagem, Carro). Defina um valor alvo e adicione economias progressivamente para acompanhar seu progresso visualmente.',
    },
    {
      'question': 'O que são as Inscrições?',
      'answer':
          'A aba "Inscrições" serve para listar seus gastos recorrentes (Netflix, Spotify, Academia). Isso ajuda a visualizar quanto do seu orçamento mensal já está comprometido.',
    },
    {
      'question': 'Meus dados estão seguros?',
      'answer':
          'Sim! Seus dados são armazenados na nuvem do Google (Firebase) com autenticação segura. Apenas você tem acesso às suas informações.',
    },
    {
      'question': 'Como altero minha senha?',
      'answer':
          'Vá até o menu lateral, toque em "Perfil" e selecione a opção "Alterar senha". Um email de redefinição será enviado para você.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuda e FAQ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Cabeçalho
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.voltCyan.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.help_outline,
                    size: 40,
                    color: AppColors.voltCyan,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Como podemos ajudar?',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Confira as perguntas frequentes abaixo',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),

          const SizedBox(height: 32),

          // FAQ List
          ..._faqs.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _buildFaqItem(item['question']!, item['answer']!)
                .animate(delay: Duration(milliseconds: index * 100))
                .fadeIn()
                .slideX(begin: 0.1);
          }),

          const SizedBox(height: 32),

          // Contato (Placeholder)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.deepFinBlueLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.voltCyan.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Ainda tem dúvidas?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pureWhite,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Entre em contato com o suporte',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () async {
                      const phoneNumber = '5581997947843';
                      final url = Uri.parse('https://wa.me/$phoneNumber');
                      try {
                        if (!await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        )) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Não foi possível abrir o WhatsApp',
                                ),
                                backgroundColor: AppColors.alertRed,
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Erro ao tentar abrir o WhatsApp'),
                              backgroundColor: AppColors.alertRed,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text('Fale Conosco no WhatsApp'),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 600.ms),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.deepFinBlueLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.pureWhite,
            ),
          ),
          iconColor: AppColors.voltCyan,
          collapsedIconColor: AppColors.textSecondary,
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Text(
              answer,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
