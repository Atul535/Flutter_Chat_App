import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/core/utils/loader.dart';
import 'package:chat_app/core/utils/snackbar.dart';
import 'package:chat_app/presentation/auth/bloc/auth_bloc.dart';
import 'package:chat_app/presentation/auth/widgets/auth_button.dart';
import 'package:chat_app/services/routing/app_router.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPallete.appBarColor,
        leading: IconButton(
          onPressed: () {
            appRouter.go(RouteNames.home);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              appRouter.go(RouteNames.update);
            },
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            snackBar(context, 'User Logged Out');
            appRouter.go(RouteNames.login);
          } else if (state is AuthFailure) {
            snackBar(context, state.message);
          }
        },
        builder: (context, state) {
          String displayName = 'User Name';
          String displayEmail = 'User Email';

          if (state is AuthSuccess) {
            final user = state.user;
            displayName = (user.name.isNotEmpty) ? user.name : displayName;
            displayEmail = (user.email.isNotEmpty) ? user.email : displayEmail;
          }

          if (state is AuthLoading) {
            return const Center(child: Loader());
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: AppPallete.greyColor.withOpacity(0.5),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppPallete.borderColor)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 30.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Name : ',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              " $displayName",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Email : ',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              " $displayEmail",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AuthButton(
                  onpressed: () {
                    context.read<AuthBloc>().add(AuthUserLoggedOut());
                  },
                  text: "Log out",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
