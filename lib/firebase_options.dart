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
    apiKey: 'AIzaSyDJyJ_MdPl1x_3HWw31yhPzfcq6k9dTdbM',
    appId: '1:473683169999:web:a5ca83d0d01fbebda8ddba',
    messagingSenderId: '473683169999',
    projectId: 'flutterapp-ddc21',
    authDomain: 'flutterapp-ddc21.firebaseapp.com',
    storageBucket: 'flutterapp-ddc21.appspot.com',
    measurementId: 'G-G7WZ7WYW37',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCtdMJGzH0uWJhRZUsUascfFIT0NtIAVNA',
    appId: '1:473683169999:android:a59e889992ccbf99a8ddba',
    messagingSenderId: '473683169999',
    projectId: 'flutterapp-ddc21',
    storageBucket: 'flutterapp-ddc21.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAzi5krzxuCDBF04VRjG9CW3BNUeRWOoI4',
    appId: '1:473683169999:ios:3ecd9a11bf16ba1aa8ddba',
    messagingSenderId: '473683169999',
    projectId: 'flutterapp-ddc21',
    storageBucket: 'flutterapp-ddc21.appspot.com',
    iosClientId: '473683169999-r5s3h9lcqo1s1qgo2tjqg0vc63mjhq82.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAzi5krzxuCDBF04VRjG9CW3BNUeRWOoI4',
    appId: '1:473683169999:ios:53ccbb566d4e3982a8ddba',
    messagingSenderId: '473683169999',
    projectId: 'flutterapp-ddc21',
    storageBucket: 'flutterapp-ddc21.appspot.com',
    iosClientId: '473683169999-qv83vf5ktibt5v59u8l3b7m5dhi3vt54.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterapp.RunnerTests',
  );
}
