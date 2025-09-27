class ApiEndpoints {
  static const String baseUrl = "https://shyeyes-b.onrender.com/api/user/";

  static const String baseUrl2 = "https://shyeyes-b.onrender.com/api/friends/";

  static const String imgUrl = "https://shyeyes-b.onrender.com/uploads/";

  static const String likes = "https://shyeyes-b.onrender.com/api/likes/";

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
}
