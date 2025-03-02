import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/core/services/auth_service.dart';

abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final String cookie;
  AuthenticationAuthenticated(this.cookie);
}

class AuthenticationFailure extends AuthenticationState {
  final String error;
  AuthenticationFailure(this.error);
}

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthService _authService;

  AuthenticationCubit({required AuthService authService})
    : _authService = authService,
      super(AuthenticationInitial());

  Future login(String email, String password) async {
    try {
      emit(AuthenticationLoading());
      Response response = await _authService.login(email, password);
      if (response.statusCode == 200) {
        List<String>? cookie = response.headers['set-cookie'];
        if (cookie != null && cookie.isNotEmpty) {
          print('Logowanie udane, ciasteczko: $cookie'); // Debugging
          emit(AuthenticationAuthenticated(cookie.first));
        }
      } else {
        emit(AuthenticationFailure("Błąd logowania: ${response.statusCode}"));
      }
    } catch (e) {
      print(e.toString());
      emit(AuthenticationFailure(e.toString()));
    }
  }

  Future register(String email, String username, String password) async {
    try {
      emit(AuthenticationLoading());
      Response response = await _authService.register(email, username, password);
    if (response.statusCode == 201) {
      List<String>? cookie = response.headers['set-cookie'];
      if (cookie != null && cookie.isNotEmpty) {
        print('Rejestracja udana, ciasteczko: $cookie'); // Debugging
        emit(AuthenticationAuthenticated(cookie.first));
      }
    } else {
      emit(AuthenticationFailure("Błąd rejestracji: ${response.statusCode}"));
    }
  } catch (e) {
    print(e.toString());
    emit(AuthenticationFailure(e.toString()));
  }
  }

}
