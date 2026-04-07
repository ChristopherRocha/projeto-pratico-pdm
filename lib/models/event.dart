import 'package:uuid/uuid.dart';

class Event {
  final String id;
  final int? remoteId;
  final String title;
  final DateTime date;
  final String location;
  final String contactId;
  final int? contactRemoteId;
  final String description;
  final String? message;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isDirty;
  final bool isDeleted;
  final String syncStatus; // pending, synced, error

  Event({
    required this.id,
    this.remoteId,
    required this.title,
    required this.date,
    required this.location,
    required this.contactId,
    this.contactRemoteId,
    required this.description,
    this.message,
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
      'title': title,
      'date': date.toIso8601String(),
      'location': location,
      'contactId': contactId,
      'contactRemoteId': contactRemoteId,
      'description': description,
      'message': message,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDirty': isDirty ? 1 : 0,
      'isDeleted': isDeleted ? 1 : 0,
      'syncStatus': syncStatus,
    };
  }

  // Converter do Map para Event
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      remoteId: map['remoteId'] as int?,
      title: map['title'] as String,
      date: DateTime.parse(map['date'] as String),
      location: map['location'] as String,
      contactId: map['contactId'] as String,
      contactRemoteId: map['contactRemoteId'] as int?,
      description: map['description'] as String,
      message: map['message'] as String?,
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
      'title': title,
      'date': date.toIso8601String(),
      'location': location,
      'contactId': contactRemoteId,
      'description': description,
      'message': message,
    };
  }

  factory Event.fromApiJson(Map<String, dynamic> json) {
    final remoteIdValue = json['id'];

    return Event(
      id: remoteIdValue?.toString() ?? const Uuid().v4(),
      remoteId: remoteIdValue is int ? remoteIdValue : int.tryParse(remoteIdValue?.toString() ?? ''),
      title: json['title'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String? ?? '',
      contactId: json['contactId']?.toString() ?? '',
      contactRemoteId: json['contactId'] is int ? json['contactId'] as int : int.tryParse(json['contactId']?.toString() ?? ''),
      description: json['description'] as String? ?? '',
      message: json['message'] as String?,
      syncStatus: 'synced',
    );
  }

  // Copiar com alterações
  Event copyWith({
    String? id,
    int? remoteId,
    String? title,
    DateTime? date,
    String? location,
    String? contactId,
    int? contactRemoteId,
    String? description,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDirty,
    bool? isDeleted,
    String? syncStatus,
  }) {
    return Event(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      title: title ?? this.title,
      date: date ?? this.date,
      location: location ?? this.location,
      contactId: contactId ?? this.contactId,
      contactRemoteId: contactRemoteId ?? this.contactRemoteId,
      description: description ?? this.description,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDirty: isDirty ?? this.isDirty,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
