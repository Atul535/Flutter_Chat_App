import 'package:chat_app/data/chat/model/contact_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ContactRemoteDataSource {
  Future<List<ContactModel>> getContacts();
  Future<void> addContact(ContactModel contact);
}

class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final SupabaseClient client;

  ContactRemoteDataSourceImpl(this.client);

  @override
  Future<List<ContactModel>> getContacts() async {
    final response = await client.from('contact').select();
    return (response as List).map((e) => ContactModel.fromJson(e)).toList();
  }

  @override
  Future<void> addContact(ContactModel contact) async {
    await client.from('contact').insert(contact.toJson());
  }
}
