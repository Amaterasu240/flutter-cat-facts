import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;

  AuthViewModel(this._authService) {
    // Как только ViewModel создается, мы начинаем слушать Firebase:
    // Если юзер вошел - мы сохраняем его данные. Если вышел - обнуляем.
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  User? _user;
  bool get isAuthenticated => _user != null; 

  bool isLoading = false; 
  String errorMessage = ''; 

  // Функция для кнопки "Войти"
  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners(); 

    try {
      await _authService.signIn(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        errorMessage = 'Неверный email или пароль. Проверьте данные или зарегистрируйтесь.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Некорректный формат email.';
      } else {
        errorMessage = 'Произошла ошибка при входе';
      }
    } catch (e) {
      errorMessage = 'Неизвестная ошибка: $e';
    } finally {
      isLoading = false;
      notifyListeners(); 
    }
  }

  // Функция для кнопки "Зарегистрироваться"
  Future<void> register(String email, String password) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      await _authService.register(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Этот email уже зарегистрирован. Попробуйте войти.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Слишком слабый пароль (нужно минимум 6 символов).';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Некорректный формат email.';
      } else {
        errorMessage = 'Произошла ошибка при регистрации';
      }
    } catch (e) {
      errorMessage = 'Неизвестная ошибка: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Функция для кнопки "Выйти"
  void logout() {
    _authService.signOut();
  }
}
