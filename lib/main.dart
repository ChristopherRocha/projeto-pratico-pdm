import 'package:flutter/material.dart';
import 'package:trabalho_pratico/database/database_helper.dart';
import 'package:trabalho_pratico/services/index.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/events_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa banco de dados
  print('🔧 Inicializando banco de dados...');
  final db = DatabaseHelper();
  await db.database;
  print('✓ Banco de dados pronto');

  // Inicializa conectividade
  print('🔧 Inicializando monitoramento de conectividade...');
  final connectivityService = ConnectivityService();
  await connectivityService.init();
  print('✓ Conectividade pronta');

  // Inicializa serviço de API
  print('🔧 Inicializando serviço de API...');
  final apiService = ApiService();
  print('✓ API pronta');

  // Inicializa sincronizador
  print('🔧 Inicializando sincronizador...');
  final syncService = SyncService(
    apiService: apiService,
    connectivityService: connectivityService,
  );
  await syncService.init();
  print('✓ Sincronizador pronto\n');

  runApp(MyApp(syncService: syncService));
}

class MyApp extends StatelessWidget {
  final SyncService syncService;

  const MyApp({super.key, required this.syncService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeeKind',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: NavigationManager(syncService: syncService),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NavigationManager extends StatefulWidget {
  final SyncService syncService;

  const NavigationManager({super.key, required this.syncService});

  @override
  State<NavigationManager> createState() => _NavigationManagerState();
}

class _NavigationManagerState extends State<NavigationManager> {
  String _currentRoute = 'login';

  void _navigateTo(String route) {
    setState(() {
      _currentRoute = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentRoute) {
      case 'login':
        return LoginScreen(onNavigate: _navigateTo);
      case 'home':
        return HomeScreen(onNavigate: _navigateTo);
      case 'profile':
        return ProfileScreen(onNavigate: _navigateTo);
      case 'contacts':
        return ContactsScreen(onNavigate: _navigateTo);
      case 'events':
        return EventsScreen(onNavigate: _navigateTo);
      default:
        return LoginScreen(onNavigate: _navigateTo);
    }
  }
}
