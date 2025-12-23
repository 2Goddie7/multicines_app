import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String role;
  final String? name;
  final DateTime created;
  final DateTime updated;

  const UserEntity({
    required this.id,
    required this.email,
    required this.role,
    this.name,
    required this.created,
    required this.updated,
  });

  @override
  List<Object?> get props => [id, email, role, name, created, updated];
}