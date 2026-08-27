import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyARNY7pzFac2yYZEhQgxw2T9yl_D4G1EVo',
    appId: '1:43030429768:web:3885a6322c1f5ce6e9187d',
    messagingSenderId: '43030429768',
    projectId: 'movem-51b54',
    authDomain: 'movem-51b54.firebaseapp.com',
    storageBucket: 'movem-51b54.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyARNY7pzFac2yYZEhQgxw2T9yl_D4G1EVo',
    appId: '1:43030429768:android:3885a6322c1f5ce6e9187d',
    messagingSenderId: '43030429768',
    projectId: 'movem-51b54',
    storageBucket: 'movem-51b54.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAGVMZS-u6yJ9HlaYPoOw13jf7afz_Wr2M',
    appId: '1:43030429768:ios:3bda9a5e53a575e9e9187d',
    messagingSenderId: '43030429768',
    projectId: 'movem-51b54',
    storageBucket: 'movem-51b54.firebasestorage.app',
    iosBundleId: 'com.example.movem',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAGVMZS-u6yJ9HlaYPoOw13jf7afz_Wr2M',
    appId: '1:43030429768:ios:3bda9a5e53a575e9e9187d',
    messagingSenderId: '43030429768',
    projectId: 'movem-51b54',
    storageBucket: 'movem-51b54.firebasestorage.app',
    iosBundleId: 'com.example.movem',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyARNY7pzFac2yYZEhQgxw2T9yl_D4G1EVo',
    appId: '1:43030429768:web:3885a6322c1f5ce6e9187d',
    messagingSenderId: '43030429768',
    projectId: 'movem-51b54',
    authDomain: 'movem-51b54.firebaseapp.com',
    storageBucket: 'movem-51b54.firebasestorage.app',
  );
}
