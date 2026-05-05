import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/contact.dart';
import '../models/event.dart';

class DatabaseHelper {
  static const String _databaseName = 'trabalho_pratico.db';

  // Nomes das tabelas
  static const String usersTable = 'users';
  static const String contactsTable = 'contacts';
  static const String eventsTable = 'events';

  // Singleton
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela de Usuários
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $usersTable (
        id TEXT PRIMARY KEY,
        uuid TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        identityUserId TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        isDeleted INTEGER DEFAULT 0,
        syncStatus TEXT DEFAULT 'synced'
      )
    ''');

    // Tabela de Contatos
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $contactsTable (
        id TEXT PRIMARY KEY,
        uuid TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phoneNumber TEXT NOT NULL,
        userId TEXT NOT NULL,
        createdAt TEXT,
        updatedAt TEXT,
        isDeleted INTEGER DEFAULT 0,
        syncStatus TEXT DEFAULT 'synced',
        FOREIGN KEY (userId) REFERENCES $usersTable (id)
      )
    ''');

    // Tabela de Eventos
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $eventsTable (
        id TEXT PRIMARY KEY,
        uuid TEXT NOT NULL UNIQUE,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        location TEXT NOT NULL,
        contactId TEXT NOT NULL,
        description TEXT NOT NULL,
        message TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        isDeleted INTEGER DEFAULT 0,
        syncStatus TEXT DEFAULT 'synced',
        FOREIGN KEY (contactId) REFERENCES $contactsTable (id)
      )
    ''');

    print('Banco de dados criado com sucesso');
  }

  // ============ USUÁRIOS ============

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      usersTable,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUser(String id) async {
    final db = await database;
    final maps = await db.query(usersTable, where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final maps = await db.query(usersTable);
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      usersTable,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(String id) async {
    final db = await database;
    await db.delete(usersTable, where: 'id = ?', whereArgs: [id]);
  }

  // ============ CONTATOS ============

  Future<void> insertContact(Contact contact) async {
    final db = await database;
    await db.insert(
      contactsTable,
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Contact?> getContact(String id) async {
    final db = await database;
    final maps = await db.query(
      contactsTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Contact.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Contact>> getAllContacts() async {
    final db = await database;
    final maps = await db.query(contactsTable);
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }

  Future<List<Contact>> getContactsByUser(String userId) async {
    final db = await database;
    final maps = await db.query(
      contactsTable,
      where: 'userId = ? AND isDeleted = 0',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }

  Future<void> updateContact(Contact contact) async {
    final db = await database;
    await db.update(
      contactsTable,
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<void> deleteContact(String id) async {
    final db = await database;
    await db.delete(contactsTable, where: 'id = ?', whereArgs: [id]);
  }

  // ============ EVENTOS ============

  Future<void> insertEvent(Event event) async {
    final db = await database;
    await db.insert(
      eventsTable,
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Event?> getEvent(String id) async {
    final db = await database;
    final maps = await db.query(eventsTable, where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Event.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Event>> getAllEvents() async {
    final db = await database;
    final maps = await db.query(eventsTable);
    return List.generate(maps.length, (i) => Event.fromMap(maps[i]));
  }

  Future<List<Event>> getEventsByContact(String contactId) async {
    final db = await database;
    final maps = await db.query(
      eventsTable,
      where: 'contactId = ? AND isDeleted = 0',
      whereArgs: [contactId],
    );
    return List.generate(maps.length, (i) => Event.fromMap(maps[i]));
  }

  Future<void> updateEvent(Event event) async {
    final db = await database;
    await db.update(
      eventsTable,
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<void> deleteEvent(String id) async {
    final db = await database;
    await db.delete(eventsTable, where: 'id = ?', whereArgs: [id]);
  }

  // ============ SINCRONIZAÇÃO ============

  /// Retorna todos os usuários pendentes de sincronização
  Future<List<User>> getPendingUsers() async {
    final db = await database;
    final maps = await db.query(
      usersTable,
      where: 'syncStatus = ?',
      whereArgs: ['pending'],
    );
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  /// Retorna todos os contatos pendentes de sincronização
  Future<List<Contact>> getPendingContacts() async {
    final db = await database;
    final maps = await db.query(
      contactsTable,
      where: 'syncStatus = ?',
      whereArgs: ['pending'],
    );
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }

  /// Retorna todos os eventos pendentes de sincronização
  Future<List<Event>> getPendingEvents() async {
    final db = await database;
    final maps = await db.query(
      eventsTable,
      where: 'syncStatus = ?',
      whereArgs: ['pending'],
    );
    return List.generate(maps.length, (i) => Event.fromMap(maps[i]));
  }

  /// Marca um usuário como sincronizado
  Future<void> markUserSynced(String userId) async {
    final db = await database;
    await db.update(
      usersTable,
      {'syncStatus': 'synced'},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  /// Marca um contato como sincronizado
  Future<void> markContactSynced(String contactId) async {
    final db = await database;
    await db.update(
      contactsTable,
      {'syncStatus': 'synced'},
      where: 'id = ?',
      whereArgs: [contactId],
    );
  }

  /// Marca um evento como sincronizado
  Future<void> markEventSynced(String eventId) async {
    final db = await database;
    await db.update(
      eventsTable,
      {'syncStatus': 'synced'},
      where: 'id = ?',
      whereArgs: [eventId],
    );
  }

  /// Fechar o banco de dados
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
