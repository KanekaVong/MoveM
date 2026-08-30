import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebasePhoneService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> sendVerificationCode({
    required String phoneNumber,
    int? forceResendingToken,
  }) async {
    final completer = Completer<String>();

    //Then release build won't disable Firebase's normal app verification.
    if (kDebugMode && phoneNumber == '+85512345678') {
      await _auth.setSettings(
        appVerificationDisabledForTesting: true,
      );
    }
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,

      verificationCompleted: (PhoneAuthCredential credential) async {
        // Manual SMS-code verification is used.
      },

      verificationFailed: (FirebaseAuthException e) {
        debugPrint(
          'Firebase verification failed: ${e.code} - ${e.message}',
        );

        if (!completer.isCompleted) {
          completer.completeError(
            Exception(e.message ?? 'Phone verification failed.'),
          );
        }
      },

      codeSent: (String verificationId, int? resendToken) {
        debugPrint(
          'Firebase codeSent. verificationId received.',
        );

        if (!completer.isCompleted) {
          completer.complete(verificationId);
        }
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        if (!completer.isCompleted) {
          completer.complete(verificationId);
        }
      },

      forceResendingToken: forceResendingToken,
    );

    return completer.future;
  }

  Future<UserCredential> verifyCode({
    required String verificationId,
    required String code,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );

    return _auth.signInWithCredential(credential);
  }
}