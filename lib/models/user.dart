import 'package:uuid/uuid.dart';

class User {
  final String id;
  final int? remoteId;
  final String name;
  final String email;
  final String? identityUserId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isDirty;
  final bool isDeleted;
  final String syncStatus; // pending, synced, error

  User({
    required this.id,
    this.remoteId,
    required this.name,
    required this.email,
    this.identityUserId,
    this.createdAt,
    this.updatedAt,
    this.isDirty = false,
    this.isDeleted = false,
    this.syncStatus = 'synced',
  });

  // Converter para Map para salvar no SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'remoteId': remoteId,
      'name': name,
      'email': email,
      'identityUserId': identityUserId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDirty': isDirty ? 1 : 0,
      'isDeleted': isDeleted ? 1 : 0,
      'syncStatus': syncStatus,
    };
  }

  // Converter do Map para User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      remoteId: map['remoteId'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      identityUserId: map['identityUserId'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      isDirty: (map['isDirty'] as int) == 1,
      isDeleted: (map['isDeleted'] as int) == 1,
      syncStatus: map['syncStatus'] as String? ?? 'synced',
    );
  }

  // Converter para JSON para enviar à API
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }

  factory User.fromApiJson(Map<String, dynamic> json) {
    final remoteIdValue = json['id'];

    return User(
      id: remoteIdValue?.toString() ?? const Uuid().v4(),
      remoteId: remoteIdValue is int ? remoteIdValue : int.tryParse(remoteIdValue?.toString() ?? ''),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      syncStatus: 'synced',
    );
  }

  // Copiar com alterações (útil para atualizar campos)
  User copyWith({
    String? id,
    int? remoteId,
    String? name,
    String? email,
    String? identityUserId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDirty,
    bool? isDeleted,
    String? syncStatus,
  }) {
    return User(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      name: name ?? this.name,
      email: email ?? this.email,
      identityUserId: identityUserId ?? this.identityUserId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDirty: isDirty ?? this.isDirty,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
