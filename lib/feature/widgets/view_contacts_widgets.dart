import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsScreenWidgets {
  Widget urlIconButton(String content, Icon icon) {
    return IconButton(
      onPressed: () {
        var phoneNumber = Uri.parse(content);
        launchUrl(phoneNumber);
      },
      icon: icon,
    );
  }

  Widget contactCardHeading(String content, double fS, FontWeight fW) {
    return Text(
      content,
      style: TextStyle(fontSize: fS, fontWeight: fW),
    );
  }

  Widget contactCardSubHeading(String content, double fS) {
    return Text(
      content,
      style: TextStyle(fontSize: fS, color: Colors.grey[700]),
    );
  }

  BoxDecoration contactCardTopDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.black38, width: .5),
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
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String validatorType;
  final Icon textFieldIcon;
  final TextInputType tit;
  final int? length;

  CustomTextField({
    required this.controller,
    required this.hintText,
    required this.validatorType,
    required this.textFieldIcon,
    required this.tit,
    this.length,
  });

  RegExp fullNameValid =
      RegExp(r"^[a-zA-Z]+(([',\.\-\s][a-zA-Z ])?[a-zA-Z]*)*$");
  bool validateFullName(String name) {
    String fullName = name.trim();
    if (fullNameValid.hasMatch(fullName)) {
      return true;
    } else {
      return false;
    }
  }

  RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  bool validateEmail(String email) {
    String emailid = email.trim();
    if (emailValid.hasMatch(emailid)) {
      return true;
    } else {
      return false;
    }
  }

  RegExp phoneNumValid = RegExp(r"(^(?:[+0]9)?[0-9]{10,12}$)");
  bool validatePhoneNum(String phone) {
    String phoneNum = phone.trim();

    if (phoneNumValid.hasMatch(phoneNum)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: tit,
      maxLength: length,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
        prefixIcon: textFieldIcon,
      ),
      validator: (value) {
        if (validatorType == "name") {
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
        } else if (validatorType == "phone") {
          if (value == null || value.isEmpty || value.length != 10) {
            return 'Please enter Phone Number  ';
          } else {
            bool result = validatePhoneNum(value);
            if (result) {
              return null;
            } else {
              return " Include digits Only";
            }
          }
        } else if (validatorType == "email") {
          if (value == null || value.isEmpty) {
            return 'Please enter Email ID  ';
          } else {
            bool result = validateEmail(value);
            if (result) {
              return null;
            } else {
              return " Include @xyz.com ";
            }
          }
        }
        return null;
      },
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  ConfirmationDialog({
    required this.title,
    required this.confirmButtonText,
    required this.cancelButtonText,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        title,
        style: const TextStyle(
          fontSize: 25,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: onCancel,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                elevation: MaterialStateProperty.all(5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.close),
                  Text(cancelButtonText),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onConfirm,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.deepPurple[400]),
                elevation: MaterialStateProperty.all(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  Text(
                    confirmButtonText,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class ContactTile extends StatelessWidget {
  final Map<String, dynamic> contactData;
  final Function(String) onCallPressed;
  final Function(String) onEmailPressed;
  final Function() onDeletePressed;

  ContactTile({
    required this.contactData,
    required this.onCallPressed,
    required this.onEmailPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.black26),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
        color: Colors.deepPurple[100],
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 10),
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
                    ContactsScreenWidgets().contactCardHeading(
                        contactData['name'], 24, FontWeight.w700),
                    ContactsScreenWidgets().contactCardSubHeading(
                      contactData['phone'],
                      16,
                    ),
                    ContactsScreenWidgets().contactCardSubHeading(
                      contactData['email'],
                      16,
                    ),
                    ContactsScreenWidgets().contactCardSubHeading(
                      contactData['addr'],
                      16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            decoration: ContactsScreenWidgets().contactCardTopDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        onCallPressed(contactData['phone']);
                      },
                      icon: const Icon(Icons.call),
                    ),
                    IconButton(
                      onPressed: () {
                        onEmailPressed(contactData['email']);
                      },
                      icon: const Icon(Icons.mail),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: onDeletePressed,
                  icon: const Icon(
                    Icons.delete_outline_outlined,
                    fill: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
