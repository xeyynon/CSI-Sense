import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  Future<Map<String, dynamic>?> fetchPresence() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.baseUrl + ApiConfig.presenceEndpoint),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {}

    return null;
  }

  Future<Map<String, dynamic>?> fetchActivity() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.baseUrl + ApiConfig.activityEndpoint),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {}

    return null;
  }
}
