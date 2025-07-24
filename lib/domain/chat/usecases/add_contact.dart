import 'package:chat_app/domain/chat/entities/contact_entity.dart';
import 'package:chat_app/domain/chat/repositories/contact_repository.dart';

class AddContact {
  final ContactRepository repository;

  AddContact(this.repository);

  Future<void> call(ContactEntity contact) => repository.addContact(contact);
}
