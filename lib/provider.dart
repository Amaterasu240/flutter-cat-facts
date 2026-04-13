import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'data/services/auth_service.dart';
import 'data/services/cat_fact_service.dart';
import 'data/repositories/cat_fact_repository.dart';
import 'ui/viewmodels/auth_viewmodel.dart';
import 'ui/viewmodels/cat_fact_viewmodel.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final catFactServiceProvider = Provider<CatFactService>((ref) => CatFactService());

final catFactRepositoryProvider = Provider<CatFactRepository>((ref) {
  final service = ref.read(catFactServiceProvider);
  return CatFactRepository(service);
});

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});

final catFactViewModelProvider = NotifierProvider<CatFactViewModel, CatFactState>(() {
  return CatFactViewModel();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authServiceProvider).authStateChanges;
});