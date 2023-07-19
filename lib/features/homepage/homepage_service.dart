import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybudgetdiary/common/sharedpreference.dart';

class HomepageService {
  static var totalbalance;

  static Future<void> uploadUserDetailsOnFirstLogin() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(UserPreference.getUID())
        .set({
      'UID': UserPreference.getUID(),
      'Email': UserPreference.getEmail(),
      'Name': UserPreference.getName(),
      'FirstName': UserPreference.getFirstName(),
      'LastName': UserPreference.getLastName(),
      'PhotoURL': UserPreference.getPhotoUrl(),
    });
  }

  static Future<void> getUserDetails() async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection("Users");

    var userDocs = userCollection.doc(UserPreference.getUID());

    userDocs.get().then(
      (doc) {
        final data = doc.data() as Map<String, dynamic>;

        print(data["Email"]);
      },
      onError: (e) => print("Error getting document: $e"),
    );

    CollectionReference userSavings = await userDocs.collection("Savings");

    // Get docs from collection reference
    QuerySnapshot querySnapshot = await userSavings.get();
    totalbalance = 0;
    // Get data from docs and convert map to List
    querySnapshot.docs.map(
      (doc) {
        final data = doc.data() as Map<String, dynamic>;
        print(data["Savings Name"]);
        print(data["Balance"]);

        totalbalance += data["Balance"];
      },
    ).toList();

    print("Total Balance: $totalbalance");
  }

  static Future<Map<String, dynamic>?> getUserSavings() async {
    var userDoc = FirebaseFirestore.instance
        .collection("Users")
        .doc(UserPreference.getUID());

    userDoc.get().then((value) => (savings) {
          final data = savings.data() as Map<String, dynamic>;
          print(data["Savings Name"]);
          print(data["Balance"]);

          return data;
        });

    return null;
  }
}
