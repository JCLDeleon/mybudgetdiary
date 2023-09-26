import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybudgetdiary/common/sharedpreference.dart';

class DashboardService {
  static CollectionReference getUserCollection() {
    return FirebaseFirestore.instance.collection('Users');
  }

  static CollectionReference getWalletCollection() {
    return FirebaseFirestore.instance.collection('Wallets');
  }

  static DocumentReference getUserRef() {
    return getUserCollection().doc(UserPreference.getUID());
  }

  static Query<Object?> getUserWalletQuery() {
    return getWalletCollection().where("created_by", isEqualTo: UserPreference.getUID());
  }

}
