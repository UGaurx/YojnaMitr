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
    apiKey: 'AIzaSyBQ8joxCrXG-nTwaFgCOKwlmSo4DR0goKw',
    appId: '1:148781520294:web:ef578836158111df8c2b67',
    messagingSenderId: '148781520294',
    projectId: 'yojna-mitr',
    authDomain: 'yojna-mitr.firebaseapp.com',
    storageBucket: 'yojna-mitr.firebasestorage.app',
    measurementId: 'G-NX1N8W7JWL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD6ghYpIv_F1HKuXK3UrUFd8JZmdwDgkOk',
    appId: '1:148781520294:android:b81dfb6cbccd3ef38c2b67',
    messagingSenderId: '148781520294',
    projectId: 'yojna-mitr',
    storageBucket: 'yojna-mitr.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCeqr8ejUj59nxG7pu4hxTQYjMlhJ5PDzc',
    appId: '1:148781520294:ios:5995257514bb58948c2b67',
    messagingSenderId: '148781520294',
    projectId: 'yojna-mitr',
    storageBucket: 'yojna-mitr.firebasestorage.app',
    iosBundleId: 'com.example.yojnaMitr',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCeqr8ejUj59nxG7pu4hxTQYjMlhJ5PDzc',
    appId: '1:148781520294:ios:5995257514bb58948c2b67',
    messagingSenderId: '148781520294',
    projectId: 'yojna-mitr',
    storageBucket: 'yojna-mitr.firebasestorage.app',
    iosBundleId: 'com.example.yojnaMitr',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBQ8joxCrXG-nTwaFgCOKwlmSo4DR0goKw',
    appId: '1:148781520294:web:8d41dde97941fabc8c2b67',
    messagingSenderId: '148781520294',
    projectId: 'yojna-mitr',
    authDomain: 'yojna-mitr.firebaseapp.com',
    storageBucket: 'yojna-mitr.firebasestorage.app',
    measurementId: 'G-Q18NWNFRNN',
  );
}
