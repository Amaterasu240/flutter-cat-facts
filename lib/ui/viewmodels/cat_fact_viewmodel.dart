import 'package:flutter/material.dart';
import '../../data/models/cat_fact.dart';
import '../../data/repositories/cat_fact_repository.dart';

class CatFactViewModel extends ChangeNotifier {
  final CatFactRepository _repository;

  CatFactViewModel(this._repository);

  // Состояние нашего экрана
  List<CatFact> facts = [];
  bool isLoading = false;

  int numberOfFacts = 5; // Количество фактов для второй кнопки

  void updateNumberOfFacts(double newValue) {
    numberOfFacts = newValue.toInt();
    notifyListeners();
  }

  // Логика первой кнопки
  Future<void> getSingleFact() async {
    isLoading = true;
    notifyListeners(); // Говорим экрану показать загрузку

    try {
      final fact = await _repository.fetchSingleFact();
      facts = [fact]; // Кладем в список один факт
    } catch (e) {
      facts = [CatFact(fact: 'Произошла ошибка')];
    } finally {
      isLoading = false;
      notifyListeners(); // Говорим экрану перерисоваться с данными
    }
  }

  void clearFacts() {
    facts = []; // Опустошаем список
    notifyListeners(); // Перерисовываем экран
  }

  // Логика второй кнопки
  Future<void> getMultipleFacts() async {
    isLoading = true;
    notifyListeners();

    try {
      facts = await _repository.fetchMultipleFacts(numberOfFacts); // Получаем список
    } catch (e) {
      facts = [CatFact(fact: 'Произошла ошибка')];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}