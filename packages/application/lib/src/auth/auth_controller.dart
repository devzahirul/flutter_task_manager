import 'dart:async';

import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError('Provide an AuthRepository via override');
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<AppUser?>>((ref) {
  return AuthController(ref).._initialize();
});

class AuthController extends StateNotifier<AsyncValue<AppUser?>> {
  AuthController(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;
  StreamSubscription<AppUser?>? _sub;

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  void _initialize() {
    _sub = _repo.authStateChanges().listen((user) {
      state = AsyncValue.data(user);
    });
    _repo.currentUser().then((user) => state = AsyncValue.data(user));
  }

  Future<void> signInAnonymously() async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() => _repo.signInAnonymously());
    state = result;
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    await _repo.signOut();
    state = const AsyncValue.data(null);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

