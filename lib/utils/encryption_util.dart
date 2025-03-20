import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionUtil {
  static const String _secretKey = "F8A3D9C6B2E715F4A1D3E7C9B8F20476";

  // "my32charsecretkey!1234567890123456"; // Must be 32 chars

  /// Encrypts a JSON string using AES encryption.
  static String encryptData(String plainText) {
    final key = encrypt.Key.fromUtf8(_secretKey);
    final iv = encrypt.IV.fromLength(16); // Initialization Vector
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.ecb),
    );

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64; // Convert to Base64
  }

  /// Decrypts an encrypted Base64 string back to JSON.
  static String decryptData(String encryptedText) {
    try {
      final key = encrypt.Key.fromUtf8(_secretKey);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.ecb),
      );

      final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
      return decrypted;
    } catch (e) {
      throw Exception("Decryption failed: Invalid data");
    }
  }
}
