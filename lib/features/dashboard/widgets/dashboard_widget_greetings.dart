import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/routes.dart';
import '../../../common/sharedpreference.dart';
import '../../../common/utils.dart';

class Greetings extends StatelessWidget {
  const Greetings({super.key});

  @override
  Widget build(BuildContext context) {
    String name = UserPreference.getFirstName();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi $name!",
              style: GoogleFonts.roboto(
                fontStyle: FontStyle.normal,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            Text(
              Utils.returnGreetings(),
              style: GoogleFonts.roboto(
                fontStyle: FontStyle.normal,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ],
        ),
        IconButton.outlined(
          padding: const EdgeInsets.all(4),
          icon: ClipOval(
            child: Material(
              child: UserPreference.getPhotoUrl() != ''
                  ? Image.network(
                UserPreference.getPhotoUrl(),
                height: 45,
              )
                  : const Icon(
                Icons.person,
                size: 45,
              ),
            ),
          ),
          onPressed: () {
            Routes.routeToSettingsScreen(context);
          },
        ),
      ],
    );
  }
}
