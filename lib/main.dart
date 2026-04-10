import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart';

import 'data/services/cat_fact_service.dart';
import 'data/services/auth_service.dart';
import 'data/repositories/cat_fact_repository.dart';
import 'ui/viewmodels/cat_fact_viewmodel.dart';
import'ui/viewmodels/auth_viewmodel.dart';
import 'ui/view/auth_wrapper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final catFactService = CatFactService();
  final catFactRepository = CatFactRepository(catFactService);
  final authService = AuthService();

  // получение доступа UI к ViewModel
  runApp(
    // MultiProvider для нескольких ViewModel
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CatFactViewModel(catFactRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(authService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cats facts',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const AuthWrapper(),
    );
  }
}