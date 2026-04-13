import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider.dart';

class AuthState {
  final bool isLoading;
  final String errorMessage;

  AuthState({this.isLoading = false, this.errorMessage = ''});
}

class AuthViewModel extends Notifier<AuthState> {
  
  @override
  AuthState build() => AuthState();

  // Функция для кнопки "Войти"
  Future<void> login(String email, String password) async {
    state = AuthState(isLoading: true, errorMessage: '');

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signIn(email, password);
      state = AuthState(isLoading: false, errorMessage: '');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        state = AuthState(isLoading: false, errorMessage: 'Неверный email или пароль. Проверьте данные или зарегистрируйтесь.');
      } else if (e.code == 'invalid-email') {
        state = AuthState(isLoading: false, errorMessage: 'Некорректный формат email.');
      } else {
        state = AuthState(isLoading: false, errorMessage: 'Произошла ошибка при входе');
      }
    } catch (e) {
      state = AuthState(isLoading: false, errorMessage: 'Неизвестная ошибка: $e');
    }
  }

  // Функция для кнопки "Зарегистрироваться"
  Future<void> register(String email, String password) async {
    state = AuthState(isLoading: true, errorMessage: '');

    try {
      final authService = ref.read(authServiceProvider);
      await authService.register(email, password);
      state = AuthState(isLoading: false, errorMessage: '');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        state = AuthState(isLoading: false, errorMessage: 'Этот email уже зарегистрирован. Попробуйте войти.');
      } else if (e.code == 'weak-password') {
        state = AuthState(isLoading: false, errorMessage: 'Слишком слабый пароль (нужно минимум 6 символов).');
      } else if (e.code == 'invalid-email') {
        state = AuthState(isLoading: false, errorMessage: 'Некорректный формат email.');
      } else {
        state = AuthState(isLoading: false, errorMessage: 'Произошла ошибка при регистрации');
      }
    }
  }

  // Функция для кнопки "Выйти"
  void logout() {
    ref.read(authServiceProvider).signOut();
  }
}
