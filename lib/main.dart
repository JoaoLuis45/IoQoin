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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const IoQoinApp());
}

/// App principal do IoQoin
class IoQoinApp extends StatelessWidget {
  const IoQoinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => FirestoreService()),
        Provider(create: (_) => StorageService()),
      ],
      child: const IoQoinRouter(),
    );
  }
}

class IoQoinRouter extends StatefulWidget {
  const IoQoinRouter({super.key});

  @override
  State<IoQoinRouter> createState() => _IoQoinRouterState();
}

class _IoQoinRouterState extends State<IoQoinRouter> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Cria o router uma única vez
    final authService = context.read<AuthService>();
    _router = AppRoutes.router(authService);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'IoQoin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}
