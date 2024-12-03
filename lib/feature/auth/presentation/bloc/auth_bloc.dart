import 'package:blog_app/core/general/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/general/entities/user.dart';
import 'package:blog_app/feature/auth/domain/usercases/current_user.dart';
import 'package:blog_app/feature/auth/domain/usercases/user_login.dart';
import 'package:blog_app/feature/auth/domain/usercases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>(
      (_, emit) => emit(AuthLoading()),
    );
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_onAuthLoggedIn);
  }
  void _onAuthLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser.call(NoParams());
    res.fold((l) => emit(AuthFailure(massge: l.massage)),
        (r) => _emitAuthSuccess(r, emit));
  }

  void _emitAuthSuccess(
    User user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    emit(
      AuthSuccess(user: user),
    );
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await _userSignUp(UserSignupParams(
        name: event.name, email: event.email, password: event.password));

    res.fold(
      (l) => emit(AuthFailure(massge: l.massage)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin(
        UserLoginParams(email: event.email, password: event.password));

    res.fold(
      (l) => emit(AuthFailure(massge: l.massage)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }
}
