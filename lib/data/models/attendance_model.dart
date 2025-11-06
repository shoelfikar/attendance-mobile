class AttendanceModel {
  final int id;
  final int userId;
  final int locationId;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final double checkInLatitude;
  final double checkInLongitude;
  final double? checkOutLatitude;
  final double? checkOutLongitude;
  final double? distanceFromLocation;
  final String status;
  final String? notes;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional fields for display (from joined data)
  final String? locationName;
  final String? userName;

  AttendanceModel({
    required this.id,
    required this.userId,
    required this.locationId,
    required this.checkInTime,
    this.checkOutTime,
    required this.checkInLatitude,
    required this.checkInLongitude,
    this.checkOutLatitude,
    this.checkOutLongitude,
    this.distanceFromLocation,
    required this.status,
    this.notes,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.locationName,
    this.userName,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      locationId: json['location_id'] as int,
      checkInTime: DateTime.parse(json['check_in_time'] as String),
      checkOutTime: json['check_out_time'] != null
          ? DateTime.parse(json['check_out_time'] as String)
          : null,
      checkInLatitude: (json['check_in_latitude'] as num).toDouble(),
      checkInLongitude: (json['check_in_longitude'] as num).toDouble(),
      checkOutLatitude: json['check_out_latitude'] != null
          ? (json['check_out_latitude'] as num).toDouble()
          : null,
      checkOutLongitude: json['check_out_longitude'] != null
          ? (json['check_out_longitude'] as num).toDouble()
          : null,
      distanceFromLocation: json['distance_from_location'] != null
          ? (json['distance_from_location'] as num).toDouble()
          : null,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      photoUrl: json['photo_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      locationName: json['location_name'] as String?,
      userName: json['user_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'location_id': locationId,
      'check_in_time': checkInTime.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
      'check_in_latitude': checkInLatitude,
      'check_in_longitude': checkInLongitude,
      'check_out_latitude': checkOutLatitude,
      'check_out_longitude': checkOutLongitude,
      'distance_from_location': distanceFromLocation,
      'status': status,
      'notes': notes,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (locationName != null) 'location_name': locationName,
      if (userName != null) 'user_name': userName,
    };
  }

  AttendanceModel copyWith({
    int? id,
    int? userId,
    int? locationId,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    double? checkInLatitude,
    double? checkInLongitude,
    double? checkOutLatitude,
    double? checkOutLongitude,
    double? distanceFromLocation,
    String? status,
    String? notes,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? locationName,
    String? userName,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      locationId: locationId ?? this.locationId,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      checkInLatitude: checkInLatitude ?? this.checkInLatitude,
      checkInLongitude: checkInLongitude ?? this.checkInLongitude,
      checkOutLatitude: checkOutLatitude ?? this.checkOutLatitude,
      checkOutLongitude: checkOutLongitude ?? this.checkOutLongitude,
      distanceFromLocation: distanceFromLocation ?? this.distanceFromLocation,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      locationName: locationName ?? this.locationName,
      userName: userName ?? this.userName,
    );
  }

  // Helper to calculate work duration
  Duration? getWorkDuration() {
    if (checkOutTime != null) {
      return checkOutTime!.difference(checkInTime);
    }
    return null;
  }

  // Format work duration as HH:MM
  String getFormattedDuration() {
    final duration = getWorkDuration();
    if (duration == null) return '-';

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
