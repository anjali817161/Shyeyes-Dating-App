import 'dart:convert';
import 'dart:io';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/dashboard/model/dashboard_model.dart';
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

  Future<List<ActiveUserModel>> getActiveUsers() async {
    final url = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.activeUsers);
    final String token = await SharedPrefHelper.getToken() ?? 'NULL';
    print("Fetching active users from: $url with token: $token");

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print("response body:------ ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['data'] is List) {
        // Case 1: API returns a list of users
        return (data['data'] as List)
            .map((e) => ActiveUserModel.fromJson(e))
            .toList();
      } else if (data['data'] is Map) {
        // Case 2: API returns a single user
        return [ActiveUserModel.fromJson(data['data'])];
      } else {
        throw Exception("Invalid API response format");
      }
    } else {
      throw Exception("Failed to fetch active users: ${response.statusCode}");
    }
  }

  Future<void> logout() async {
    await SharedPrefHelper.clearToken(); // clears token from shared prefs
    print("Token cleared. User logged out.");
    final token = await SharedPrefHelper.getToken();
    print("Token after logout: $token");
  }

  // Future<Message> sendMessage(int receiverId, String text) async {
  //   final String? token = await SharedPrefHelper.getToken();
  //   print("Token from SharedPref: $token");
  //   final url = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.sendMsg);
  //   print("Send Message URL => $url");

  //   final response = await http.post(
  //     url,
  //     headers: {
  //       "Accept": "application/json",
  //       "Authorization": "Bearer $token",
  //       "Content-Type": "application/json",
  //     },
  //     body: jsonEncode({
  //       'receiver_id': receiverId,
  //       'message': text,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     print("Message sent successfully");
  //     print("Response Body: ${response.body}");
  //     return Message.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception("Failed to send message: ${response.statusCode}");
  //   }
  // }
  // Future<List<Message>> getMessages(int receiverId) async {
  //   final url = Uri.parse("baseUrl/messages/$receiverId");
  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     if (data is Map) {
  //       // case: single object
  //       print(response.body);
  //       return [Message.fromJson(data as Map<String, dynamic>)];
  //     } else {
  //       throw Exception("Unexpected response format");
  //     }
  //   } else {
  //     throw Exception("Failed to load messages: ${response.statusCode}");
  //   }
  // }
  Future<http.Response> editProfile({
  String? fName,
  String? lName,
  String? phone,
  String? age,
  String? dob,
  String? gender,
  String? location,
  String? about,
  File? img,
}) async {
  final String? token = await SharedPrefHelper.getToken();
  final url = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.updateProfile);
  print("Edit Profile URL => $url");

  var request = http.MultipartRequest('POST', url);

  // fields (only add if not null/empty)
  if (fName != null && fName.isNotEmpty) request.fields['f_name'] = fName;
  if (lName != null && lName.isNotEmpty) request.fields['l_name'] = lName;
  if (phone != null && phone.isNotEmpty) request.fields['phone'] = phone;
  if (age != null && age.isNotEmpty) request.fields['age'] = age;
  if (dob != null && dob.isNotEmpty) request.fields['dob'] = dob;
  if (gender != null && gender.isNotEmpty) request.fields['gender'] = gender;
  if (location != null && location.isNotEmpty) request.fields['location'] = location;
  if (about != null && about.isNotEmpty) request.fields['about'] = about;

  // file (optional)
  if (img != null) {
    request.files.add(
      await http.MultipartFile.fromPath('img', img.path),
    );
  }
  
  request.headers.addAll({
    "Accept": "application/json",
    "Authorization": "Bearer $token",

  });

  var streamedResponse = await request.send();
  
  print("Streamed Response: ${streamedResponse}");
  print("Streamed Response: ${streamedResponse.statusCode}");
  print("Fields => ${request.fields}");
print("Files => ${request.files.map((f) => f.filename).toList()}");
  return http.Response.fromStream(streamedResponse);
}
}
