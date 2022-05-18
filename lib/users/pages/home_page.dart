import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/users/pages/locations_page.dart';
import 'package:parking_graduation_app_1/users/pages/profile_page.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int pageIndex = 0;
  PageController pageController = PageController();

  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      LocationsPage(
        onBookingSuccess: () {
          setState(() {
            pageIndex = 1;
            pageController.jumpToPage(1);
          });
        },
      ),
      const ProfilePage()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: pages,
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            pageIndex = index;
            pageController.jumpToPage(pageIndex);
          });
        },
        currentIndex: pageIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
