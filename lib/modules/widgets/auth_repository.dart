import 'dart:convert';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/widgets/api_endpoints.dart';
import 'package:shyeyes/modules/profile/model/profile_model.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

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

  Future<UserProfileModel> getProfile() async {
    final String? token = await SharedPrefHelper.getToken();
    print("Token from SharedPref: $token");
    print(ApiEndpoints.baseUrl + ApiEndpoints.profile);

    final String Url = ApiEndpoints.baseUrl + ApiEndpoints.profile;
    print(
      "Fetching profile from :: $Url with token: $token",
    );
    final response = await http.get(
      Uri.parse(Url),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token", // 🔑 usually required
      },
    );
    print("Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      print("Profile fetched successfully");
      print("Response Body: ${response.body}");

    } else {
      throw Exception("Failed to fetch profile: ${response.statusCode}");
      
    }
    return UserProfileModel.fromJson(jsonDecode(response.body));
    
  }
  Future<void> logout() async {
    await SharedPrefHelper.clearToken(); // clears token from shared prefs
    print("Token cleared. User logged out.");
    final token = await SharedPrefHelper.getToken();
  print("Token after logout: $token");
  }

}
