import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/general/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/snak_bar.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/feature/auth/presentation/pages/login_page.dart';
import 'package:blog_app/feature/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/feature/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingUpPage extends StatefulWidget {
  const SingUpPage({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => const SingUpPage(),
      );

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBar(context, state.massge);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'SignUp',
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      AuthField(
                        hintText: 'Name',
                        controller: _nameController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AuthField(
                        hintText: 'Email',
                        controller: _emailController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AuthField(
                        hintText: 'Password',
                        isObscureText: true,
                        controller: _passwordController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AuthGradientButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            debugPrint('join auth bloc');
                            context.read<AuthBloc>().add(AuthSignUp(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text));
                          }
                        },
                        buttonText: 'Sign Up',
                      ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Already  have an account? ',
                                style: Theme.of(context).textTheme.titleMedium),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(LoginPage.route());
                                },
                                child: Text(
                                  'Sign In',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: AppPallete.gradient2),
                                ),
                              ),
                            ),
                            // TextSpan(
                            //     text: 'Sign In',
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .titleMedium
                            //         ?.copyWith(color: AppPallete.gradient2)),
                          ],
                        ),
                      )
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
