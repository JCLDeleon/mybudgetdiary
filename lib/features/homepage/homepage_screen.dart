import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybudgetdiary/features/authentication/login_service.dart';

import 'package:mybudgetdiary/common/sharedpreference.dart';
import 'package:mybudgetdiary/features/homepage/widgets/account_card.dart';

import '../../common/utils.dart';
import '../../common/custom_colors.dart';

import 'homepage_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    HomepageService.uploadUserDetailsOnFirstLogin();
    HomepageService.getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Utils.returnGreetings(),
          style: GoogleFonts.openSans(
            fontStyle: FontStyle.normal,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        titleSpacing: 10,
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
                height: 35,
                child: ClipOval(
                  child: Material(
                    color: CustomColors.firebaseGrey.withOpacity(0.3),
                    child: UserPreference.getPhotoUrl() != ''
                        ? Image.network(
                            UserPreference.getPhotoUrl(),
                            fit: BoxFit.fitHeight,
                          )
                        : Icon(
                            Icons.person,
                            size: 60,
                            color: CustomColors.firebaseGrey,
                          ),
                  ),
                )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await LoginService.signOut(context: context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
      ]),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AccountCard(),
            ],
          ),
        ),
      ),
    );
  }
}
