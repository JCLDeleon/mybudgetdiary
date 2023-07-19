import 'package:flutter/material.dart';

import '../features/authentication/login_screen.dart';
import '../features/homepage/homepage_screen.dart';



class Routes {
  static Route routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Login(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route routeToHomePageScreen(){
    return MaterialPageRoute(
      builder: (context) => const HomePage(),
    );
  }
}
