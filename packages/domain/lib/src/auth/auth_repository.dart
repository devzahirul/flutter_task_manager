import 'app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  Future<AppUser?> currentUser();
  Future<AppUser?> signInAnonymously();
  Future<void> signOut();
}

