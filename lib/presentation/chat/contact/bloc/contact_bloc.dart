import 'package:chat_app/core/utils/exception.dart';
import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/domain/chat/entities/contact_entity.dart';
import 'package:chat_app/domain/chat/usecases/add_contact.dart';
import 'package:chat_app/domain/chat/usecases/get_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final GetContacts getContacts;
  final AddContact addContact;
  ContactBloc(this.getContacts, this.addContact) : super(ContactInitial()) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<AddContactEvent>(_onAddContact);
  }

  Future<void> _onLoadContacts(
      LoadContactsEvent event, Emitter<ContactState> emit) async {
    emit(ContactLoading());
    try {
      final contacts = await getContacts();
      emit(ContactLoaded(contacts));
    } on ServerException catch (e) {
      emit(ContactError(e.message));
    }
  }

  Future<void> _onAddContact(
      AddContactEvent event, Emitter<ContactState> emit) async {
    emit(ContactLoading());
    try {
      final newContact = ContactEntity(
        id: const Uuid().v4(),
        name: event.name,
        email: event.email,
        userId: event.userId,
      );

      await addContact(newContact);
      final contacts = await getContacts();
      emit(ContactLoaded(contacts));
    } on ServerException catch (e) {
      emit(ContactError(e.message));
    } on Failure catch (e) {
      emit(ContactError(e.message));
    }
  }
}
