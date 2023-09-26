// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {
  final String date;
  final String source;
  final String category;
  final String subcategory;
  final num amount;
  final String remarks;

  Transactions({
    required this.date,
    required this.source,
    required this.category,
    required this.subcategory,
    required this.amount,
    required this.remarks,
  });

  Transactions.fromMap(QueryDocumentSnapshot<Object?> map)
      : this(
          date: map['Transaction Date'],
          source: map['Transaction Source'],
          category: map['Transaction Category'],
          subcategory: map['Transaction SubCategory'],
          amount: map['Transaction Amount'],
          remarks: map['Transaction Remarks'],
        );

  Map<String, dynamic> asMap() => {
    'Transaction Date' : date,
    'Transaction Source' : source,
    'Transaction Category' : category,
    'Transaction SubCategory' : subcategory,
    'Transaction Amount' : amount,
    'Transaction Remarks' : remarks,
  };
}
