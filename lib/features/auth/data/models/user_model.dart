import 'package:pocketbase/pocketbase.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.role,
    super.name,
    required super.created,
    required super.updated,
  });

  factory UserModel.fromRecord(RecordModel record) {
    return UserModel(
      id: record.id,
      email: record.data['email'] as String,
      role: record.data['role'] as String? ?? 'invitado',
      name: record.data['name'] as String?,
      created: DateTime.parse(record.created),
      updated: DateTime.parse(record.updated),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role,
      'name': name,
    };
  }
}