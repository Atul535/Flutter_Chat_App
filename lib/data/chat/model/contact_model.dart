import 'package:chat_app/domain/chat/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  ContactModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  factory ContactModel.fromEntity(ContactEntity entity) {
    return ContactModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
    );
  }
}
