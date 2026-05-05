import 'package:uuid/uuid.dart';

class Event {
  final String id;
  final String uuid;
  final String title;
  final DateTime date;
  final String location;
  final String contactId;
  final String description;
  final String? message;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isDeleted;
  final String syncStatus; // pending, synced, error

  Event({
    required this.id,
    required this.uuid,
    required this.title,
    required this.date,
    required this.location,
    required this.contactId,
    required this.description,
    this.message,
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
      'title': title,
      'date': date.toIso8601String(),
      'location': location,
      'contactId': contactId,
      'description': description,
      'message': message,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted ? 1 : 0,
      'syncStatus': syncStatus,
    };
  }

  // Converter do Map para Event
  factory Event.fromMap(Map<String, dynamic> map) {
    final uuidValue =
        map['uuid']?.toString() ?? map['id']?.toString() ?? const Uuid().v4();

    return Event(
      id: map['id'] as String,
      uuid: uuidValue,
      title: map['title'] as String,
      date: DateTime.parse(map['date'] as String),
      location: map['location'] as String,
      contactId: map['contactId'] as String,
      description: map['description'] as String,
      message: map['message'] as String?,
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
      'title': title,
      'date': date.toIso8601String(),
      'location': location,
      'contactId': contactId,
      'description': description,
      'message': message,
    };
  }

  factory Event.fromApiJson(Map<String, dynamic> json) {
    final uuidValue =
        json['uuid']?.toString() ?? json['id']?.toString() ?? const Uuid().v4();

    return Event(
      id: uuidValue,
      uuid: uuidValue,
      title: json['title'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String? ?? '',
      contactId: json['contactId']?.toString() ?? '',
      description: json['description'] as String? ?? '',
      message: json['message'] as String?,
      syncStatus: 'synced',
    );
  }

  // Copiar com alterações
  Event copyWith({
    String? id,
    String? uuid,
    String? title,
    DateTime? date,
    String? location,
    String? contactId,
    String? description,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    String? syncStatus,
  }) {
    return Event(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      date: date ?? this.date,
      location: location ?? this.location,
      contactId: contactId ?? this.contactId,
      description: description ?? this.description,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
