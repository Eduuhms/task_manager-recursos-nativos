import 'dart:convert';

class Task {
  final int? id;
  final String title;
  final String description;
  final String priority;
  final bool completed;
  final DateTime createdAt;

  // CÂMERA: agora suporta múltiplas fotos
  final List<String>? photoPaths;

  // SENSORES
  final DateTime? completedAt;
  final String? completedBy; // 'manual', 'shake'

  // GPS
  final double? latitude;
  final double? longitude;
  final String? locationName;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.completed = false,
    DateTime? createdAt,
    this.photoPaths,
    this.completedAt,
    this.completedBy,
    this.latitude,
    this.longitude,
    this.locationName,
  }) : createdAt = createdAt ?? DateTime.now();

  // Getters auxiliares
  bool get hasPhotos => photoPaths != null && photoPaths!.isNotEmpty;
  String? get firstPhoto => hasPhotos ? photoPaths!.first : null;
  bool get hasLocation => latitude != null && longitude != null;
  bool get wasCompletedByShake => completedBy == 'shake';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'completed': completed ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'photoPaths': photoPaths != null ? jsonEncode(photoPaths) : null,
      'completedAt': completedAt?.toIso8601String(),
      'completedBy': completedBy,
      'latitude': latitude,
      'longitude': longitude,
      'locationName': locationName,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    // photoPaths may be stored as JSON string (new) or single photoPath (legacy)
    List<String>? photos;
    if (map['photoPaths'] != null) {
      try {
        final decoded = jsonDecode(map['photoPaths'] as String);
        if (decoded is List) photos = decoded.map((e) => e.toString()).toList();
      } catch (_) {
        photos = null;
      }
    } else if (map['photoPath'] != null) {
      final p = map['photoPath'] as String?;
      if (p != null && p.isNotEmpty) photos = [p];
    }

    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      priority: map['priority'] as String,
      completed: (map['completed'] as int) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
      photoPaths: photos,
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'] as String)
          : null,
      completedBy: map['completedBy'] as String?,
      latitude: map['latitude'] is double ? map['latitude'] as double : (map['latitude'] is num ? (map['latitude'] as num).toDouble() : null),
      longitude: map['longitude'] is double ? map['longitude'] as double : (map['longitude'] is num ? (map['longitude'] as num).toDouble() : null),
      locationName: map['locationName'] as String?,
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? priority,
    bool? completed,
    DateTime? createdAt,
    List<String>? photoPaths,
    DateTime? completedAt,
    String? completedBy,
    double? latitude,
    double? longitude,
    String? locationName,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      photoPaths: photoPaths ?? this.photoPaths,
      completedAt: completedAt ?? this.completedAt,
      completedBy: completedBy ?? this.completedBy,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
    );
  }
}