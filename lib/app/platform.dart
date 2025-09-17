import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

bool isCupertinoPlatform(TargetPlatform platform) {
  return platform == TargetPlatform.iOS;
}

bool get isCupertinoRuntime => isCupertinoPlatform(defaultTargetPlatform);

String platformLabel(TargetPlatform platform) {
  switch (platform) {
    case TargetPlatform.android:
      return 'Android';
    case TargetPlatform.iOS:
      return 'iOS';
    case TargetPlatform.macOS:
      return 'macOS';
    case TargetPlatform.windows:
      return 'Windows';
    case TargetPlatform.linux:
      return 'Linux';
    case TargetPlatform.fuchsia:
      return 'Fuchsia';
  }
}

