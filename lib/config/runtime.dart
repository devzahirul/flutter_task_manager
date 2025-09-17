class RuntimeConfig {
  static const bool useFirebaseAuth =
      bool.fromEnvironment('USE_FIREBASE_AUTH', defaultValue: false);

  static const bool useFirestoreTasks =
      bool.fromEnvironment('USE_FIRESTORE_TASKS', defaultValue: false);
}

