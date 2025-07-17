import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/services/routing/app_router.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  const ChatList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppPallete.tileColor,
          border: Border.all(color: AppPallete.greyColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          tileColor: AppPallete.tileColor,
          onTap: () {
            appRouter.go(RouteNames.message);
          },
          leading: CircleAvatar(
            radius: 25,
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
          subtitle: Text(
            'message $index',
            style: TextStyle(color: AppPallete.whiteColor),
          ),
          trailing: Text(
            '$index:0${index + 1}',
            style: TextStyle(color: AppPallete.greyColor),
          ),
        ),
      ),
      shrinkWrap: true,
    );
  }
}
