import 'dart:convert';

import 'dart:io';

import 'package:get/get_connect/http/src/response/response.dart';

import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/widgets/api_endpoints.dart';
import 'package:shyeyes/modules/profile/model/profile_model.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class AuthRepository {
  //login api
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

  /// 🔹 Signup API
  Future<http.Response> signup({
    required String fName,
    required String lName,
    required String email,
    required String phone,
    required String password,
  }) {
    final url = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.signupStep1);
    print("Signup URL => $url");

    final body = {
      "f_name": fName,
      "l_name": lName,
      "email": email,
      "phone": phone,
      "password": password,
    };

    print("Signup Body => $body");

    return http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  /// 🔹 Personal Info API (multipart)
  Future<http.Response> submitPersonalInfo({
    required int userId,
    File? imageFile,
    String? dob,
    String? age,
    String? gender,
    String? location,
    String? about,
  }) async {
    final String token = await SharedPrefHelper.getToken() ?? 'NULL';
    print("Token from SharedPref: $token");
    final url = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.signupStep2);
    print("Personal Info URL => $url");

    var request = http.MultipartRequest('POST', url);

    // normal fields
    request.fields['user_id'] = userId.toString();
    if (dob != null && dob.isNotEmpty) request.fields['dob'] = dob;
    if (age != null && age.isNotEmpty) request.fields['age'] = age;
    if (gender != null && gender.isNotEmpty) request.fields['gender'] = gender;
    if (location != null && location.isNotEmpty) {
      request.fields['location'] = location;
    }
    if (about != null && about.isNotEmpty) request.fields['about'] = about;

    // file field (optional)
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('img', imageFile.path),
      );
    }

    request.headers.addAll({
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });

    var streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }

  Future<UserProfileModel> getProfile() async {
    final String? token = await SharedPrefHelper.getToken();
    print("Token from SharedPref: $token");
    print(ApiEndpoints.baseUrl + ApiEndpoints.profile);

    final String Url = ApiEndpoints.baseUrl + ApiEndpoints.profile;
    print("Fetching profile from :: $Url with token: $token");
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
