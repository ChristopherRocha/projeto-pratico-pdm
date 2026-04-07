/// Configurações da API
///
/// Altere [apiBaseUrl] para apontar para sua máquina/servidor
/// Exemplos:
/// - Local (Android Emulator): http://10.0.2.2:5000
/// - Local (iOS Simulator): http://localhost:5000
/// - Local (Dispositivo físico): http://seu_ip_local:5000
/// - Servidor remoto: https://sua-api.com
class ApiConfig {
  // ALTERE AQUI PARA SUA API
  static const String apiBaseUrl = 'http://10.0.2.2:5000';

  static const String authEndpoint = '/api/Auth';
  static const String eventsEndpoint = '/api/Event';
  static const String contactsEndpoint = '/api/Contact';
  static const String usersEndpoint = '/api/User';

  static const int connectionTimeout = 10000; // ms
  static const int receiveTimeout = 10000; // ms
}
