// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  final String name;
  final String mobile;
  final String email;
  User({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
  });

  factory User.emptyFactory() => User(
        id: '',
        name: '',
        email: '',
        mobile: '',
      );
}
