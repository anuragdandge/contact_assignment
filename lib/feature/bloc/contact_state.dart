part of 'contact_bloc.dart';


abstract  class ContactState {}

class ContactInitialState extends ContactState {}
// "ContactInitialEvent" Invoke at the beginning of app
// To Fetch the Contacts as soon as user opens the app

class ContactLoadingState extends ContactState {}
// Show the CircularProgressIndicator while Fetching the Contacts


class NoContactsState extends ContactState {}
//  Used to Show No contacts are Available to Show


class ContactAddedState extends ContactState {
  List<Map<String, dynamic>> contacts;
  ContactAddedState({required this.contacts});
}

class ContactLoadedSuccessState extends ContactState {
  List<Map<String, dynamic>> contacts;
  ContactLoadedSuccessState({required this.contacts});
}

class ContactErrorState extends ContactState {}
