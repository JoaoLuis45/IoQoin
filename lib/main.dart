import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'features/auth/services/auth_service.dart';
import 'features/shared/services/firestore_service.dart';
import 'features/shared/services/storage_service.dart';
import 'features/notifications/services/notification_service.dart';
import 'features/environments/services/environment_service.dart';
import 'features/invites/services/invite_service.dart';
import 'features/shared/services/sync_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ioqoin/l10n/app_localizations.dart';
import 'features/settings/services/theme_service.dart';
import 'features/settings/services/locale_service.dart';
import 'core/constants/global_keys.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inicializa formatação de datas (pt_BR)
  await initializeDateFormatting('pt_BR', null);

  runApp(const IQoinApp());
}

/// App principal do iQoin
class IQoinApp extends StatelessWidget {
  const IQoinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => EnvironmentService()),
        ChangeNotifierProvider(create: (_) => FirestoreService()),
        ChangeNotifierProvider(create: (_) => InviteService()),
        Provider(create: (_) => StorageService()),
        ChangeNotifierProvider(create: (_) => NotificationService()),
        ChangeNotifierProvider(create: (_) => SyncService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => LocaleService()),
      ],
      child: const IQoinRouter(),
    );
  }
}

class IQoinRouter extends StatefulWidget {
  const IQoinRouter({super.key});

  @override
  State<IQoinRouter> createState() => _IQoinRouterState();
}

class _IQoinRouterState extends State<IQoinRouter> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Cria o router uma única vez
    final authService = context.read<AuthService>();
    final envService = context.read<EnvironmentService>();

    // Listen to changes to initialize environments
    // Função interna para verificar e inicializar o ambiente
    void checkAndInitEnvironment() {
      final user = authService.user;
      if (user != null) {
        // Se mudou o usuário ou ainda não tem ambiente carregado
        if (envService.currentEnvironment?.userId != user.uid) {
          envService.initialize(user.uid);
        }
      } else {
        // Logout
        if (envService.currentEnvironment != null) {
          envService.clearEnvironment();
        }
      }
    }

    // Listen to changes
    authService.addListener(checkAndInitEnvironment);

    // Verificação inicial imediata (para caso já esteja logado ao iniciar)
    checkAndInitEnvironment();

    _router = AppRoutes.router(authService);
  }

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();
    final localeService = context.watch<LocaleService>();

    return MaterialApp.router(
      scaffoldMessengerKey: rootScaffoldMessengerKey, // Add key
      title: 'iQoin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeService.themeMode,
      locale: localeService.locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
