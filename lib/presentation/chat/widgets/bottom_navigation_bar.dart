import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/services/routing/app_router.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    super.key,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppPallete.appBarColor,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 12),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              appRouter.go(RouteNames.home);
            },
            icon: Icon(Icons.chat_bubble_outline),
          ),
          label: 'Message',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none),
          ),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_circle_outlined,
            size: 50,
            color: AppPallete.primaryColor,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {},
            icon: Icon(Icons.call),
          ),
          label: 'Calls',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              appRouter.go(RouteNames.contact);
            },
            icon: Icon(
              Icons.people_sharp,
            ),
          ),
          label: 'Contacts',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
