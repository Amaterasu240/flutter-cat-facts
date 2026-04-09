import 'package:http/http.dart' as http;

class CatFactService {
  static const String _baseUrl = 'https://catfact.ninja';

  // Метод для одного факта
  Future<String> getRandomFact() async {
    final response = await http.get(Uri.parse('$_baseUrl/fact'));
    if (response.statusCode == 200) {
      return response.body; // Возвращает сырой JSON
    } else {
      throw Exception('Не удалось загрузить факт');
    }
  }

  // Метод для нескольких фактов (добавим limit=5 для примера)
  Future<String> getMultipleFacts() async {
    final response = await http.get(Uri.parse('$_baseUrl/facts?limit=5'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Не удалось загрузить факты');
    }
  }
}