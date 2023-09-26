import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String created_at;
  final String last_login;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final String photoURL;
  final String UID;

  Users({
    required this.created_at,
    required this.last_login,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.photoURL,
    required this.UID,
  });

  Users.fromMap(QueryDocumentSnapshot<Object?> map)
      : this(
          created_at: map['created_at'],
          last_login: map['last_login'],
          email: map['userEmail'],
          firstName: map['userfirstName'],
          lastName: map['userlastName'],
          fullName: map['userfullName'],
          photoURL: map['userphotoURL'],
          UID: map['userUID'],
        );

  Map<String, dynamic> asMap() => {
        'created_at': created_at,
        'last_login': last_login,
        'userEmail': email,
        'userfirstName': firstName,
        'userlastName': lastName,
        'userfullName': fullName,
        'userphotoURL': photoURL,
        'userUID': UID,
      };
}
