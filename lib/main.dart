import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/services/cat_fact_service.dart';
import 'data/repositories/cat_fact_repository.dart';
import 'ui/viewmodels/cat_fact_viewmodel.dart';
import 'ui/view/cat_fact_view.dart';

void main() {
  // 1. Инициализируем Data слой
  final catFactService = CatFactService();
  final catFactRepository = CatFactRepository(catFactService);

  // 2. Оборачиваем приложение в Provider, чтобы UI слой получил доступ к ViewModel
  runApp(
    ChangeNotifierProvider(
      create: (context) => CatFactViewModel(catFactRepository),
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
      home: const CatFactView(), // Показываем наш экран
    );
  }
}