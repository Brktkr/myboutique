import 'base_model.dart';

class User extends BaseModel {
  final String username;
  final String password;
  final String name;
  final String surname;

  User({
    required super.id,
    required this.username,
    required this.password,
    required this.name,
    required this.surname,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
    super.isActive,
    super.isDeleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'surname': surname,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
      'isDeleted': isDeleted,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      name: map['name'],
      surname: map['surname'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      isActive: map['isActive'] ?? true,
      isDeleted: map['isDeleted'] ?? false,
    );
  }
}
