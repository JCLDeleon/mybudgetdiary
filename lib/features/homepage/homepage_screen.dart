import 'package:flutter/material.dart';

import 'package:mybudgetdiary/features/dashboard/dashboard_screen.dart';
import 'package:mybudgetdiary/features/wallets/wallets_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<StatefulWidget> _pages = [const DashboardScreen(), const WalletsScreen()];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.wallet),
            label: 'Wallets',
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.travel_explore),
          //   label: 'Plans',
          // ),
        ],
      ),
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
    );
  }
}
