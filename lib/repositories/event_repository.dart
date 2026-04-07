import 'package:uuid/uuid.dart';
import '../database/database_helper.dart';
import '../models/index.dart';

class EventRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Criar um novo evento
  Future<Event> createEvent({
    required String title,
    required DateTime date,
    required String location,
    required String contactId,
    required String description,
    String? message,
  }) async {
    final event = Event(
      id: const Uuid().v4(),
      title: title,
      date: date,
      location: location,
      contactId: contactId,
      description: description,
      message: message,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDirty: true,
      syncStatus: 'pending',
    );

    await _databaseHelper.insertEvent(event);
    return event;
  }

  /// Obter um evento pelo ID
  Future<Event?> getEvent(String id) async {
    return _databaseHelper.getEvent(id);
  }

  /// Obter todos os eventos
  Future<List<Event>> getAllEvents() async {
    return _databaseHelper.getAllEvents();
  }

  /// Obter eventos de um contato específico
  Future<List<Event>> getEventsByContact(String contactId) async {
    return _databaseHelper.getEventsByContact(contactId);
  }

  /// Atualizar um evento
  Future<void> updateEvent(Event event) async {
    final updatedEvent = event.copyWith(
      updatedAt: DateTime.now(),
      isDirty: true,
      syncStatus: 'pending',
    );
    await _databaseHelper.updateEvent(updatedEvent);
  }

  /// Deletar um evento (soft delete para offline-first)
  Future<void> deleteEvent(String id) async {
    final event = await _databaseHelper.getEvent(id);
    if (event != null) {
      final deletedEvent = event.copyWith(
        isDeleted: true,
        updatedAt: DateTime.now(),
        isDirty: true,
        syncStatus: 'pending',
      );
      await _databaseHelper.updateEvent(deletedEvent);
    }
  }

  /// Obter eventos pendentes de sincronização
  Future<List<Event>> getPendingEvents() async {
    return _databaseHelper.getPendingEvents();
  }

  /// Marcar um evento como sincronizado
  Future<void> markEventSynced(String eventId) async {
    await _databaseHelper.markEventSynced(eventId);
  }

  Future<void> saveEventRemoteData(
    String eventId,
    int remoteId, {
    int? contactRemoteId,
  }) async {
    await _databaseHelper.saveEventRemoteData(
      eventId,
      remoteId,
      contactRemoteId: contactRemoteId,
    );
  }
}
