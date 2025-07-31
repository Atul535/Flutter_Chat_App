import 'package:chat_app/data/chat/datasource/contact_remote_data_source_impl.dart';
import 'package:chat_app/data/chat/model/contact_model.dart';
import 'package:chat_app/domain/chat/entities/contact_entity.dart';
import 'package:chat_app/domain/chat/repositories/contact_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource remoteDataSource;

  ContactRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ContactEntity>> getContacts() async {
    return await remoteDataSource.getContacts();
  }

  @override
  Future<void> addContact(ContactEntity contact) async {
     final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) throw Exception("User not authenticated");
    final model = ContactModel.fromEntity(contact);
    await remoteDataSource.addContact(model);
  }
}
