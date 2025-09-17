import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

Future<void> bootstrap(Widget app, {List<Override> overrides = const []}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase if options are available; this will be replaced by
  // flutterfire-generated values in lib/firebase_options.dart
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, st) {
    // In development or tests, Firebase might be intentionally unconfigured.
    FlutterError.reportError(FlutterErrorDetails(exception: e, stack: st));
  }

  runZonedGuarded(
    () => runApp(ProviderScope(overrides: overrides, child: app)),
    (error, stack) {
      FlutterError.reportError(FlutterErrorDetails(exception: error, stack: stack));
      if (kDebugMode) {
        // ignore: avoid_print
        print('Unhandled zone error: $error');
      }
    },
  );
}
