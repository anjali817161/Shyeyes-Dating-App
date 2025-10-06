// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:pinput/pinput.dart';
// import 'package:shyeyes/modules/auth/signup/controller/signup_controller.dart';

// class RegisterOtpVerifyBottomSheet {
//   static void show(BuildContext context) {
//     final _formKey = GlobalKey<FormState>();
//     final SignUpController controller = Get.put(SignUpController());

//     final theme = Theme.of(context);
//     final primary = theme.colorScheme.primary;

//     // ✅ Timer turant start ho jaye jab sheet open ho
//     controller.startTimer();

//     showModalBottomSheet(
//       backgroundColor: const Color(0xFFFFF3F3),
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             left: 24,
//             right: 24,
//             top: 20,
//             bottom: MediaQuery.of(context).viewInsets.bottom + 24,
//           ),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   height: 5,
//                   width: 50,
//                   margin: const EdgeInsets.only(bottom: 20),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 Text(
//                   "Verify OTP",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 20,
//                     color: primary,
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // 🔹 OTP Input (Pinput)
//                 Pinput(
//                   length: 6,
//                   controller: controller.otpCtrl,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   defaultPinTheme: PinTheme(
//                     height: 55,
//                     width: 50,
//                     textStyle: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: primary.withOpacity(0.5)),
//                     ),
//                   ),
//                   focusedPinTheme: PinTheme(
//                     height: 55,
//                     width: 50,
//                     textStyle: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: primary, width: 2),
//                     ),
//                   ),
//                   submittedPinTheme: PinTheme(
//                     height: 55,
//                     width: 50,
//                     textStyle: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: primary),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) return 'Enter OTP';
//                     if (value.length < 6) return 'Enter valid OTP';
//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 12),

//                 // 🔹 Resend / Timer section
//                 // Obx(() {
//                 //   if (controller.isCounting.value) {
//                 //     return Align(
//                 //       alignment: Alignment.centerRight,
//                 //       child: Text(
//                 //         "Resend OTP in ${controller.counter.value}s",
//                 //         style: TextStyle(color: Colors.grey[700]),
//                 //       ),
//                 //     );
//                 //   } else {
//                 //     return Align(
//                 //       alignment: Alignment.centerRight,
//                 //       child: controller.isResendLoading.value
//                 //           ? const SizedBox(height: 20, width: 20)
//                 //           : GestureDetector(
//                 //               onTap: () {
//                 //                 controller.verifyOtp(context);
//                 //               },
//                 //               child: Text(
//                 //                 "Resend OTP",
//                 //                 style: TextStyle(
//                 //                   color: primary,
//                 //                   fontWeight: FontWeight.w600,
//                 //                   decoration: TextDecoration.underline,
//                 //                 ),
//                 //               ),
//                 //             ),
//                 //     );
//                 //   }
//                 // }),
//                 const SizedBox(height: 28),

//                 // 🔹 Verify OTP button
//                 SizedBox(
//                   width: double.infinity,
//                   child: Obx(
//                     () => ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         backgroundColor: primary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           controller.verifyOtp(context);
//                         }
//                       },
//                       child: controller.isLoading.value
//                           ? const SizedBox(
//                               height: 24,
//                               width: 24,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2,
//                               ),
//                             )
//                           : const Text(
//                               'Verify OTP',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.white,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
