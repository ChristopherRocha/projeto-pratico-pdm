// Se sua API retorna campos diferentes, mape aqui!
// Este arquivo mostra como customizar o parsing dos endponts

import 'models/index.dart';

/// Se sua API retorna "eventName" em vez de "title"
/// ou "createdDate" em vez de "date", mapeie aqui
class ApiResponseMapper {
  
  /// Mapeia resposta da API para Event
  static Event toEvent(Map<String, dynamic> json) {
    // Exemplo: se sua API usa "eventName" em vez de "title"
    return Event(
      id: json['id'] as String? ?? json['eventId'] as String? ?? '',
      title: json['title'] as String? ?? json['eventName'] as String? ?? '',
      date: DateTime.parse(
        json['date'] as String? ?? 
        json['createdDate'] as String? ?? 
        DateTime.now().toIso8601String()
      ),
      location: json['location'] as String? ?? json['eventLocation'] as String? ?? '',
      contactId: json['contactId'] as String? ?? json['personId'] as String? ?? '',
      description: json['description'] as String? ?? json['details'] as String? ?? '',
      message: json['message'] as String? ?? json['notes'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      isDirty: false,
      isDeleted: false,
      syncStatus: 'synced',
    );
  }

  /// Mapeia resposta da API para Contact
  static Contact toContact(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String? ?? json['contactId'] as String? ?? '',
      name: json['name'] as String? ?? json['contactName'] as String? ?? '',
      email: json['email'] as String? ?? json['contactEmail'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? json['phone'] as String? ?? '',
      userId: json['userId'] as String? ?? json['personId'] as String? ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      isDirty: false,
      isDeleted: false,
      syncStatus: 'synced',
    );
  }

  /// Mapeia resposta da API para User
  static User toUser(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? json['userId'] as String? ?? '',
      name: json['name'] as String? ?? json['userName'] as String? ?? '',
      email: json['email'] as String? ?? json['userEmail'] as String? ?? '',
      identityUserId: json['identityUserId'] as String? ?? json['aspNetUserId'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      isDirty: false,
      isDeleted: false,
      syncStatus: 'synced',
    );
  }

  /// Usa isto se sua API retorna wrapper
  /// Exemplo: { "data": [...] } em vez de [...]
  static List<Event> parseEventList(dynamic response) {
    // Se retorna { "data": [...] }
    if (response is Map && response.containsKey('data')) {
      return (response['data'] as List)
          .map((e) => toEvent(e as Map<String, dynamic>))
          .toList();
    }
    // Se retorna [...] diretamente
    if (response is List) {
      return response
          .map((e) => toEvent(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  static List<Contact> parseContactList(dynamic response) {
    if (response is Map && response.containsKey('data')) {
      return (response['data'] as List)
          .map((e) => toContact(e as Map<String, dynamic>))
          .toList();
    }
    if (response is List) {
      return response
          .map((e) => toContact(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  static List<User> parseUserList(dynamic response) {
    if (response is Map && response.containsKey('data')) {
      return (response['data'] as List)
          .map((e) => toUser(e as Map<String, dynamic>))
          .toList();
    }
    if (response is List) {
      return response
          .map((e) => toUser(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}

// ============ COMO USAR ============

// Substitua em lib/services/api_service.dart:

/*
// ANTES:
Future<List<Event>> fetchEvents() async {
  final response = await _dio.get(ApiConfig.eventsEndpoint);
  final List<dynamic> data = response.data;
  return data.map((e) => Event.fromMap(e)).toList();
}

// DEPOIS (se sua API retorna formato diferente):
Future<List<Event>> fetchEvents() async {
  final response = await _dio.get(ApiConfig.eventsEndpoint);
  return ApiResponseMapper.parseEventList(response.data);
}
*/

// Exemplo com campo diferente:
class ExemploCustomizado {
  static Event meuCampoEspecial(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      title: json['nome_evento'] ?? '', // Seu campo
      date: DateTime.parse(json['data_evento'] ?? DateTime.now().toIso8601String()),
      location: json['local'] ?? '', // Seu campo
      contactId: json['pessoa_id'] ?? '', // Seu campo
      description: json['observacoes'] ?? '', // Seu campo
      message: json['mensagem_especial'],
      isDirty: false,
      isDeleted: false,
      syncStatus: 'synced',
    );
  }
}
