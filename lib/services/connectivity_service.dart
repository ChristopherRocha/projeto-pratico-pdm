import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = false;

  // Callbacks para notificar mudanças
  final List<Function(bool)> _listeners = [];

  factory ConnectivityService() {
    return _instance;
  }

  ConnectivityService._internal();

  bool get isConnected => _isConnected;

  /// Inicializa o monitoramento de conectividade
  Future<void> init() async {
    // Verifica status atual
    await _checkConnectivity();

    // Monitora mudanças
    _connectivity.onConnectivityChanged.listen((results) {
      _handleConnectivityChange(results);
    });
  }

  /// Verifica o status atual de conectividade
  Future<void> _checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _handleConnectivityChange(results);
    } catch (e) {
      print('Erro ao verificar conectividade: $e');
    }
  }

  /// Processa mudanças de conectividade
  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final wasConnected = _isConnected;
    _isConnected = results.isNotEmpty && !results.contains(ConnectivityResult.none);

    print('Conectividade: ${_isConnected ? 'ONLINE' : 'OFFLINE'}');

    // Se voltou a conectar, notifica os listeners
    if (!wasConnected && _isConnected) {
      print('Internet restaurada!');
      _notifyListeners(_isConnected);
    } else if (wasConnected && !_isConnected) {
      print('Internet desconectada!');
      _notifyListeners(_isConnected);
    }
  }

  /// Adiciona listener para mudanças de conectividade
  void addListener(Function(bool) callback) {
    _listeners.add(callback);
  }

  /// Remove listener
  void removeListener(Function(bool) callback) {
    _listeners.remove(callback);
  }

  /// Notifica todos os listeners
  void _notifyListeners(bool isConnected) {
    for (var listener in _listeners) {
      listener(isConnected);
    }
  }
}
