import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/widgets/api_endpoints.dart';
import 'package:shyeyes/modules/about/model/profile_model.dart';

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
  Future<ProfileModel> getProfile(String token) async {
    final String Url = ApiEndpoints.baseUrl + ApiEndpoints.profile;
    print("Fetching profile from: $Url with token: $token");
    final response = await http.get(Uri.parse(Url));

    if (response.statusCode == 200) {
      print("Profile fetched successfully");
    } else {
      throw Exception("Failed to fetch profile: ${response.statusCode}");
    }
    return ProfileModel.fromJson(jsonDecode(response.body));
}
}
