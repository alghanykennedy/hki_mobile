import 'package:equatable/equatable.dart';

import 'user_role.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String nik;
  final UserRole role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.nik,
    required this.role,
  });

  @override
  List<Object?> get props => [id, name, email, nik, role];
}
