import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_assignment/feature/model/contact.dart';
import 'package:meta/meta.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(ContactInitialState()) {
    on<AddContactEvent>(addContactEvent);
    on<ContactInitial>(contactInitial);
    on<DeleteContactEvent>(deleteContactEvent);
    on<NoContactsEvent>(noContactsEvent);
    on<ContactLoadedSuccessEvent>(contactLoadedSuccessEvent);
  }
  var collection = FirebaseFirestore.instance.collection('contacts');

  FutureOr<void> addContactEvent(
      AddContactEvent event, Emitter<ContactState> emit) async {
    CollectionReference collRef =
        FirebaseFirestore.instance.collection('contacts');
    collRef.add({
      'name': event.contact.name,
      'phone': event.contact.phone,
      'email': event.contact.emailId,
      'addr': event.contact.addr,
      'uuid': event.contact.uuid,
    });

    var data = await collection.get();

    late List<Map<String, dynamic>> tempList = [];
    for (var element in data.docs) {
      tempList.add(element.data());
    }
    emit(ContactLoadedSuccessState(contacts: tempList));
  }

  FutureOr<void> contactInitial(
      ContactInitial event, Emitter<ContactState> emit) async {
    try {
      emit(ContactLoadingState());

      await Future.delayed(Duration(seconds: 3));

      var data = await collection.get();

      late List<Map<String, dynamic>> tempList = [];
      for (var element in data.docs) {
        tempList.add(element.data());
      }
      if (tempList.isEmpty) {
        emit(NoContactsState());
      } else {
        emit(ContactLoadedSuccessState(contacts: tempList));
      }
    } catch (e) {
      emit(ContactErrorState());
    }
  }

  FutureOr<void> contactLoadedSuccessEvent(
      ContactLoadedSuccessEvent event, Emitter<ContactState> emit) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      var data = await collection.get();
      late List<Map<String, dynamic>> tempList = [];
      for (var element in data.docs) {
        tempList.add(element.data());
      }
      emit(ContactLoadedSuccessState(contacts: tempList));
    } catch (e) {
      emit(ContactErrorState());
    }
  }

  FutureOr<void> deleteContactEvent(
      DeleteContactEvent event, Emitter<ContactState> emit) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('contacts')
          .where('uuid', isEqualTo: event.uuid)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        var id = snapshot.docs[0].id;
        await FirebaseFirestore.instance
            .collection('contacts')
            .doc(id)
            .delete();
      }

      var data = await collection.get();
      late List<Map<String, dynamic>> tempList = [];

      for (var element in data.docs) {
        tempList.add(element.data());
      }
      if (tempList.isEmpty) {
        emit(NoContactsState());
      } else {
        emit(ContactLoadedSuccessState(contacts: tempList));
      }
    } catch (e) {
      emit(ContactErrorState());
    }
  }

  FutureOr<void> noContactsEvent(
      NoContactsEvent event, Emitter<ContactState> emit) {
    emit(NoContactsState());
  }
}
