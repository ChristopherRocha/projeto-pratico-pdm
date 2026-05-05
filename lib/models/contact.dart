import 'package:uuid/uuid.dart';

class Contact {
  final String id;
  final String uuid;
  final String name;
  final String email;
  final String phoneNumber;
  final String userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isDeleted;
  final String syncStatus; // pending, synced, error

  Contact({
    required this.id,
    required this.uuid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.userId,
    this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
    this.syncStatus = 'synced',
  });

  // Converter para Map para salvar no SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'userId': userId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted ? 1 : 0,
      'syncStatus': syncStatus,
    };
  }

  // Converter do Map para Contact
  factory Contact.fromMap(Map<String, dynamic> map) {
    final uuidValue =
        map['uuid']?.toString() ?? map['id']?.toString() ?? const Uuid().v4();

    return Contact(
      id: map['id'] as String,
      uuid: uuidValue,
      name: map['name'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      userId: map['userId'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      isDeleted: (map['isDeleted'] as int) == 1,
      syncStatus: map['syncStatus'] as String? ?? 'synced',
    );
  }

  // Converter para JSON para enviar à API 
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'userId': userId,
    };
  }

  factory Contact.fromApiJson(Map<String, dynamic> json) {
    final uuidValue =
        json['uuid']?.toString() ?? json['id']?.toString() ?? const Uuid().v4();

    return Contact(
      id: uuidValue,
      uuid: uuidValue,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      userId: json['userId']?.toString() ?? '',
      syncStatus: 'synced',
    );
  }

  // Copiar com alterações
  Contact copyWith({
    String? id,
    String? uuid,
    String? name,
    String? email,
    String? phoneNumber,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    String? syncStatus,
  }) {
    return Contact(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
