import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/widgets/api_endpoints.dart';

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
      request.files.add(await http.MultipartFile.fromPath('img', imageFile.path));
    }

    request.headers.addAll({
      "Accept": "application/json",
    });

    var streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }

}