part of 'contact_bloc.dart';

@immutable
sealed class ContactState {}

final class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final List<ContactEntity> contacts; // Assuming contacts are represented as a list of strings

  ContactLoaded(this.contacts);
}

class ContactError extends ContactState {
  final String message;

  ContactError(this.message);
}
