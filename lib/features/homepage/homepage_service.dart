import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybudgetdiary/common/sharedpreference.dart';
import 'package:mybudgetdiary/features/homepage/models/savings.dart';

class HomepageService {
  static CollectionReference getUserCollection() {
    return FirebaseFirestore.instance.collection('Users');
  }

  static CollectionReference getUserSavingsCollection() {
    return getUserRef().collection('Savings');
  }

  static DocumentReference getUserRef() {
    return getUserCollection().doc(UserPreference.getUID());
  }

  static Future<void> uploadUserDetailsOnFirstLogin() async {
    DocumentReference userRef = getUserRef();

    userRef.get().then(
      (docSnapshot) {
        if (!docSnapshot.exists) {
          userRef.set({
            'UID': UserPreference.getUID(),
            'Email': UserPreference.getEmail(),
            'Name': UserPreference.getName(),
            'FirstName': UserPreference.getFirstName(),
            'LastName': UserPreference.getLastName(),
            'PhotoURL': UserPreference.getPhotoUrl(),
          });
        }
      },
    );
  }

  static Future<void> getUserDetails() async {
    DocumentReference userDocs = getUserRef();

  }

  static Future<List<Savings>> getUserSavings() async {
    num totalBalance = 0;
    final QuerySnapshot<Object?> userSavingsQuery = await getUserSavingsCollection().get();
    final savings = userSavingsQuery.docs.map((saving) => Savings.fromMap(saving)).toList();

    for (Savings saving in savings) {
      totalBalance += saving.balance;
    }

    savings.insert(0, Savings(balance: totalBalance, savingsName: "Total Balance"));
    return savings;
  }
}
