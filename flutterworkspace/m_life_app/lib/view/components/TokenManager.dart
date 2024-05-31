import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import '../../util/host.dart';
import '../../util/storeTokens.dart';

mixin TokenManager on GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = host;

    httpClient.addRequestModifier<void>((Request request) async {
      final token = await getAccessToken();
      if (token != null) {
        request.headers['access'] = token;
      }
      return request;
    });

    httpClient.addResponseModifier((request, response) async {
      if (response.statusCode == 401) {
        final newAccessToken = await _refreshToken();
        if (newAccessToken != null) {
          request.headers['access'] = newAccessToken;
          return httpClient.request(
            request.method,
            request.url.toString(),
            body: request.bodyBytes,
            headers: request.headers,
          );
        }
      }
      return response;
    });
  }

  Future<String?> _refreshToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return null;
    final response = await post(
      "/reissue",
      {},
      headers: {
        'Cookie': 'refresh=$refreshToken',
      },
    );
    if (response.statusCode == 200) {
      String? newRefreshToken = response.headers?['set-cookie'];
      String? accessToken = response.headers?['access'];

      if (accessToken != null && newRefreshToken != null) {
        storeTokens(accessToken, newRefreshToken);
        return accessToken;
      }
    }
    return null;
  }
}
