import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
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
      "firstName": fName,
      "lastName": lName,
      "email": email,
      "phoneNo": phone,
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

  // ✅ Verify OTP
  Future<http.Response> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse(
      ApiEndpoints.baseUrl + ApiEndpoints.verifyRegisterOTP,
    );

    final body = {"email": email, "otp": otp};

    print("📩 Verify OTP Body => $body");

    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
  }

  /// 🔹 Personal Info API (multipart)
  Future<http.Response> submitPersonalInfo({
    File? imageFile,
    String? dob,
    String? age,
    String? gender,
    String? location,
    String? about,
    String? hobbies,
  }) async {
    final String token = await SharedPrefHelper.getToken() ?? 'NULL';
    print("Token from SharedPref: $token");
    final url = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.signupStep2);
    print("Personal Info URL => $url");
    var request = http.MultipartRequest('POST', url);

    // normal fields

    if (dob != null && dob.isNotEmpty) request.fields['dob'] = dob;
    if (age != null && age.isNotEmpty) request.fields['age'] = age;
    if (gender != null && gender.isNotEmpty) request.fields['gender'] = gender;
    if (location != null && location.isNotEmpty) {
      request.fields['location'] = location;
    }
    if (about != null && about.isNotEmpty) request.fields['bio'] = about;
    if (hobbies != null && hobbies.isNotEmpty)
      request.fields['hobbies'] = hobbies;

    // 👇 Only add if image is selected
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath("profilePic", imageFile.path),
      );
    }

    request.headers.addAll({
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    });

    var streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }

  // your profile api

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
        "Authorization": "Bearer $token", // 🔑 usually
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

  Future<List<BestMatchModel>> fetchBestMatches() async {
    final String token = await SharedPrefHelper.getToken() ?? 'NULL';
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.bestMatches),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded["status"] == true && decoded["data"] != null) {
          List data = decoded["data"];
          return data.map((e) => BestMatchModel.fromJson(e)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception("Failed to fetch best matches");
      }
    } catch (e) {
      rethrow;
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
    if (location != null && location.isNotEmpty)
      request.fields['location'] = location;
    if (about != null && about.isNotEmpty) request.fields['about'] = about;

    // file (optional)
    if (img != null) {
      request.files.add(await http.MultipartFile.fromPath('img', img.path));
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

  static Future<Map<String, dynamic>?> sendRequest(int receiverId) async {
    try {
      final String token = await SharedPrefHelper.getToken() ?? 'NULL';
      final response = await http.post(
        Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.sentRequest),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"receiver_id": receiverId}),
      );

      print(" Response: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(" Failed with status: ${response.statusCode}");
        return {"message": "Failed", "status_code": response.statusCode};
      }
    } catch (e) {
      print(" Error sending request: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> cancelRequest(int requestId) async {
    try {
      final String token = await SharedPrefHelper.getToken() ?? 'NULL';

      final response = await http.delete(
        Uri.parse("${ApiEndpoints.baseUrl}/message-requests/$requestId/reject"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print(" Cancel Request Response: ${response.body}");
      print(" Request ID: $requestId");
      print(" Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(" Failed with status: ${response.statusCode}");
        return {"message": "Failed", "status_code": response.statusCode};
      }
    } catch (e) {
      print(" Error canceling request: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getInvitations() async {
    try {
      final String token = await SharedPrefHelper.getToken() ?? 'NULL';

      final response = await http.get(
        Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.requestRecieved),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print(" Invitations Response: ${response.body}");
      print(" Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"message": "Failed", "status_code": response.statusCode};
      }
    } catch (e) {
      print(" Error fetching invitations: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> acceptRequest(int requestId) async {
    try {
      final String token = await SharedPrefHelper.getToken() ?? 'NULL';

      final response = await http.post(
        Uri.parse("${ApiEndpoints.baseUrl}/message-requests/$requestId/accept"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print(" Accept Request Response: ${response.body}");
      print(" Request ID: $requestId");
      print(" Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"message": "Failed", "status_code": response.statusCode};
      }
    } catch (e) {
      print(" Error accepting request: $e");
      return null;
    }
  }

  // forget pass api

  // auth_repository.dart
  Future<http.Response> Forgetpassword(String email) {
    print("URL===== ${ApiEndpoints.baseUrl + ApiEndpoints.forgetemail}");
    // print("Email: $email);

    return http.post(
      Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.forgetemail),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({'email': email}),
    );
  }

  // otp verify

  Future<http.Response> forgetOtpVerify(String otp, String token) {
    print("URL===== ${ApiEndpoints.baseUrl + ApiEndpoints.forgetotp}");

    return http.post(
      Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.forgetotp),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // ✅ Token add
      },
      body: jsonEncode({'otp': otp}),
    );
  }

  // Create new password api

  Future<http.Response> CreateNewPass(
    String Newpass,
    String Confrimpass,
    String token,
  ) {
    print("URL===== ${ApiEndpoints.baseUrl + ApiEndpoints.Createpaaword}");

    return http.post(
      Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.Createpaaword),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // ✅ Token add
      },
      body: jsonEncode({
        'newPassword': Newpass,
        'confirmPassword': Confrimpass,
      }),
    );
  }
}
