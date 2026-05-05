import 'package:dio/dio.dart';

import '../models/index.dart';
import 'api_config.dart';

class ApiService {
  late final Dio _dio;
  String? _bearerToken;

  ApiService() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.apiBaseUrl,
        connectTimeout: Duration(milliseconds: ApiConfig.connectionTimeout),
        receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeout),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  void setAuthToken(String? token) {
    _bearerToken = token;
    if (token == null || token.isEmpty) {
      _dio.options.headers.remove('Authorization');
      return;
    }

    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Options _requestOptions() {
    if (_bearerToken == null || _bearerToken!.isEmpty) {
      return Options();
    }

    return Options(headers: {'Authorization': 'Bearer $_bearerToken'});
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    return null;
  }

  List<dynamic> _asList(dynamic value) {
    if (value is List) {
      return value;
    }
    final map = _asMap(value);
    if (map != null && map['data'] is List) {
      return map['data'] as List;
    }
    return const [];
  }

  // ============ AUTH ============

  Future<Response<dynamic>> register(Map<String, dynamic> payload) {
    return _dio.post(
      '${ApiConfig.authEndpoint}/register',
      data: payload,
      options: _requestOptions(),
    );
  }

  Future<Response<dynamic>> login(Map<String, dynamic> payload) async {
    final response = await _dio.post(
      '${ApiConfig.authEndpoint}/login',
      data: payload,
      options: _requestOptions(),
    );
    final data = _asMap(response.data);
    final token =
        data?['token']?.toString() ?? data?['accessToken']?.toString();
    if (token != null && token.isNotEmpty) {
      setAuthToken(token);
    }
    return response;
  }

  Future<Response<dynamic>> changePassword(Map<String, dynamic> payload) {
    return _dio.post(
      '${ApiConfig.authEndpoint}/change-password',
      data: payload,
      options: _requestOptions(),
    );
  }

  Future<Response<dynamic>> resetPassword(Map<String, dynamic> payload) {
    return _dio.post(
      '${ApiConfig.authEndpoint}/reset-password',
      data: payload,
      options: _requestOptions(),
    );
  }

  Future<Response<dynamic>> forgotPassword(String email) {
    return _dio.post(
      '${ApiConfig.authEndpoint}/forgot-password',
      data: email,
      options: _requestOptions(),
    );
  }

  Future<Response<dynamic>> deleteUserByAuth(String email) {
    return _dio.delete(
      '${ApiConfig.authEndpoint}/delete-user',
      data: email,
      options: _requestOptions(),
    );
  }

  // ============ CONTATOS ============

  Future<List<Contact>> fetchContacts() async {
    final response = await _dio.get(
      ApiConfig.contactsEndpoint,
      options: _requestOptions(),
    );
    return _asList(response.data)
        .whereType<Map>()
        .map((item) => Contact.fromApiJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<Contact> createContact(Contact contact) async {
    await _dio.put(
      '${ApiConfig.contactsEndpoint}/${contact.uuid}',
      data: contact.toJson(),
      options: _requestOptions(),
    );
    return contact.copyWith(syncStatus: 'synced');
  }

  Future<Contact> updateContact(Contact contact) async {
    await _dio.put(
      '${ApiConfig.contactsEndpoint}/${contact.uuid}',
      data: contact.toJson(),
      options: _requestOptions(),
    );
    return contact.copyWith(syncStatus: 'synced');
  }

  Future<void> deleteContact(Contact contact) async {
    await _dio.delete(
      '${ApiConfig.contactsEndpoint}/${contact.uuid}',
      options: _requestOptions(),
    );
  }

  // ============ EVENTOS ============

  Future<List<Event>> fetchEvents() async {
    final response = await _dio.get(
      ApiConfig.eventsEndpoint,
      options: _requestOptions(),
    );
    return _asList(response.data)
        .whereType<Map>()
        .map((item) => Event.fromApiJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<Event> createEvent(Event event) async {
    await _dio.put(
      '${ApiConfig.eventsEndpoint}/${event.uuid}',
      data: event.toJson(),
      options: _requestOptions(),
    );
    return event.copyWith(syncStatus: 'synced');
  }

  Future<Event> updateEvent(Event event) async {
    await _dio.put(
      '${ApiConfig.eventsEndpoint}/${event.uuid}',
      data: event.toJson(),
      options: _requestOptions(),
    );
    return event.copyWith(syncStatus: 'synced');
  }

  Future<void> deleteEvent(Event event) async {
    await _dio.delete(
      '${ApiConfig.eventsEndpoint}/${event.uuid}',
      options: _requestOptions(),
    );
  }

  // ============ USUÁRIOS ============

  Future<List<User>> fetchUsers() async {
    final response = await _dio.get(
      ApiConfig.usersEndpoint,
      options: _requestOptions(),
    );
    return _asList(response.data)
        .whereType<Map>()
        .map((item) => User.fromApiJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<User> createUser(User user) async {
    await _dio.put(
      '${ApiConfig.usersEndpoint}/${user.uuid}',
      data: user.toJson(),
      options: _requestOptions(),
    );
    return user.copyWith(syncStatus: 'synced');
  }

  Future<User> updateUser(User user) async {
    await _dio.put(
      '${ApiConfig.usersEndpoint}/${user.uuid}',
      data: user.toJson(),
      options: _requestOptions(),
    );
    return user.copyWith(syncStatus: 'synced');
  }

  Future<void> deleteUser(User user) async {
    await _dio.delete(
      '${ApiConfig.usersEndpoint}/${user.uuid}',
      options: _requestOptions(),
    );
  }

  void close() {
    _dio.close();
  }
}
