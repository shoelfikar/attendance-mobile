class UserModel {
  final int id;
  final String email;
  final String fullName;
  final String? phone;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional employee information
  final String? company;
  final String? position;
  final String? department;
  final String? employeeStatus;
  final String? grade;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.company,
    this.position,
    this.department,
    this.employeeStatus,
    this.grade,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      fullName: json['full_name'] as String? ?? json['fullName'] as String? ?? '',
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'user',
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : (json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now()),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : (json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : DateTime.now()),
      company: json['company'] as String?,
      position: json['position'] as String?,
      department: json['department'] as String?,
      employeeStatus: json['employee_status'] as String? ?? json['employeeStatus'] as String?,
      grade: json['grade'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'role': role,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'company': company,
      'position': position,
      'department': department,
      'employee_status': employeeStatus,
      'grade': grade,
    };
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? fullName,
    String? phone,
    String? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? company,
    String? position,
    String? department,
    String? employeeStatus,
    String? grade,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      company: company ?? this.company,
      position: position ?? this.position,
      department: department ?? this.department,
      employeeStatus: employeeStatus ?? this.employeeStatus,
      grade: grade ?? this.grade,
    );
  }
}
