class ApiEndpoints {
  static const String baseUrl = "https://shyeyes-b.onrender.com/api/user/";

  static const String baseUrl2 =
      "https://shyeyes-backend.onrender.com/api/friends/";

  static const String imgUrl =
      "https://res.cloudinary.com/dlhp3v3fd/image/upload/";

  static const String likes = "https://shyeyes-backend.onrender.com/api/likes/";

  // Auth
  static const String report = "report";
  static const String activeUsers = "active-users";
  static const String updateProfile = "profile/update";
  static const String bestMatches = "best-matches";

  // register

  static const String signupStep1 = "register/step1";
  static const String verifyRegisterOTP = "register/verify-otp";
  static const String signupStep2 = "register/step2";
  // new api
  static const String login = "login";
  static const String profile = "profile";
  static const String forgetemail = "forgot-password";
  static const String otpverify = "otp/verify";
  static const String logout = "logout";
  static const String Createpaaword = "reset-password";
  static const String editprofile = "profile";
  static const String forgetotp = "verify-pass-otp";
  static const String Friendlist = "list";
  // static const String deleteRequest = "cancel";
  static const String sentRequest = "friend-request";
  static const String requests = "requests";

  static const String cancelInvite = "reject";
  static const String acceptInvite = "accept";
  static const String acceptedRequests = "sent";
  static const String unfriend = "unfriend";

  // like and unlike
  static const String like = "like";

  static const String sentrequestlike = "sent";
  static const String showlikesprofiles = "received";
  static const String moreuploadphoto = "photos";
  static const String plans = "plans";
  static const String getPhotos = "photos";
}

// Helper function to resolve image URLs
String resolveImageUrl(dynamic v) {
  const String cloudName = "dlhp3v3fd";
  const String cloudinaryBase =
      "https://res.cloudinary.com/$cloudName/image/upload/";

  if (v == null) return '';

  // Case 1: It's a Map, e.g., { "url": "...", "publicId": "..." }
  if (v is Map) {
    if (v['url'] != null && v['url'].toString().startsWith('http')) {
      return v['url'].toString();
    }
    if (v['publicId'] != null || v['public_id'] != null) {
      final id = (v['publicId'] ?? v['public_id']).toString();
      return '$cloudinaryBase$id';
    }
    return ''; // Invalid map
  }

  // Case 2: It's a String
  if (v is String) {
    if (v.isEmpty) return '';
    if (v.startsWith('http')) {
      return v;
    }
    // It's a legacy filename or a public ID, prepend the base URL
    return '$cloudinaryBase$v';
  }

  // Case 3: It's some other type, ignore it.
  return '';
}
