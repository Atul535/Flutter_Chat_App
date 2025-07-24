import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/core/utils/loader.dart';
import 'package:chat_app/presentation/chat/contact/bloc/contact_bloc.dart';
import 'package:chat_app/presentation/chat/widgets/bottom_navigation_bar.dart';
import 'package:chat_app/presentation/chat/widgets/contact_list.dart';
import 'package:chat_app/services/routing/app_router.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  void initState() {
    super.initState();
    context.read<ContactBloc>().add(LoadContactsEvent());
  }

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
        body: BlocConsumer<ContactBloc, ContactState>(
          listener: (context, state) {
            if (state is ContactError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ContactLoading) {
              return Center(
                child: Loader(),
              );
            } else if (state is ContactLoaded) {
              return ContactList(contacts: state.contacts);
            } else if (state is ContactError) {
              return Center(
                child: Text('Error loading contacts'),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
