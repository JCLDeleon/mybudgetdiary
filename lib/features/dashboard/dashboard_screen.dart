import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybudgetdiary/features/dashboard/widgets/dashboard_widget_greetings.dart';

import 'widgets/dashboard_widget_balance.dart';

enum Screens { dashboard, funds }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Screens screenView = Screens.dashboard;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: const Greetings(),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: const BalanceCard(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Transactions",
                style: GoogleFonts.roboto(
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "View all",
                  style: GoogleFonts.roboto(
                    fontStyle: FontStyle.normal,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
