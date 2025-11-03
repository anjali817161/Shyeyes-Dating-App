import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as ApiClient;
import 'package:shyeyes/modules/dashboard/model/bestmatch_model.dart';
import 'package:shyeyes/modules/dashboard/model/dashboard_model.dart';
import 'package:shyeyes/modules/edit_profile/edit_model.dart';
import 'package:shyeyes/modules/widgets/api_endpoints.dart';
import 'package:shyeyes/modules/profile/view/current_plan.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class AuthRepository {
  //login api
  Future<http.Response> login(String email, String password) {
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

    final body = {
      "firstName": fName,
      "lastName": lName,
      "email": email,
      "phoneNo": phone,
      "password": password,
    };

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

    final url = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.signupStep2);

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
      "Authorization": "Bearer $token",
    });

    var streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }

  // your profile api

  Future<EditProfileModel> getProfile() async {
    final String? token = await SharedPrefHelper.getToken();

    final String Url = ApiEndpoints.baseUrl + ApiEndpoints.profile;
    final response = await http.get(
      Uri.parse(Url),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token", // 🔑 usually
      },
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to fetch profile: ${response.statusCode}");
    }
    return EditProfileModel.fromJson(jsonDecode(response.body));
  }

  /// Search Users API (by name)
  static Future<Map<String, dynamic>?> searchUsers(String query) async {
    final String token = await SharedPrefHelper.getToken() ?? 'NULL';

    try {
      if (token == null) {
        return null;
      }

      final url = Uri.parse("${ApiEndpoints.baseUrl}search?q=$query");
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Search Users by Location API
  static Future<Map<String, dynamic>?> searchUsersByLocation(
    String city,
  ) async {
    final String token = await SharedPrefHelper.getToken() ?? 'NULL';

    try {
      if (token == null) {
        return null;
      }

      final url = Uri.parse(
        "${ApiEndpoints.baseUrl}search-by-location/new?city=$city",
      );
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Search Users by Age API
  static Future<Map<String, dynamic>?> searchUsersByAge(String age) async {
    final String token = await SharedPrefHelper.getToken() ?? 'NULL';

    try {
      if (token == null) {
        return null;
      }

      final url = Uri.parse("${ApiEndpoints.baseUrl}search-by-age?age=$age");
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Search Users by Gender API
  static Future<Map<String, dynamic>?> searchUsersByGender(String gender) async {
    final String token = await SharedPrefHelper.getToken() ?? 'NULL';

    try {
      if (token == null) {
        return null;
      }

      final url = Uri.parse("${ApiEndpoints.baseUrl}search-by-gender?gender=$gender");
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<ActiveUsersModel> getActiveUsers() async {
    final url = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.activeUsers);
    final String token = await SharedPrefHelper.getToken() ?? 'NULL';

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

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
          return [];
        }
      } else {
        throw Exception("Failed to fetch best matches: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await SharedPrefHelper.clearToken(); // clears token from shared prefs

    final token = await SharedPrefHelper.getToken();
  }

  static Future<Map<String, dynamic>?> getActivePlan() async {
    try {
      final String token = await SharedPrefHelper.getToken() ?? "NULL";

      final response = await http.get(
        Uri.parse("https://shyeyes-b.onrender.com/api/plans/remaining"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

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

    return http.Response.fromStream(streamedResponse);
  }

  // send request api
  static Future<Map<String, dynamic>?> sendRequest(String receiverId) async {
    try {
      final String token = await SharedPrefHelper.getToken() ?? 'NULL';
      final Uri uri = Uri.parse(
        "${ApiEndpoints.baseUrl2}$receiverId/${ApiEndpoints.sentRequest}",
      );

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ handle dono status codes
        return jsonDecode(response.body);
        // Close the dialog safely after API completes
      } else {
        return {
          "message": "Failed",
          "status_code": response.statusCode,
          "body": response.body,
        };
      }
    } catch (e) {
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {"message": "Failed", "status_code": response.statusCode};
      }
    } catch (e) {
      return null;
    }
  }

  /// Accept invitation
  static Future<Map<String, dynamic>?> acceptInvite(String invitationId) async {
    try {
      final String token = await SharedPrefHelper.getToken() ?? 'NULL';

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to accept request: ${response.body}");
      }
    } catch (e) {
      return null;
    }
  }

  /// Reject invitation
  static Future<Map<String, dynamic>?> cancelInvite(String invitationId) async {
    try {
      final String token = await SharedPrefHelper.getToken() ?? 'NULL';

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to reject request: ${response.body}");
      }
    } catch (e) {
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

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load accepted requests: ${response.body}");
      }
    } catch (e) {
      return null;
    }
  }

  // forget pass api

  // auth_repository.dart
  Future<http.Response> Forgetpassword(String email) {
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

  Future<http.Response> forgetOtpVerify(String otp, String email) {
    return http.post(
      Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.forgetotp),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({'otp': otp, 'email': email}),
    );
  }

  // Create new password api

  Future<http.Response> CreateNewPass(
    String Newpass,
    String Confrimpass,
    String email,
  ) {
    return http.post(
      Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.Createpaaword),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'newPassword': Newpass,
        'confirmPassword': Confrimpass,
        'email': email,
      }),
    );
  }

  // you sent like show favorite

  Future<http.Response> Sentlikes(String token) {
    return http.get(
      Uri.parse(ApiEndpoints.likes + ApiEndpoints.sentrequestlike),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
  }

  // show who likes my profiles

  Future<http.Response> Showlikesprofiles(String token) {
    return http.get(
      Uri.parse(ApiEndpoints.likes + ApiEndpoints.showlikesprofiles),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
  }
  // upload more photo

  Future<http.Response> Uploadmorephoto(String token) {
    return http.post(
      Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.moreuploadphoto),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
  }
}
