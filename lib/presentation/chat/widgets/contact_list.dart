import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/services/routing/app_router.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:flutter/material.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppPallete.tileColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          tileColor: AppPallete.tileColor,
          onTap: () {
            appRouter.go(RouteNames.message);
          },
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: AppPallete.greyColor.withOpacity(0.5),
            child: Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
          ),
          title: Text(
            'User $index',
            style: TextStyle(
                color: AppPallete.whiteColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      shrinkWrap: true,
    );
  }
}
