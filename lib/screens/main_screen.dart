import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_gpt/screens/history_screen.dart';
import 'package:travel_gpt/screens/profile_screen.dart';


import '../constants/colors.dart';
import '../main.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/custom_widgets.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> screens = [
    HomeScreen(),
    HistoryScreen(),
    ProfileScreen()
  ];

  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Are you want to Exit ?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("No")),
                  TextButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: Text("Yes"))
                ],
              );
            });
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: mc,
          title: Text(
            'Map My Mechanic',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
           
          ],
        ),
        // drawer: Drawer(
        //   child: Container(
        //     child: ListView(
        //       children: [
        //         UserAccountsDrawerHeader(
        //           decoration: BoxDecoration(color: mc),
        //           accountName: Text(
        //             "${prefs!.getString('name')}",
        //             style: TextStyle(fontSize: 20),
        //           ),
        //           accountEmail: Text(
        //             "(" + getRole(prefs!.getInt('role')!) + ")",
        //             style: TextStyle(fontSize: 15),
        //           ),
        //           currentAccountPicture: CircleAvatar(
        //             child: Text(
        //               "UN",
        //               style: TextStyle(fontSize: 30),
        //             ),
        //             //    child: Image.network("${user?.photoURL}"),
        //           ),
        //         ),
        //         DrawerItem(Icons.star, "Premium", PremiumScreen()),
        //         // DrawerItem(Icons.timer, "Book Appointment", BookAppointment()),
        //         DrawerItem(
        //             Icons.touch_app_rounded, "Appointments", Appointments()),
        //         // DrawerItem(Icons.history, "History", PremiumScreen()),
        //         DrawerItem(Icons.podcasts, "My Posts", MyPost()),
        //         DrawerItem(Icons.wallet, "Payment/Wallet", PaymentsRecord()),
        //         DrawerItem(Icons.person, "Following", Following()),
        //         DrawerItem(Icons.border_color_outlined, "Journal", Journal()),
        //         DrawerItem(Icons.info, "About Us", PremiumScreen()),
        //         DrawerItem(Icons.help, "Help Center", PremiumScreen()),
        //         DrawerItem(Icons.people, "Community", PremiumScreen()),
        //         ListTile(
        //           leading: Icon(Icons.logout),
        //           title: Text(
        //             'Sign Out',
        //             style: TextStyle(fontSize: 18),
        //           ),
        //           onTap: () async {
        //             showDialog(
        //                 context: context,
        //                 builder: (context) {
        //                   return AlertDialog(
        //                     title: Text("Are you want to Logout??"),
        //                     actions: [
        //                       TextButton(
        //                           onPressed: () {
        //                             Navigator.pop(context);
        //                           },
        //                           child: Text("No")),
        //                       TextButton(
        //                           onPressed: () async {
        //                             await prefs!.clear();
        //                             await FirebaseAuth.instance.signOut();
        //                             Navigator.pushAndRemoveUntil(
        //                                 context,
        //                                 MaterialPageRoute(
        //                                     builder: (context) =>
        //                                         WelcomeScreen()),
        //                                 (route) => false);
        //                           },
        //                           child: Text("Yes"))
        //                     ],
        //                   );
        //                 });
        //           },
        //         ),
               
        //       ],
        //     ),
        //   ),
        // ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            screens[_selectedIndex],
            
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: mc,
          unselectedItemColor: black,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: 28,
              ),
              activeIcon: Icon(
                Icons.home,
                size: 28,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.history_outlined,
              ),
              activeIcon: Icon(
                Icons.history,
              ),
              label: 'History',
            ),
           
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outlined,
                size: 28,
              ),
              activeIcon: Icon(
                Icons.person,
                size: 28,
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget DrawerItem(IconData icon, String title, Widget screen) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
      onTap: () {
        goBack(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen));
      },
    );
  }
}
