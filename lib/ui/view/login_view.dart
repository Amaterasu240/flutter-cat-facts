import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    final viewModel = context.watch<AuthViewModel>();

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
              if (viewModel.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    viewModel.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Если идет загрузка - показываем спиннер, иначе - кнопки
              viewModel.isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            viewModel.login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          },
                          child: const Text('Войти'),
                        ),
                        TextButton(
                          onPressed: () {
                            viewModel.register(
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