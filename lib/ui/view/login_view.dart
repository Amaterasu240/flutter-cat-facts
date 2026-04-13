import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    ref.listen(authViewModelProvider, (previous, next) {
      if (next.errorMessage.isNotEmpty && next.errorMessage != previous?.errorMessage) {
        
        // Используем CustomNotification для создания своего дизайна
        BotToast.showCustomNotification(
          duration: const Duration(seconds: 4),
          toastBuilder: (cancelFunc) {
            final colorScheme = Theme.of(context).colorScheme;

            return SafeArea(
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                color: colorScheme.errorContainer, 
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: ListTile(
                    leading: Icon(
                      Icons.error_outline, 
                      color: colorScheme.onErrorContainer, 
                      size: 28.w,
                    ),
                    title: Text(
                      'Ошибка авторизации',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onErrorContainer,
                        fontSize: 14.sp,
                      ),
                    ),
                    subtitle: Text(
                      next.errorMessage,
                      style: TextStyle(
                        color: colorScheme.onErrorContainer,
                        fontSize: 13.sp,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.close, color: colorScheme.onErrorContainer),
                      onPressed: cancelFunc,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    });

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

              // Если идет загрузка - показываем спиннер, иначе - кнопки
              authState.isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        FilledButton(
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