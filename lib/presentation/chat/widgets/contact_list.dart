import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/domain/chat/entities/contact_entity.dart';
import 'package:chat_app/services/routing/app_router.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactList extends StatelessWidget {
  final List<ContactEntity> contacts;
  const ContactList({
    super.key,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = Supabase.instance.client.auth.currentUser;
    final myId = currentUser?.id;
    return ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
              onTap: myId == null
                  ? null
                  : () {
                      appRouter.goNamed(
                        RouteNames.message,
                        pathParameters: {
                          'senderId': myId,
                          'receiverId': contact.id,
                        },
                        extra: contact,
                      );
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
                contact.name,
                style: TextStyle(
                  color: AppPallete.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        });
  }
}
