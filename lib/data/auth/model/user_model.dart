import 'package:chat_app/domain/auth/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.mobile,
    required super.email,
    super.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      mobile: map['mobile'] ?? '',
      email: map['email'] ?? '',
      password: map['password'],
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? mobile,
    String? email,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
