import 'package:flutter/material.dart';
import 'package:trabalho_pratico/database/database_helper.dart';
import 'package:trabalho_pratico/services/index.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabalho Prático - Offline First',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(
        title: 'Trabalho Prático - Offline First',
        syncService: syncService,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.syncService,
  });

  final String title;
  final SyncService syncService;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Contador de cliques:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    '📡 Status de Sincronização',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.syncService.isSyncing
                        ? '🔄 Sincronizando...'
                        : '✓ Pronto',
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.syncService.isSyncing
                          ? Colors.orange
                          : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      print('Forçando sincronização...');
                      await widget.syncService.forceSync();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sincronização iniciada!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: const Text('🔄 Sincronizar Agora'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
