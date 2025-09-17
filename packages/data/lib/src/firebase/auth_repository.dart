import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:domain/domain.dart';
import '../models/user_dto.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({fb.FirebaseAuth? auth})
      : _auth = auth ?? fb.FirebaseAuth.instance;

  final fb.FirebaseAuth _auth;

  UserDto? _toDto(fb.User? user) => user == null
      ? null
      : UserDto(
          id: user.uid,
          email: user.email,
          displayName: user.displayName,
        );

  AppUser? _toDomain(UserDto? dto) => dto == null
      ? null
      : AppUser(id: dto.id, email: dto.email, displayName: dto.displayName);

  @override
  Stream<AppUser?> authStateChanges() =>
      _auth.authStateChanges().map(_toDto).map(_toDomain);

  @override
  Future<AppUser?> currentUser() async => _toDomain(_toDto(_auth.currentUser));

  @override
  Future<AppUser?> signInAnonymously() async {
    final cred = await _auth.signInAnonymously();
    return _toDomain(_toDto(cred.user));
  }

  @override
  Future<void> signOut() => _auth.signOut();
}

