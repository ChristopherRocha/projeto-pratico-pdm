import 'package:uuid/uuid.dart';
import '../database/database_helper.dart';
import '../models/index.dart';

class UserRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Criar um novo usuário
  Future<User> createUser({
    required String name,
    required String email,
    String? identityUserId,
  }) async {
    final uuid = const Uuid().v4();
    final user = User(
      id: uuid,
      uuid: uuid,
      name: name,
      email: email,
      identityUserId: identityUserId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      syncStatus: 'pending',
    );

    await _databaseHelper.insertUser(user);
    return user;
  }

  /// Obter um usuário pelo ID
  Future<User?> getUser(String id) async {
    return _databaseHelper.getUser(id);
  }

  /// Obter todos os usuários
  Future<List<User>> getAllUsers() async {
    return _databaseHelper.getAllUsers();
  }

  /// Atualizar um usuário
  Future<void> updateUser(User user) async {
    final updatedUser = user.copyWith(
      updatedAt: DateTime.now(),
      syncStatus: 'pending',
    );
    await _databaseHelper.updateUser(updatedUser);
  }

  /// Deletar um usuário (soft delete para offline-first)
  Future<void> deleteUser(String id) async {
    final user = await _databaseHelper.getUser(id);
    if (user != null) {
      final deletedUser = user.copyWith(
        isDeleted: true,
        updatedAt: DateTime.now(),
        syncStatus: 'pending',
      );
      await _databaseHelper.updateUser(deletedUser);
    }
  }

  /// Obter usuários pendentes de sincronização
  Future<List<User>> getPendingUsers() async {
    return _databaseHelper.getPendingUsers();
  }

  /// Marcar um usuário como sincronizado
  Future<void> markUserSynced(String userId) async {
    await _databaseHelper.markUserSynced(userId);
  }
}
