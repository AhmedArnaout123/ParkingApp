import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/users/locations_page.dart';
import 'package:parking_graduation_app_1/users/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
