// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Wallet {
  final String created_at;
  final String created_by;
  final num wallet_total_savings;
  final num wallet_total_income;

  Wallet({
    required this.created_at,
    required this.created_by,
    required this.wallet_total_savings,
    required this.wallet_total_income,
  });

  Wallet.fromMap(QueryDocumentSnapshot<Object?> map)
      : this(
          created_at: map['created_at'],
          created_by: map['created_by'],
          wallet_total_savings: map['wallet_total_savings'],
          wallet_total_income: map['wallet_total_income'],
        );

  Map<String, dynamic> asMap() => {
        'created_at': created_at,
        'created_by': created_by,
        'wallet_total_savings': wallet_total_savings,
        'wallet_total_income': wallet_total_income,
      };
}
