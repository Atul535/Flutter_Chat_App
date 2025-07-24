part of 'contact_bloc.dart';

@immutable
sealed class ContactEvent {}

class LoadContactsEvent extends ContactEvent {
  LoadContactsEvent();
}

class AddContactEvent extends ContactEvent {
  final String name;
  final String email;

  AddContactEvent({required this.email, required this.name});
}
