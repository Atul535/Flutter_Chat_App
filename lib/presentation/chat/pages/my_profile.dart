import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/core/utils/snackbar.dart';
import 'package:chat_app/presentation/auth/bloc/auth_bloc.dart';
import 'package:chat_app/services/routing/app_router.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

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
        title: Text(
          'Profile',
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            snackBar(context, 'User Logged Out');
            appRouter.go(RouteNames.login);
          }
        },
        builder: (context, state) {
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'User Name',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthUserLoggedOut());
                  },
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      color: AppPallete.primaryColor,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
