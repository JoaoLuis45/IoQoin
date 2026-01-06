import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/home/screens/main_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/shared/screens/help_screen.dart';
import '../../features/shared/screens/about_screen.dart';

/// Configuração de rotas do app IoQoin
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

  /// Router principal do app
  static GoRouter router(AuthService authService) {
    return GoRouter(
      initialLocation: welcome,
      refreshListenable: authService,
      redirect: (context, state) {
        final isAuthenticated = authService.isAuthenticated;
        final isAuthRoute =
            state.matchedLocation == welcome ||
            state.matchedLocation == login ||
            state.matchedLocation == signup;

        // Se não está autenticado e não está numa rota de auth, redireciona para welcome
        if (!isAuthenticated && !isAuthRoute) {
          return welcome;
        }

        // Se está autenticado e está numa rota de auth, redireciona para home
        if (isAuthenticated && isAuthRoute) {
          return home;
        }

        return null;
      },
      routes: [
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
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(child: Text('Página não encontrada: ${state.uri}')),
      ),
    );
  }
}
