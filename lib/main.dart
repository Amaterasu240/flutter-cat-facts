import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ИМПОРТ RIVERPOD
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart';

import 'ui/view/auth_wrapper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // ProviderScope - это та самая "вышка", которая видит все константы из providers.dart
    const ProviderScope(
      child: MyApp(),
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 159, 73, 209)),
      ),
      home: const AuthWrapper(),
    );
  }
}