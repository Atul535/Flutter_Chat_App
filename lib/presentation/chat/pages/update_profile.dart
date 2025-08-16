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

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
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
            String displayName = 'User Name';
            String displayEmail = 'User Email';
            String displayPhone = 'User Phone';
            if (state is AuthSuccess) {
              final user = state.user;
              displayName = (user.name.isNotEmpty) ? user.name : displayName;
              displayEmail =
                  (user.email.isNotEmpty) ? user.email : displayEmail;
              displayPhone =
                  (user.mobile.isNotEmpty) ? user.mobile : displayPhone;
            }

            if (state is AuthLoading) {
              return const Center(child: Loader());
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
                        hintText: displayName,
                        controller: nameController,
                      ),
                      const SizedBox(height: 18),
                      AuthField(
                        hintText: displayEmail,
                        controller: emailController,
                      ),
                      const SizedBox(height: 18),
                      AuthField(
                        hintText: displayPhone,
                        controller: mobileController,
                      ),
                      const SizedBox(height: 30),
                      AuthButton(
                        text: 'Update',
                        onpressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  AuthSignup(
                                    name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    mobile: mobileController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                            debugPrint(nameController.text);
                            debugPrint(mobileController.text);
                            debugPrint(emailController.text);
                          }
                          appRouter.go(RouteNames.profile);
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
