import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class UserModel {
  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    this.skills,
    this.hourlyRate,
    this.photoUrl,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      skills: json['skills'] != null
          ? (json['skills'] as List).cast<String>()
          : null,
      hourlyRate: json['hourlyRate'] != null
          ? (json['hourlyRate'] as num).toDouble()
          : null,
      photoUrl: json['photoUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  String? id;

  String name;

  String email;

  String role;

  List<String>? skills;

  double? hourlyRate;

  String? photoUrl;

  DateTime? createdAt;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'role': role,
    };
    if (id != null) {
      data['id'] = id;
    }
    if (skills != null) {
      data['skills'] = skills;
    }
    if (hourlyRate != null) {
      data['hourlyRate'] = hourlyRate;
    }
    if (photoUrl != null) {
      data['photoUrl'] = photoUrl;
    }
    if (createdAt != null) {
      data['createdAt'] = createdAt?.toIso8601String();
    }
    return data;
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    List<String>? skills,
    double? hourlyRate,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      skills: skills ??
          (this.skills != null ? List<String>.from(this.skills!) : null),
      hourlyRate: hourlyRate ?? this.hourlyRate,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  UserModel clone() {
    return copyWith();
  }
}
