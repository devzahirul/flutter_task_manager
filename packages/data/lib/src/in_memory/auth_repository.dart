import 'dart:async';

import 'package:domain/domain.dart';
import '../models/user_dto.dart';

class InMemoryAuthRepository implements AuthRepository {
  InMemoryAuthRepository();

  final _controller = StreamController<UserDto?>.broadcast();
  UserDto? _current;
  int _anonCounter = 0;

  @override
  Stream<AppUser?> authStateChanges() => _controller.stream.map(_toDomain);

  @override
  Future<AppUser?> currentUser() async => _toDomain(_current);

  @override
  Future<AppUser?> signInAnonymously() async {
    _current = UserDto(id: 'anon-${++_anonCounter}');
    _controller.add(_current);
    return _toDomain(_current);
  }

  @override
  Future<void> signOut() async {
    _current = null;
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }

  AppUser? _toDomain(UserDto? dto) => dto == null
      ? null
      : AppUser(id: dto.id, email: dto.email, displayName: dto.displayName);
}

