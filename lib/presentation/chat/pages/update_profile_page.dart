import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/core/utils/loader.dart';
import 'package:chat_app/core/utils/snackbar.dart';
import 'package:chat_app/presentation/auth/bloc/auth_bloc.dart';
import 'package:chat_app/presentation/auth/widgets/auth_button.dart';
import 'package:chat_app/presentation/auth/widgets/auth_field.dart';
import 'package:chat_app/services/routing/app_router.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppPallete.appBarColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                appRouter.go(RouteNames.profile);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          title: const Text(
            'Update Profile',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
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
            if (state is AuthLoading) {
              return const Center(child: Loader());
            }
            if (state is AuthSuccess) {
              final user = state.user;
              if (nameController.text.isEmpty) {
                nameController.text = user.name;
              }
              if (emailController.text.isEmpty) {
                emailController.text = user.email;
              }
              if (mobileController.text.isEmpty) {
                mobileController.text = user.phone;
              }
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      AuthField(
                        hintText: 'Name',
                        controller: nameController,
                      ),
                      const SizedBox(height: 18),
                      AuthField(
                        hintText: "Email",
                        controller: emailController,
                        isEnabled: false,
                      ),
                      const SizedBox(height: 18),
                      AuthField(
                        hintText: 'Mobile No.',
                        controller: mobileController,
                      ),
                      const SizedBox(height: 30),
                      AuthButton(
                        text: 'Update',
                        onpressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  AuthUpdateProfile(
                                    name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    mobile: mobileController.text.trim(),
                                  ),
                                );
                            debugPrint(nameController.text);
                            debugPrint(mobileController.text);
                            debugPrint(emailController.text);
                            snackBar(context, 'Profile updated successfully');
                            appRouter.go(RouteNames.profile);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
