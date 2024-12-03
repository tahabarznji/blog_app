import 'package:blog_app/core/general/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/feature/auth/domain/usercases/current_user.dart';
import 'package:blog_app/feature/auth/domain/usercases/user_login.dart';
import 'package:blog_app/feature/auth/domain/usercases/user_sign_up.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/feature/blog/data/datasource/blog_local_data_source.dart';
import 'package:blog_app/feature/blog/data/datasource/blog_remote_data_source.dart';
import 'package:blog_app/feature/blog/data/repositores/blog_repository_impl.dart';
import 'package:blog_app/feature/blog/domain/entities/blog.dart';
import 'package:blog_app/feature/blog/domain/repository/blog_repository.dart';
import 'package:blog_app/feature/blog/domain/usecase/get_all_blogs.dart';
import 'package:blog_app/feature/blog/domain/usecase/upload_blog.dart';
import 'package:blog_app/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseAnnonKey);

  //  await Hive.initFlutter();
  final appDocumentDir = await getApplicationDocumentsDirectory();

  // Initialize Hive with the path to the directory
  Hive.init(appDocumentDir.path);

  // Open the Hive box for storing blogs
  final Box blogBox = await Hive.openBox('blogs');

  serviceLocator.registerLazySingleton(
    () => blogBox,
  );

  serviceLocator.registerLazySingleton(
    () => supabase.client,
  );
  serviceLocator.registerFactory(
    () => InternetConnection(),
  );
//core
  serviceLocator.registerLazySingleton<AppUserCubit>(
    () => AppUserCubit(),
  );
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(internetConnection: serviceLocator()),
  );
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: serviceLocator()),
  );
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
        authRemoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator()),
  );

  serviceLocator.registerFactory<UserSignUp>(
    () => UserSignUp(authRepository: serviceLocator()),
  );
  serviceLocator.registerFactory<UserLogin>(
    () => UserLogin(authRepository: serviceLocator()),
  );
  serviceLocator.registerFactory<CurrentUser>(
    () => CurrentUser(authRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator()),
  );
}

void _initBlog() {
  serviceLocator.registerFactory<BlogRemoteDataSource>(
    () => BlogRemoteDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerFactory<BlogLocalDataSource>(
    () => BlogLocalDataSourceImpl(serviceLocator()),
  );

  serviceLocator.registerFactory<BlogRepository>(
    () => BlogRepositoryImpl(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<UploadBlog>(
    () => UploadBlog(serviceLocator()),
  );
  serviceLocator.registerFactory<GetAllBlogs>(
    () => GetAllBlogs(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => BlogBloc(
      uploadBlog: serviceLocator(),
      getAllBlogs: serviceLocator(),
    ),
  );
}
