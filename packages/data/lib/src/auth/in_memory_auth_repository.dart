import 'dart:async';

import 'package:domain/domain.dart';

class InMemoryAuthRepository implements AuthRepository {
  InMemoryAuthRepository();

  final _controller = StreamController<AppUser?>.broadcast();
  AppUser? _current;
  int _anonCounter = 0;

  @override
  Stream<AppUser?> authStateChanges() => _controller.stream;

  @override
  Future<AppUser?> currentUser() async => _current;

  @override
  Future<AppUser?> signInAnonymously() async {
    _current = AppUser(id: 'anon-${++_anonCounter}');
    _controller.add(_current);
    return _current;
  }

  @override
  Future<void> signOut() async {
    _current = null;
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}
