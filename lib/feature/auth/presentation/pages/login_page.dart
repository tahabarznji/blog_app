import 'package:blog_app/core/general/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/snak_bar.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/feature/auth/presentation/pages/sign_up_ui.dart';
import 'package:blog_app/feature/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/feature/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );

  @override
  State<LoginPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<LoginPage> {
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
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
                        context.read<AuthBloc>().add(AuthLogin(
                            email: _emailController.text,
                            password: _passwordController.text));
                      }
                    },
                    buttonText: 'Sign In',
                  ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Dont\'t have an account? ',
                            style: Theme.of(context).textTheme.titleMedium),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(SingUpPage.route());
                            },
                            child: Text(
                              'Sign Up',
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
                  // RichText(
                  //   text: TextSpan(
                  //     children: [
                  //       TextSpan(
                  //           text: 'Dont\'t have an account? ',
                  //           style: Theme.of(context).textTheme.titleMedium),
                  //       TextSpan(
                  //           text: 'Sign Up',
                  //           style: Theme.of(context)
                  //               .textTheme
                  //               .titleMedium
                  //               ?.copyWith(color: AppPallete.gradient2)),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
