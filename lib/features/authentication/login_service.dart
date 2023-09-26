import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mybudgetdiary/common/routes.dart';
import 'package:mybudgetdiary/common/sharedpreference.dart';
import 'package:mybudgetdiary/models/user.dart';

import '../../models/wallet.dart';

class LoginService {
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

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential = await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential = await auth.signInWithCredential(credential);

          user = userCredential.user;
          if (user != null) {
            UserPreference.setUserPreferences(user, googleSignInAuthentication.idToken);
            uploadUserDetailsOnFirstLogin();

            if (context.mounted) {
              Routes.routeToHomePageScreen(context);
            }
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(
                  content: 'The account already exists with a different credential',
                ),
              );
            }
          } else if (e.code == 'invalid-credential') {
            if (context.mounted) {
              signOut(context: context);
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(
                  content: 'Error occurred while accessing credentials. Try again.',
                ),
              );
            }
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                content: 'Error occurred using Google Sign In. Try again.',
              ),
            );
          }
        }
      }
      return user;
    }
    return null;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }

      await FirebaseAuth.instance.signOut();
      UserPreference.removeUserPreferences();
      if (context.mounted) {
        Routes.routeToSignInScreen(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  static void uploadUserDetailsOnFirstLogin() {
    DocumentReference userRef = getUserRef();

    userRef.get().then(
      (docSnapshot) {
        if (!docSnapshot.exists) {
          final users = Users(
            created_at: DateTime.now().toString(),
            last_login: DateTime.now().toString(),
            email: UserPreference.getEmail(),
            firstName: UserPreference.getFirstName(),
            lastName: UserPreference.getLastName(),
            fullName: UserPreference.getName(),
            photoURL: UserPreference.getPhotoUrl(),
            UID: UserPreference.getUID(),
          );

          userRef.set(users.asMap());

          addUserWallet();
        } else {
          userRef.update({
            'last_login': DateTime.timestamp().toString(),
          });
        }
      },
    );
  }

  static void addUserWallet() {
    getUserWalletQuery().get().then(
          (querySnapshot) {
        print("Successfully completed");
        if (querySnapshot.size == 0) {
          final wallet = Wallet(
              created_at: DateTime.now().toString(),
              created_by: UserPreference.getUID(),
              wallet_total_savings: 0,
              wallet_total_income: 0);

          getWalletCollection().doc().set(wallet.asMap());
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        content,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
