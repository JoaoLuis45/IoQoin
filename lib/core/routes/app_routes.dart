import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding/services/onboarding_service.dart';
import '../../features/home/screens/main_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/shared/screens/help_screen.dart';
import '../../features/shared/screens/about_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

/// Configuração de rotas do app iQoin
class AppRoutes {
  AppRoutes._();

  // Nomes das rotas
  static const String welcome = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String help = '/help';
  static const String about = '/about';
  static const String settings = '/settings';
  static const String onboarding = '/onboarding';

  /// Router principal do app
  static GoRouter router(
    AuthService authService,
    OnboardingService onboardingService,
  ) {
    return GoRouter(
      initialLocation: welcome,
      refreshListenable: Listenable.merge([authService, onboardingService]),
      redirect: (context, state) {
        // Se ainda está carregando estado do onboarding, aguarda
        if (onboardingService.isLoading) return null;

        final isAuthenticated = authService.isAuthenticated;
        final hasSeenOnboarding = onboardingService.hasSeenOnboarding;

        final isAuthRoute =
            state.matchedLocation == welcome ||
            state.matchedLocation == login ||
            state.matchedLocation == signup;
        final isOnboardingRoute = state.matchedLocation == onboarding;

        // 1. Regra de Segurança Básica:
        // Se não está autenticado e não está numa rota de auth, manda para welcome
        // Isso impede acesso ao onboarding se não estiver logado (requisito de "só após criar conta")
        if (!isAuthenticated && !isAuthRoute) {
          return welcome;
        }

        // 2. Regra de Onboarding (apenas para usuários logados):
        if (isAuthenticated) {
          // Se ainda não viu o onboarding e não está lá, força o onboarding
          if (!hasSeenOnboarding && !isOnboardingRoute) {
            return onboarding;
          }

          // Se já viu e está preso no onboarding (e não é replay), chuta para home
          final isReplay = state.uri.queryParameters['replay'] == 'true';
          if (hasSeenOnboarding && isOnboardingRoute && !isReplay) {
            return home;
          }

          // Se tentar acessar login/signup logado, manda para home
          if (isAuthRoute) {
            return home;
          }
        }

        return null;
      },
      routes: [
        GoRoute(
          path: onboarding,
          name: 'onboarding',
          builder: (context, state) {
            final isReplay = state.uri.queryParameters['replay'] == 'true';
            return OnboardingScreen(isReplay: isReplay);
          },
        ),
        // ===== Rotas de Autenticação =====
        GoRoute(
          path: welcome,
          name: 'welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: signup,
          name: 'signup',
          builder: (context, state) => const SignupScreen(),
        ),

        // ===== Rotas Protegidas =====
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const MainScreen(),
        ),
        GoRoute(
          path: profile,
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: help,
          name: 'help',
          builder: (context, state) => const HelpScreen(),
        ),
        GoRoute(
          path: about,
          name: 'about',
          builder: (context, state) => const AboutScreen(),
        ),
        GoRoute(
          path: settings,
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(child: Text('Página não encontrada: ${state.uri}')),
      ),
    );
  }
}
