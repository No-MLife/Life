import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<void> storeTokens(String accessToken, String refreshToken) async {
  await storage.write(key: 'accessToken', value: accessToken);
  await storage.write(key: 'refreshToken', value: refreshToken);
}

Future<String?> getAccessToken() async {
  return await storage.read(key: 'accessToken');
}

Future<String?> getRefreshToken() async {
  return await storage.read(key: 'refreshToken');
}
