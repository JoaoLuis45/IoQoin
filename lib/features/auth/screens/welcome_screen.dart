import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';

/// Tela de boas-vindas do iQoin
/// Primeira tela que o usuário vê ao abrir o app
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo e Branding
              _buildLogo()
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.8, 0.8)),

              const SizedBox(height: 24),

              // Tagline
              Text(
                    'Controle suas finanças\nde forma inteligente',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.pureWhite.withValues(alpha: 0.9),
                      height: 1.3,
                    ),
                  )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 16),

              Text(
                'Receitas, despesas e objetivos\ntudo em um só lugar',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ).animate(delay: 500.ms).fadeIn(duration: 500.ms),

              const Spacer(flex: 3),

              // Botão Criar Conta
              SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push(AppRoutes.signup),
                      child: const Text('Criar conta'),
                    ),
                  )
                  .animate(delay: 700.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 16),

              // Botão Entrar
              SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.push(AppRoutes.login),
                      child: const Text('Entrar'),
                    ),
                  )
                  .animate(delay: 800.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.3, end: 0),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 120, // Altura do container anterior
        ),
        const SizedBox(height: 20),
        const Text(
          'iQoin',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.pureWhite,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
