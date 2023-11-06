import 'package:contact_assignment/feature/bloc/contact_bloc.dart';
import 'package:contact_assignment/feature/model/contact.dart';
import 'package:contact_assignment/feature/widgets/view_contacts_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ViewContact extends StatefulWidget {
  const ViewContact({super.key});

  @override
  State<ViewContact> createState() => _ViewContactState();
}

class _ViewContactState extends State<ViewContact> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _addr = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ContactBloc contactBloc = ContactBloc();
  late List<Map<String, dynamic>> contacts = [];

  @override
  void initState() {
    contactBloc.add(ContactInitial());
    super.initState();
  }

  Future<void> refreshContact() async {
    contactBloc.add(ContactInitial());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contacts ")),
      body: BlocConsumer<ContactBloc, ContactState>(
        bloc: contactBloc,
        listener: (context, state) {
          if (state is ContactLoadedSuccessState) {
            contacts = state.contacts;
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case ContactLoadingState:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ContactLoadedSuccessState:
              return RefreshIndicator(
                onRefresh: refreshContact,
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    return ContactTile(
                      contactData: contacts[index],
                      onCallPressed: (phone) {
                        var phoneNumber = Uri.parse("tel://$phone");
                        launchUrl(phoneNumber);
                      },
                      onEmailPressed: (email) {
                        var emailId = Uri.parse("mailto:$email?subject=");
                        launchUrl(emailId);
                      },
                      onDeletePressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmationDialog(
                                title: "Delete ${contacts[index]['name']}?",
                                confirmButtonText: "Delete",
                                cancelButtonText: "Close",
                                onConfirm: () {
                                  contactBloc.add(
                                    DeleteContactEvent(
                                      uuid: contacts[index]['uuid'],
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                onCancel: () {
                                  Navigator.pop(context);
                                });
                          },
                        );
                      },
                    );
                  },
                ),
              );
            case NoContactsState:
              return const Center(
                child: Text("No Contacts "),
              );

            case ContactErrorState:
              return const Center(
                child: Text("Error"),
              );
            default:
              return const Center(
                child: Text(" No Contacts to Show "),
              );
          }
        },
      ),
      floatingActionButton: fab(),
    );
  }

  Widget fab() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Scaffold(
              body: SafeArea(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, right: 16, left: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  height: 50,
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        disposeTf();
                                      },
                                      icon: const Icon(Icons.close))),
                              SizedBox(
                                height: 50,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    String _uuid = const Uuid().v4();
                                    if (_formKey.currentState!.validate()) {
                                      contactBloc.add(
                                        AddContactEvent(
                                          contact: Contact(
                                              name: _name.text,
                                              phone: _phone.text,
                                              emailId: _email.text,
                                              addr: _addr.text,
                                              uuid: _uuid),
                                        ),
                                      );

                                      Navigator.pop(context);
                                      disposeTf();
                                    }
                                  },
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.deepPurple)),
                                  icon: const Icon(
                                    Icons.create,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16, top: 20),
                              child: CustomTextField(
                                controller: _name,
                                hintText: "Full Name",
                                validatorType: "name",
                                textFieldIcon: const Icon(Icons.person),
                                tit: TextInputType.name,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16),
                              child: CustomTextField(
                                controller: _email,
                                hintText: "Email",
                                validatorType: "email",
                                textFieldIcon: const Icon(Icons.email),
                                tit: TextInputType.emailAddress,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16),
                              child: CustomTextField(
                                controller: _addr,
                                hintText: "Address",
                                validatorType: "",
                                textFieldIcon:
                                    const Icon(Icons.location_city_rounded),
                                tit: TextInputType.streetAddress,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                              child: CustomTextField(
                                controller: _phone,
                                hintText: "Phone Number",
                                validatorType: "phone",
                                textFieldIcon: const Icon(Icons.phone),
                                tit: TextInputType.phone,
                                length: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Icon(
        Icons.add,
        size: 32,
        color: Colors.deepPurple[600],
      ),
    );
  }

  void disposeTf() {
    _name.clear();
    _phone.clear();
    _email.clear();
    _addr.clear();
  }
}
