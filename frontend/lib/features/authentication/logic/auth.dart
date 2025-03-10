import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/authentication/data/user_model.dart';
import 'package:frontend/features/authentication/logic/user_storage.dart';

abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final String accessToken;
  AuthenticationAuthenticated(this.accessToken);
}

class AuthenticationFailure extends AuthenticationState {
  final String error;
  AuthenticationFailure(this.error);
}

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthService _authService;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  AuthenticationCubit({required AuthService authService})
    : _authService = authService,
      super(AuthenticationInitial());

  Future login(String email, String password) async {
    try {
      emit(AuthenticationLoading());
      Response response = await _authService.login(email, password);
      if (response.statusCode == 200) {
        final String accessToken = response.data['access_token'];
        final String refreshToken = response.data['refresh_token'];

        await _secureStorage.write(key: 'access_token', value: accessToken);
        await _secureStorage.write(key: 'refresh_token', value: refreshToken);

        User user = User(
            email: response.data["email"],
            username: response.data["username"],
            firstName: response.data["first_name"],
            lastName: response.data["last_name"]
        );
        UserStorage().setUser(user);

        print('Logowanie udane, token: $accessToken'); // Debugging
        emit(AuthenticationAuthenticated(accessToken));
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
        final String accessToken = response.data['access_token'];
          final String refreshToken = response.data['refresh_token'];

          await _secureStorage.write(key: 'access_token', value: accessToken);
          await _secureStorage.write(key: 'refresh_token', value: refreshToken);
          User user = User(
              email: response.data["email"],
              username: response.data["username"],
              firstName: response.data["first_name"],
              lastName: response.data["last_name"]
          );
          UserStorage().setUser(user);
          print('Rejestracja udana, token: $accessToken'); // Debugging
          emit(AuthenticationAuthenticated(accessToken));
      } else {
        emit(AuthenticationFailure("Błąd rejestracji: ${response.statusCode}"));
      }
    } catch (e) {
      print(e.toString());
      emit(AuthenticationFailure(e.toString()));
    }
  }

  Future logout() async {
    try {
      // emit(AuthenticationLoading());
      String? accessToken = await _secureStorage.read(key: 'access_token');
      String? refreshToken = await _secureStorage.read(key: 'refresh_token');
      Response response = await _authService.logout(accessToken!, refreshToken!);
      print(response);
      if (response.statusCode == 200) {
        await _secureStorage.delete(key: 'access_token');
        await _secureStorage.delete(key: 'refresh_token');
        UserStorage().clearUser();
        print('Wylogowanie udane'); // Debugging
        emit(AuthenticationInitial());
      } else {
        emit(AuthenticationFailure("Błąd wylogowania: ${response.statusCode}"));
      }
    } catch (e) {
      print(e.toString());
      emit(AuthenticationFailure(e.toString()));
    }
  }

}
