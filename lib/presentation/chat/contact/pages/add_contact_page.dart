import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/presentation/chat/contact/bloc/contact_bloc.dart';
import 'package:chat_app/services/routing/app_router.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              appRouter.go(RouteNames.home);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text("Add Contact"),
          centerTitle: true,
          backgroundColor: AppPallete.appBarColor,
        ),
        body: BlocConsumer<ContactBloc, ContactState>(
          listener: (context, state) {
            if (state is ContactLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contact added successfully')),
              );
              appRouter.go(RouteNames.home);
            } else if (state is ContactError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final name = _nameController.text.trim();
                      final email = _emailController.text.trim();
                      if (name.isEmpty || email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Name and Email required')),
                        );
                        return;
                      }
                      context.read<ContactBloc>().add(
                            AddContactEvent(
                              name: name,
                              email: email,
                              userId:
                                  Supabase.instance.client.auth.currentUser!.id,
                            ),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Add Contact",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
