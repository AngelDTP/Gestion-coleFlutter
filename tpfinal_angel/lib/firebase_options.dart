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
    apiKey: 'AIzaSyA4Ju68MsMUZC3pnsVFyDR9c2e1aoiImS0',
    appId: '1:904524114265:web:1bf078aa362274b73c4448',
    messagingSenderId: '904524114265',
    projectId: 'tpfinal-angel',
    authDomain: 'tpfinal-angel.firebaseapp.com',
    storageBucket: 'tpfinal-angel.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAXCTt9v4_tJWX-flFwzjAjZXLN7P4URRw',
    appId: '1:904524114265:android:48bc29b4da0fddfa3c4448',
    messagingSenderId: '904524114265',
    projectId: 'tpfinal-angel',
    storageBucket: 'tpfinal-angel.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDXYN2fQjHGpF4pHkQAOWnVEAXOnVBC2q4',
    appId: '1:904524114265:ios:5456407a2c9780b43c4448',
    messagingSenderId: '904524114265',
    projectId: 'tpfinal-angel',
    storageBucket: 'tpfinal-angel.appspot.com',
    iosBundleId: 'com.example.tpfinalAngel',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDXYN2fQjHGpF4pHkQAOWnVEAXOnVBC2q4',
    appId: '1:904524114265:ios:5456407a2c9780b43c4448',
    messagingSenderId: '904524114265',
    projectId: 'tpfinal-angel',
    storageBucket: 'tpfinal-angel.appspot.com',
    iosBundleId: 'com.example.tpfinalAngel',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA4Ju68MsMUZC3pnsVFyDR9c2e1aoiImS0',
    appId: '1:904524114265:web:f3846501d4086a6c3c4448',
    messagingSenderId: '904524114265',
    projectId: 'tpfinal-angel',
    authDomain: 'tpfinal-angel.firebaseapp.com',
    storageBucket: 'tpfinal-angel.appspot.com',
  );
}