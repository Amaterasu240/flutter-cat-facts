import 'dart:convert';
import '../models/cat_fact.dart';
import '../services/cat_fact_service.dart';

class CatFactRepository {
  final CatFactService _service;

  // Внедряем сервис через конструктор
  CatFactRepository(this._service);

  Future<CatFact> fetchSingleFact() async {
    final jsonString = await _service.getRandomFact();
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    return CatFact.fromJson(jsonData);
  }

  Future<List<CatFact>> fetchMultipleFacts(int count) async {
    List<Future<CatFact>> tasks = List.generate(count,(index) => fetchSingleFact());
    List<CatFact> randomFacts = await Future.wait(tasks);
    return randomFacts;
  }
}