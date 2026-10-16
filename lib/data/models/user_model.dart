import 'dart:convert';

import '../../domain/entities/user.dart';
import '../../domain/entities/user_role.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.nik,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? json['user_id'] ?? '').toString(),
      name: (json['name'] ?? json['full_name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      nik: (json['nik'] ?? '').toString(),
      role: UserRole.fromString(json['role']?.toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'nik': nik,
      'role': role.name,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory UserModel.fromJsonString(String jsonString) {
    return UserModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      nik: user.nik,
      role: user.role,
    );
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      nik: nik,
      role: role,
    );
  }
}
