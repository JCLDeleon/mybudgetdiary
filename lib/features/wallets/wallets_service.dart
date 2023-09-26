import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybudgetdiary/common/sharedpreference.dart';
import 'package:mybudgetdiary/models/wallet.dart';
import 'package:mybudgetdiary/models/wallet_item.dart';

class WalletService {
  static CollectionReference getWalletCollection() {
    return FirebaseFirestore.instance.collection('Wallets');
  }

  static Query<Object?> getUserWalletQuery() {
    return getWalletCollection().where("created_by", isEqualTo: UserPreference.getUID());
  }

  static void addUserWalletItem(WalletItem walletItem) {
    num totalBalance = 0;
    getUserWalletQuery().get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          docSnapshot.reference.collection("wallet_items").doc().set(walletItem.asMap());

          print('${docSnapshot.id} => ${docSnapshot.data()}');

          if (walletItem.wallet_item_category == 'Savings') {
            totalBalance = Wallet.fromMap(docSnapshot).wallet_total_savings + walletItem.wallet_item_balance;
            docSnapshot.reference.update({'wallet_total_savings': totalBalance});
          } else {
            totalBalance = Wallet.fromMap(docSnapshot).wallet_total_income + walletItem.wallet_item_balance;
            docSnapshot.reference.update({'wallet_total_income': totalBalance});
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }
}
