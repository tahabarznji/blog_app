import 'package:blog_app/core/general/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/theme/theme.dart';

import 'package:blog_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/feature/auth/presentation/pages/sign_up_ui.dart';
import 'package:blog_app/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/feature/blog/presentation/page/blog_page.dart';
import 'package:blog_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  // har katak await la begining bakr hatb

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<AppUserCubit>(),
          // service locator a type man bo detnatawa
        ),
        BlocProvider(
          create: (context) => serviceLocator<AuthBloc>(),
          // service locator a type man bo detnatawa
        ),
        BlocProvider(
          create: (context) => serviceLocator<BlogBloc>(),
          // service locator a type man bo detnatawa
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const BlogPage();
          }
          return const SingUpPage();
        },
      ),
    );
  }
}
