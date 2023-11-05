part of 'contact_bloc.dart';

@immutable
abstract class ContactEvent {}

class ContactInitial extends ContactEvent {}

class NoContactsEvent extends ContactEvent {}

class DeleteContactEvent extends ContactEvent {
  final String uuid;
  DeleteContactEvent({required this.uuid});
}

class AddContactEvent extends ContactEvent {
  final Contact contact;

  AddContactEvent({required this.contact});
}

class ContactLoadedSuccessEvent extends ContactEvent {}
