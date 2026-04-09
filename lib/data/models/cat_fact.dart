class CatFact {
  final String fact;

  CatFact({required this.fact});

  // преобразование JSON (Map) в наш объект
  factory CatFact.fromJson(Map<String, dynamic> json) {
    return CatFact(
      fact: json['fact'] ?? 'Нет данных',
    );
  }
}