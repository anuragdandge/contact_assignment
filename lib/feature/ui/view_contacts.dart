import 'package:contact_assignment/feature/bloc/contact_bloc.dart';
import 'package:contact_assignment/feature/model/contact.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AddContactsScreen extends StatefulWidget {
  const AddContactsScreen({super.key});

  @override
  State<AddContactsScreen> createState() => _AddContactsScreenState();
}

class _AddContactsScreenState extends State<AddContactsScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _addr = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ContactBloc contactBloc = ContactBloc();
  late List<Map<String, dynamic>> contacts = [];

  RegExp fullNameValid =
      RegExp(r"^[a-zA-Z]+(([',\.\-\s][a-zA-Z ])?[a-zA-Z]*)*$");
  RegExp phoneNumValid = RegExp(r"(^(?:[+0]9)?[0-9]{10,12}$)");
  RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool validateFullName(String name) {
    String fullName = name.trim();

    if (fullNameValid.hasMatch(fullName)) {
      return true;
    } else {
      return false;
    }
  }

  bool validatePhoneNum(String phone) {
    String phoneNum = phone.trim();

    if (phoneNumValid.hasMatch(phoneNum)) {
      return true;
    } else {
      return false;
    }
  }

  bool validateEmail(String email) {
    String emailid = email.trim();
    if (emailValid.hasMatch(emailid)) {
      return true;
    } else {
      return false;
    }
  }

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
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(width: .5, color: Colors.black26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: Offset(0, 2),
                            blurRadius: 5,
                            spreadRadius: 2,
                          )
                        ],
                        color: Colors.deepPurple[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      contacts[index]['name'],
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      contacts[index]['phone'],
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 16),
                                    ),
                                    Text(
                                      contacts[index]['email'],
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 16),
                                    ),
                                    Text(
                                      contacts[index]['addr'],
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black38, width: .5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  offset: const Offset(0, 2),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                )
                              ],
                              color: Colors.deepPurple[50],
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        var phoneNumber = Uri.parse(
                                            "tel://${contacts[index]['phone']}");
                                        launchUrl(phoneNumber);
                                      },
                                      icon: const Icon(Icons.call),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        var emailUri = Uri.parse(
                                            "mailto:${contacts[index]['email']}?subject=");
                                        launchUrl(emailUri);
                                      },
                                      icon: const Icon(Icons.mail),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text(
                                            " Delete ${contacts[index]['name']}? ",
                                            style: const TextStyle(
                                              fontSize: 25,
                                            ),
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.grey[300]),
                                                    elevation:
                                                        const MaterialStatePropertyAll(
                                                            5),
                                                  ),
                                                  child: const Row(
                                                    children: [
                                                      Icon(Icons.close),
                                                      Text("Close")
                                                    ],
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    contactBloc.add(
                                                      DeleteContactEvent(
                                                        uuid: contacts[index]
                                                            ['uuid'],
                                                      ),
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.deepPurple[
                                                                  400]),
                                                      elevation:
                                                          const MaterialStatePropertyAll(
                                                              20)),
                                                  child: const Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                      ),
                                                      Text(
                                                        "Delete ",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline_outlined,
                                    fill: 1,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            case NoContactsState:
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Contact List"),
                ),
                body: const Center(
                  child: Text("No Contacts "),
                ),
                floatingActionButton: fab(),
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
                        Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, bottom: 16, top: 20),
                                child: TextFormField(
                                  keyboardType: TextInputType.name,
                                  controller: _name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Full Name ';
                                    } else {
                                      bool result = validateFullName(value);
                                      if (result) {
                                        return null;
                                      } else {
                                        return " Name Should Contain Alphabets Only ";
                                      }
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.person),
                                    hintText: "Full Name",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, bottom: 16),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _email,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Full Name ';
                                    } else {
                                      bool result = validateEmail(value);
                                      if (result) {
                                        return null;
                                      } else {
                                        return " Include @xyz.com ";
                                      }
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.email),
                                    hintText: "Email",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 16.0, left: 16, bottom: 16),
                                child: TextFormField(
                                  keyboardType: TextInputType.name,
                                  controller: _addr,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Address ';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon:
                                        Icon(Icons.location_city_rounded),
                                    hintText: "Address",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, bottom: 8),
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: _phone,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length != 10) {
                                      return 'Please enter Phone Number  ';
                                    } else {
                                      bool result = validatePhoneNum(value);
                                      if (result) {
                                        return null;
                                      } else {
                                        return " Include digits Only";
                                      }
                                    }
                                  },
                                  maxLength: 10,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.phone),
                                    hintText: "Phone",
                                  ),
                                ),
                              ),
                            ],
                          ),
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
