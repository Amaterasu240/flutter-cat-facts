import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/cat_fact.dart';
import '../../provider.dart';

class CatFactState {
  List<CatFact> facts;
  bool isLoading;
  int numberOfFacts = 5;

  CatFactState({
    this.facts = const [],
    this.isLoading = false,
    this.numberOfFacts = 5,
  });

  CatFactState copyWith({
    List<CatFact>? facts,
    bool? isLoading,
    int? numberOfFacts,
  }) {
    return CatFactState(
      facts: facts ?? this.facts,
      isLoading: isLoading ?? this.isLoading,
      numberOfFacts: numberOfFacts ?? this.numberOfFacts,
    );
  }
}

class CatFactViewModel extends Notifier<CatFactState> {

  @override
  CatFactState build() {
    return CatFactState();
  }

  void updateNumberOfFacts(double newValue) {
    state = state.copyWith(numberOfFacts: newValue.toInt());
  }

  // Логика первой кнопки
  Future<void> getSingleFact() async {
    state = state.copyWith(isLoading: true);
    
    final repository = ref.read(catFactRepositoryProvider);
    final fact = await repository.fetchSingleFact();
    state = state.copyWith(isLoading: false, facts: [fact]);
  }

    // Логика второй кнопки
  Future<void> getMultipleFacts() async {
    state = state.copyWith(isLoading: true);
    final repository = ref.read(catFactRepositoryProvider);
    final facts = await repository.fetchMultipleFacts(state.numberOfFacts);
    state = state.copyWith(isLoading: false, facts: facts);
  }

  void clearFacts() {
    state = state.copyWith(facts: []);
  }
}