import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/widgets/api_endpoints.dart';

class AuthRepository {
  Future<http.Response> login(String email, String password) {

    print("URL===== ${ApiEndpoints.baseUrl + ApiEndpoints.login}");
    print("Email: $email, Password: $password");
    
    return http.post(
      Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.login),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({'email': email, 'password': password}),
    );
  }
}