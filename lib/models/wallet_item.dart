// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class WalletItem {
  final String created_at;
  final String last_update;
  final String wallet_item_category;
  final String wallet_item_name;
  final num wallet_item_balance;

  WalletItem({
    required this.created_at,
    required this.last_update,
    required this.wallet_item_category,
    required this.wallet_item_name,
    required this.wallet_item_balance,
  });

  WalletItem.fromMap(QueryDocumentSnapshot<Object?> map)
      : this(
          created_at: map['created_at'],
          last_update: map['last_update'],
          wallet_item_balance: map['wallet_item_balance'],
          wallet_item_category: map['wallet_item_category'],
          wallet_item_name: map['wallet_item_name'],
        );

  Map<String, dynamic> asMap() => {
        'created_at': created_at,
        'last_update': last_update,
        'wallet_item_balance': wallet_item_balance,
        'wallet_item_category': wallet_item_category,
        'wallet_item_name': wallet_item_name,
      };
}
