import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/dashboard/model/bestmatch_model.dart';
import 'package:shyeyes/modules/dashboard/model/dashboard_model.dart';
import 'package:shyeyes/modules/edit_profile/edit_model.dart';
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

  Future<EditProfileModel> getProfile() async {
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
    return EditProfileModel.fromJson(jsonDecode(response.body));
  }

  Future<ActiveUsersModel> getActiveUsers() async {
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

      /// API response directly map karenge Activeusermodel pe
      return ActiveUsersModel.fromJson(data);
    } else {
      throw Exception("Failed to fetch active users: ${response.statusCode}");
    }
  }

  Future<List<BestmatchModel>> fetchBestMatches() async {
    final String token = await SharedPrefHelper.getToken() ?? 'NULL';
    print("print token===== $token");
    print("print url===== ${ApiEndpoints.baseUrl + ApiEndpoints.bestMatches}");

    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.bestMatches),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Best Matches Status Code: ${response.statusCode}");
      print("Best Matches Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        print("Best Matches Decoded: $decoded");

        // Check different possible response structures
        if (decoded["status"] == true) {
          // Option 1: Data is in "data" field
          if (decoded["data"] != null) {
            List data = decoded["data"];
            return data.map((e) => BestmatchModel.fromJson(e)).toList();
          }
          // Option 2: Data is in "matches" field
          else if (decoded["matches"] != null) {
            List data = decoded["matches"];
            return data.map((e) => BestmatchModel.fromJson(e)).toList();
          }
          // Option 3: Direct array response
          else if (decoded is List) {
            return decoded.map((e) => BestmatchModel.fromJson(e)).toList();
          } else {
            return [];
          }
        } else {
          print("API returned status false: ${decoded["message"]}");
          return [];
        }
      } else {
        print("Failed with status code: ${response.statusCode}");
        throw Exception("Failed to fetch best matches: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in fetchBestMatches: $e");
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
    String? email,
    String? phone,
    String? age,
    String? gender,
    String? location,
    String? dob,
    String? bio,
    String? hobbies,
    File? img,
  }) async {
    final String? token = await SharedPrefHelper.getToken();
    final url = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.editprofile);
    print("Edit Profile URL => $url");

    var request = http.MultipartRequest('PUT', url);

    // fields (only add if not null/empty)
    if (fName != null && fName.isNotEmpty) request.fields['firstName'] = fName;
    if (lName != null && lName.isNotEmpty) request.fields['lastName'] = lName;
    if (email != null && email.isNotEmpty) request.fields['email'] = email;
    if (phone != null && phone.isNotEmpty) request.fields['phoneNo'] = phone;
    if (age != null && age.isNotEmpty) request.fields['age'] = age;
    if (gender != null && gender.isNotEmpty) request.fields['gender'] = gender;
    if (location != null && location.isNotEmpty)
      request.fields['location'] = location;
    if (dob != null && dob.isNotEmpty) request.fields['dob'] = dob;
    if (bio != null && bio.isNotEmpty) request.fields['bio'] = bio;
    if (hobbies != null && hobbies.isNotEmpty)
      request.fields['hobbies'] = hobbies;

    // file (optional)
    if (img != null) {
      request.files.add(
        await http.MultipartFile.fromPath('profilePic', img.path),
      );
    }

    request.headers.addAll({
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });

    var streamedResponse = await request.send();

    print("Status Code: ${streamedResponse.statusCode}");
    print("Fields => ${request.fields}");
    print("Files => ${request.files.map((f) => f.filename).toList()}");

    return http.Response.fromStream(streamedResponse);
  }

  // send request api

  static Future<Map<String, dynamic>?> sendRequest(String receiverId) async {
    try {
      final String token = await SharedPrefHelper.getToken() ?? 'NULL';

      // Using your API constants
      final Uri uri = Uri.parse(
        "${ApiEndpoints.baseUrl2}${ApiEndpoints.sentRequest}/$receiverId",
      );

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Send Request Response: ${response.body}");
      print("Receiver ID: $receiverId");
      print("Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "message": "Failed",
          "status_code": response.statusCode,
          "body": response.body,
        };
      }
    } catch (e) {
      print("Error sending request: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> cancelRequest(String requestId) async {
    try {
      final String token = await SharedPrefHelper.getToken() ?? 'NULL';

      // Using your API constants
      final Uri uri = Uri.parse(
        "${ApiEndpoints.baseUrl2}${ApiEndpoints.deleteRequest}/$requestId",
      );

      final response = await http.delete(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Cancel Request Response: ${response.body}");
      print("Request ID: $requestId");
      print("Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "message": "Failed",
          "status_code": response.statusCode,
          "body": response.body,
        };
      }
    } catch (e) {
      print("Error canceling request: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getInvitations() async {
    try {
      final String token = await SharedPrefHelper.getToken() ?? 'NULL';

      final response = await http.get(
        Uri.parse(ApiEndpoints.baseUrl2 + ApiEndpoints.requests),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print(" Invitations Response: ${response.body}");
      print(" Status Code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {"message": "Failed", "status_code": response.statusCode};
      }
    } catch (e) {
      print(" Error fetching invitations: $e");
      return null;
    }
  }

  /// Accept invitation
  static Future<Map<String, dynamic>?> acceptInvite(String invitationId) async {
    try {
      final String token = await SharedPrefHelper.getToken() ?? 'NULL';
      print("token======$token");
      print(
        "${ApiEndpoints.baseUrl2 + ApiEndpoints.acceptInvite}/$invitationId",
      );
      final url = Uri.parse(
        "${ApiEndpoints.baseUrl2 + ApiEndpoints.acceptInvite}/$invitationId",
      );
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print(" Accept Invitation Response: ${response.body}");
      print(" Status Code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to accept request: ${response.body}");
      }
    } catch (e) {
      print(" Error accepting invitation: $e");
      return null;
    }
  }

  /// Reject invitation
  static Future<Map<String, dynamic>?> cancelInvite(String invitationId) async {
    try {
      final String token = await SharedPrefHelper.getToken() ?? 'NULL';
      print("token======$token");
      print(
        "${ApiEndpoints.baseUrl2 + ApiEndpoints.cancelInvite}/$invitationId",
      );
      final url = Uri.parse(
        "${ApiEndpoints.baseUrl2 + ApiEndpoints.cancelInvite}/$invitationId",
      );
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"status": "rejected"}),
      );
      print(" Accept Invitation Response: ${response.body}");
      print(" Status Code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to reject request: ${response.body}");
      }
    } catch (e) {
      print(" Error rejecting invitation: $e");
      return null;
    }
  }

  /// Get Accepted Requests
  static Future<Map<String, dynamic>?> getAcceptedRequests() async {
    try {
      final String token = await SharedPrefHelper.getToken() ?? 'NULL';
      final url = Uri.parse(
        ApiEndpoints.baseUrl2 + ApiEndpoints.acceptedRequests,
      );
      print("👉 Fetching accepted requests:---- $url");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print("response body: ${response.body}");
      print("status code----------${response.statusCode}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load accepted requests: ${response.body}");
      }
    } catch (e) {
      print("❌ Error fetching accepted requests: $e");
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

  // Friend list api

  // Future<http.Response> Friendlist() {
  //   print("URL===== ${ApiEndpoints.baseUrl2 + ApiEndpoints.Friendlist}");
  //   // print("Email: $email);

  //   return http.get(
  //     Uri.parse(ApiEndpoints.baseUrl2 + ApiEndpoints.Friendlist),
  //     headers: {
  //       "Accept": "application/json",

  //       "Content-Type": "application/json",
  //     },
  //   );
  // }
}
