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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'CHATTER',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              snackBar(context, state.message);
            }
            if (state is AuthSuccess) {
              appRouter.go(RouteNames.home);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      const Center(
                        child: Text(
                          'Welcome back',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 30),
                        ),
                      ),
                      const SizedBox(height: 40),
                      AuthField(
                        hintText: 'Email',
                        controller: emailController,
                      ),
                      const SizedBox(height: 18),
                      AuthField(
                        hintText: 'Password',
                        controller: passwordController,
                        isObscure: true,
                      ),
                      const SizedBox(height: 18),
                      AuthButton(
                        text: 'Login',
                        onpressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(AuthLogin(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim()));
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Dont't have an account? "),
                          TextButton(
                            onPressed: () {
                              appRouter.go(RouteNames.signup);
                            },
                            child: const Text('Create account',
                                style:
                                    TextStyle(color: AppPallete.primaryColor)),
                          ),
                        ],
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
