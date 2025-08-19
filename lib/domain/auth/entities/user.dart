// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? password;
  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.password,
  });
}
