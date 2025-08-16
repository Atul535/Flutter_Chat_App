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
    switch (index) {
      case 0:
        appRouter.go(RouteNames.home);
        break;
      case 1:
        // Handle notifications
        break;
      case 2:
        appRouter.go(RouteNames.addcontact);
        break;
      case 3:
        // Handle calls
        break;
      case 4:
        appRouter.go(RouteNames.contact);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppPallete.appBarColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppPallete.primaryColor, // Blue for selected
      unselectedItemColor: AppPallete.whiteColor,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat_bubble_outline,
            size: _selectedIndex == 0 ? 30 : 24,
          ),
          label: 'Message',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.notifications_none,
            size: _selectedIndex == 1 ? 30 : 24,
          ),
          label: 'Notification',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_circle_outlined,
            size: 60,
            color: AppPallete.primaryColor,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.call,
            size: _selectedIndex == 3 ? 30 : 24,
          ),
          label: 'Calls',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.people_sharp,
            size: _selectedIndex == 4 ? 30 : 24,
          ),
          label: 'Contacts',
        ),
      ],
    );
  }
}
