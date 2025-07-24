import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/services/routing/app_router.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:flutter/material.dart';

class MessageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String status;
  const MessageAppBar({
    super.key,
    required this.name,
    this.status = 'online',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppPallete.appBarColor,
      leading: IconButton(
        onPressed: () {
          appRouter.go(RouteNames.home);
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      titleSpacing: 2,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppPallete.greyColor.withOpacity(0.5),
            child: Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                status,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppPallete.online),
              ),
            ],
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: AppPallete.transparentColor,
            border: Border.all(color: AppPallete.whiteColor, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.videocam_rounded,
              color: AppPallete.whiteColor,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Container(
          margin: const EdgeInsets.only(right: 15),
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: AppPallete.transparentColor,
            border: Border.all(color: AppPallete.whiteColor, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.call_rounded,
              color: AppPallete.whiteColor,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
