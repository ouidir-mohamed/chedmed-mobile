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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAX879Ml3sAcVR_u-gVRdvpMj1DSi1hAG0',
    appId: '1:625533040689:web:37160990209db6e51ebd10',
    messagingSenderId: '625533040689',
    projectId: 'sahel-c072a',
    authDomain: 'sahel-c072a.firebaseapp.com',
    storageBucket: 'sahel-c072a.appspot.com',
    measurementId: 'G-BCWDWV7BCF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDWhfwcTKoBq7M6VEiD2rzua_Y4ulOKNy8',
    appId: '1:625533040689:android:dd5ffdd63aa35d441ebd10',
    messagingSenderId: '625533040689',
    projectId: 'sahel-c072a',
    storageBucket: 'sahel-c072a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMjXvrHNWK4CRPke2VT_BF2FecSzJuv88',
    appId: '1:625533040689:ios:b28436ddefe4b2a31ebd10',
    messagingSenderId: '625533040689',
    projectId: 'sahel-c072a',
    storageBucket: 'sahel-c072a.appspot.com',
    iosClientId: '625533040689-7ceu37kmr1u6r4ku72ukqqb1dvjlbur0.apps.googleusercontent.com',
    iosBundleId: 'com.example.chedmed',
  );
}
