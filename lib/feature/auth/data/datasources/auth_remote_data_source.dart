import 'package:blog_app/core/exceptions/server_exceptions.dart';
import 'package:blog_app/feature/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// lera rastawxo lagal data sourca ka qsa dakat ka remota
// lera rastawxo lagal data esh dakaakain

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassWord({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailPassWord({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  //like that i donset create depencey between them
  // its the depednecy injection
  //study unit testing -- for the future

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> signUpWithEmailPassWord(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
        },
      );

      if (response.user == null) {
        print('in the auth remote data source we have prblem');
        throw ServerExceptions(massage: 'user is null');
      }
      print('in the auth remote data is working');
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerExceptions(massage: e.toString());
    }
  }

  @override
  Future<UserModel> loginWithEmailPassWord(
      {required String email, required String password}) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );

      if (response.user == null) {
        throw ServerExceptions(massage: 'user is null');
      }

      return UserModel.fromJson(response.user!.toJson())
          .copyWith(email: currentUserSession!.user.email);
    } catch (e) {
      throw ServerExceptions(massage: e.toString());
    }
  }

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final user = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);
        return UserModel.fromJson(user.first)
            .copyWith(email: currentUserSession!.user.email);
      } else {
        return null;
      }
    } catch (e) {
      throw ServerExceptions(massage: e.toString());
    }
  }
}
