class AttendanceLocationModel {
  final int id;
  final String name;
  final String? description;
  final double latitude;
  final double longitude;
  final int radius;
  final bool isActive;
  final int? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  AttendanceLocationModel({
    required this.id,
    required this.name,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.isActive,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendanceLocationModel.fromJson(Map<String, dynamic> json) {
    return AttendanceLocationModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radius: json['radius'] as int,
      isActive: json['is_active'] as bool,
      createdBy: json['created_by'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'is_active': isActive,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AttendanceLocationModel copyWith({
    int? id,
    String? name,
    String? description,
    double? latitude,
    double? longitude,
    int? radius,
    bool? isActive,
    int? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AttendanceLocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      isActive: isActive ?? this.isActive,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
