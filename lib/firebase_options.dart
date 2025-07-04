// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAoi_YCzeNs3xm21zLtHXr1QzKilq_7nsI',
    appId: '1:500788649101:web:33e60b492e38b2c09516c4',
    messagingSenderId: '500788649101',
    projectId: 'brktkrproject1',
    authDomain: 'brktkrproject1.firebaseapp.com',
    storageBucket: 'brktkrproject1.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAPtOorwOdZFkhABJIvOGaUolC6PmF3MyY',
    appId: '1:500788649101:android:8b2cbf4adf43979b9516c4',
    messagingSenderId: '500788649101',
    projectId: 'brktkrproject1',
    storageBucket: 'brktkrproject1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDk6xnbs0Rsej_cfrZ18TjaEB-3uPoyze8',
    appId: '1:500788649101:ios:271bc8fffc72ea3c9516c4',
    messagingSenderId: '500788649101',
    projectId: 'brktkrproject1',
    storageBucket: 'brktkrproject1.firebasestorage.app',
    iosBundleId: 'com.example.myboutique',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDk6xnbs0Rsej_cfrZ18TjaEB-3uPoyze8',
    appId: '1:500788649101:ios:271bc8fffc72ea3c9516c4',
    messagingSenderId: '500788649101',
    projectId: 'brktkrproject1',
    storageBucket: 'brktkrproject1.firebasestorage.app',
    iosBundleId: 'com.example.myboutique',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAoi_YCzeNs3xm21zLtHXr1QzKilq_7nsI',
    appId: '1:500788649101:web:a1613680473a9a969516c4',
    messagingSenderId: '500788649101',
    projectId: 'brktkrproject1',
    authDomain: 'brktkrproject1.firebaseapp.com',
    storageBucket: 'brktkrproject1.firebasestorage.app',
  );
}
