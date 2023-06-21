// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR INFO HERE',
    appId: 'YOUR INFO HERE',
    messagingSenderId: 'YOUR INFO HERE',
    projectId: 'YOUR INFO HERE',
    authDomain: 'YOUR INFO HERE',
    storageBucket: 'YOUR INFO HERE',
    measurementId: 'YOUR INFO HERE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR INFO HERE',
    appId: 'YOUR INFO HERE',
    messagingSenderId: 'YOUR INFO HERE',
    projectId: 'YOUR INFO HERE',
    storageBucket: 'YOUR INFO HERE',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR INFO HERE',
    appId: 'YOUR INFO HERE',
    messagingSenderId: 'YOUR INFO HERE',
    projectId: 'YOUR INFO HERE',
    storageBucket: 'YOUR INFO HERE',
    iosClientId: 'YOUR INFO HERE',
    iosBundleId: 'YOUR INFO HERE',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR INFO HERE',
    appId: 'YOUR INFO HERE',
    messagingSenderId: 'YOUR INFO HERE',
    projectId: 'YOUR INFO HERE',
    storageBucket: 'YOUR INFO HERE',
    iosClientId: 'YOUR INFO HERE',
    iosBundleId: 'YOUR INFO HERE',
  );
}
