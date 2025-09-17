import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:domain/domain.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({fb.FirebaseAuth? auth})
      : _auth = auth ?? fb.FirebaseAuth.instance;

  final fb.FirebaseAuth _auth;

  AppUser? _map(fb.User? user) => user == null
      ? null
      : AppUser(
          id: user.uid,
          email: user.email,
          displayName: user.displayName,
        );

  @override
  Stream<AppUser?> authStateChanges() => _auth.authStateChanges().map(_map);

  @override
  Future<AppUser?> currentUser() async => _map(_auth.currentUser);

  @override
  Future<AppUser?> signInAnonymously() async {
    final cred = await _auth.signInAnonymously();
    return _map(cred.user);
  }

  @override
  Future<void> signOut() => _auth.signOut();
}

