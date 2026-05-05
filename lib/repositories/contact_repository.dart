import 'package:uuid/uuid.dart';
import '../database/database_helper.dart';
import '../models/index.dart';

class ContactRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Criar um novo contato
  Future<Contact> createContact({
    required String name,
    required String email,
    required String phoneNumber,
    required String userId,
  }) async {
    final uuid = const Uuid().v4();
    final contact = Contact(
      id: uuid,
      uuid: uuid,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      userId: userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      syncStatus: 'pending',
    );

    await _databaseHelper.insertContact(contact);
    return contact;
  }

  /// Obter um contato pelo ID
  Future<Contact?> getContact(String id) async {
    return _databaseHelper.getContact(id);
  }

  /// Obter todos os contatos
  Future<List<Contact>> getAllContacts() async {
    return _databaseHelper.getAllContacts();
  }

  /// Obter contatos de um usuário específico
  Future<List<Contact>> getContactsByUser(String userId) async {
    return _databaseHelper.getContactsByUser(userId);
  }

  /// Atualizar um contato
  Future<void> updateContact(Contact contact) async {
    final updatedContact = contact.copyWith(
      updatedAt: DateTime.now(),
      syncStatus: 'pending',
    );
    await _databaseHelper.updateContact(updatedContact);
  }

  /// Deletar um contato (soft delete para offline-first)
  Future<void> deleteContact(String id) async {
    final contact = await _databaseHelper.getContact(id);
    if (contact != null) {
      final deletedContact = contact.copyWith(
        isDeleted: true,
        updatedAt: DateTime.now(),
        syncStatus: 'pending',
      );
      await _databaseHelper.updateContact(deletedContact);
    }
  }

  /// Obter contatos pendentes de sincronização
  Future<List<Contact>> getPendingContacts() async {
    return _databaseHelper.getPendingContacts();
  }

  /// Marcar um contato como sincronizado
  Future<void> markContactSynced(String contactId) async {
    await _databaseHelper.markContactSynced(contactId);
  }
}
