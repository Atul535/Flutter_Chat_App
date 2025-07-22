import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/presentation/chat/widgets/bottom_navigation_bar.dart';
import 'package:chat_app/presentation/chat/widgets/contact_list.dart';
import 'package:chat_app/services/routing/app_router.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppPallete.appBarColor,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_rounded),
          ),
          title: Text(
            'Contacts',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 7, top: 7, bottom: 7),
              child: GestureDetector(
                onTap: () {
                  appRouter.go(RouteNames.profile);
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: AppPallete.greyColor.withOpacity(0.5),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Expanded(
          child: ContactList(),
        ),
      ),
    );
  }
}
