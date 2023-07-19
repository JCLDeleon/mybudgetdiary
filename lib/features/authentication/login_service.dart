import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mybudgetdiary/common/routes.dart';
import 'package:mybudgetdiary/common/sharedpreference.dart';

class LoginService {

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
          if (user != null) {
            UserPreference.setUserPreferences(
                user, googleSignInAuthentication.idToken);

            if (context.mounted) {
              Navigator.of(context)
                  .pushReplacement(Routes.routeToHomePageScreen());
            }
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(
                  content:
                      'The account already exists with a different credential',
                ),
              );
            }
          } else if (e.code == 'invalid-credential') {
            if (context.mounted) {
              signOut(context: context);
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(
                  content:
                      'Error occurred while accessing credentials. Try again.',
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
        Navigator.of(context).pushReplacement(Routes.routeToSignInScreen());
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
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
