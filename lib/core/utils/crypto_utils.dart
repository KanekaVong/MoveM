import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';

class CryptoUtils {
  static String encryptAES(String plainText, String keyString) {
    final key = encrypt.Key.fromUtf8(keyString.padRight(32, '0').substring(0, 32));
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  static String decryptAES(String encryptedText, String keyString) {
    final parts = encryptedText.split(':');
    if (parts.length != 2) {
      throw const FormatException('Invalid encrypted payload format');
    }

    final key = encrypt.Key.fromUtf8(keyString.padRight(32, '0').substring(0, 32));
    final iv = encrypt.IV.fromBase64(parts[0]);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    return encrypter.decrypt64(parts[1], iv: iv);
  }

  static String hashSHA256(String data) {
    var bytes = utf8.encode(data);
    var digest = crypto.sha256.convert(bytes);
    return digest.toString();
  }
}
