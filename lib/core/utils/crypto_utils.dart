import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';

class CryptoUtils {
  static String encryptAES(String plainText, String keyString) {
    final key = encrypt.Key.fromUtf8(keyString.padRight(32, '0').substring(0, 32));
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static String decryptAES(String encryptedText, String keyString) {
    final key = encrypt.Key.fromUtf8(keyString.padRight(32, '0').substring(0, 32));
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }

  static String hashSHA256(String data) {
    var bytes = utf8.encode(data);
    var digest = crypto.sha256.convert(bytes);
    return digest.toString();
  }
}
