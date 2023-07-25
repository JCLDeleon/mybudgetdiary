import 'package:cloud_firestore/cloud_firestore.dart';

class Savings {
  final num balance;
  final String savingsName;

  Savings({
    required this.balance,
    required this.savingsName,
  });

  Savings.fromMap(QueryDocumentSnapshot<Object?> map)
      : this(
          balance: map['Balance'],
          savingsName: map['Savings Name'],
        );

  Map<String, dynamic> asMap() => {
        'Balance': balance,
        'Savings Name': savingsName,
      };
}
