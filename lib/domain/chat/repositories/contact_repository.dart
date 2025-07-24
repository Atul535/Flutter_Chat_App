import 'package:chat_app/domain/chat/entities/contact_entity.dart';

abstract class ContactRepository {
  Future<List<ContactEntity>> getContacts();
  Future<void> addContact(ContactEntity contact);
}
