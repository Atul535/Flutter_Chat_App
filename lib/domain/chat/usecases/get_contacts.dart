import 'package:chat_app/domain/chat/entities/contact_entity.dart';
import 'package:chat_app/domain/chat/repositories/contact_repository.dart';

class GetContacts {
  final ContactRepository repository;

  GetContacts(this.repository);

  Future<List<ContactEntity>> call() => repository.getContacts();
}
