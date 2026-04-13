import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  // Контроллеры для считывания текста из полей ввода
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Подключаемся к ViewModel
    final authState = ref.watch(authViewModelProvider);
    final authNotifier = ref.watch(authViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Вход в приложение')),
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(),
                ),
                obscureText: true, // Скрываем пароль звездочками
              ),
              const SizedBox(height: 16),
            
              // Если есть ошибка - показываем ее красным текстом
              if (authState.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    authState.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Если идет загрузка - показываем спиннер, иначе - кнопки
              authState.isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            authNotifier.login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          },
                          child: const Text('Войти'),
                        ),
                        TextButton(
                          onPressed: () {
                            authNotifier.register(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          },
                          child: const Text('Зарегистрироваться'),
                        ),
                      ],
                    ),
            ], 
          ), 
        ), 
      ), 
    ); 
  }
}