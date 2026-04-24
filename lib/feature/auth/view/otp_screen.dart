import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/auth/view_model/login_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:svg_flutter/svg.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = Get.put(LoginViewModel());

    // Calculate responsive widths
    double screenWidth = MediaQuery.of(context).size.width;
    double formWidth =
        screenWidth < 1200 ? screenWidth * 0.8 : screenWidth * 0.3;
    double contentWidth = formWidth * 0.55;

    // Define Pinput themes
    final defaultPinTheme = PinTheme(
      width: 46,
      height: 46,
      textStyle: const TextStyle(
        fontSize: 18,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: secondaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: primaryColor, width: 2),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.white,
        border: Border.all(color: primaryColor),
      ),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.blue),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SizedBox(
        width: screenWidth,
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            // Form Section
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      "assets/svgs/auth/login_background2.svg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height -
                            70, // Subtract appBar height
                      ),
                      child: Center(
                        child: SizedBox(
                          width: formWidth,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Welcome Text
                                const Center(
                                  child: CustomText(
                                    text: "Welcome Back",
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // User Avatar Section
                                Center(
                                  child: SizedBox(
                                    width: contentWidth,
                                    child: UserAvatar(
                                      name:
                                          loginViewModel.userIdController.text,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 30),

                                // OTP Form
                                Center(
                                  child: Form(
                                    key: loginViewModel.otpFormKey,
                                    child: SizedBox(
                                      width: contentWidth,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // OTP Section
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const CustomText(
                                                text: "Enter OTP",
                                                color: primaryColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                              ),
                                              const SizedBox(height: 8),
                                              Center(
                                                child: Directionality(
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  child: Pinput(
                                                    length: 4,
                                                    controller:
                                                        loginViewModel
                                                            .otpController,
                                                    defaultPinTheme:
                                                        defaultPinTheme,
                                                    focusedPinTheme:
                                                        focusedPinTheme,
                                                    submittedPinTheme:
                                                        submittedPinTheme,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter OTP';
                                                      }
                                                      if (value.length != 4) {
                                                        return 'Please enter complete OTP';
                                                      }
                                                      return null;
                                                    },
                                                    pinputAutovalidateMode:
                                                        PinputAutovalidateMode
                                                            .onSubmit,
                                                    showCursor: true,
                                                    onCompleted: (pin) {
                                                      loginViewModel
                                                          .otpController
                                                          .text = pin;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 30),

                                          // Verify Button
                                          SizedBox(
                                            width: contentWidth,
                                            height: 46,
                                            child: MaterialButton(
                                              onPressed:
                                                  () =>
                                                      loginViewModel
                                                          .verifyOTP(),
                                              color: primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const CustomText(
                                                text: "Verify OTP",
                                                color: whiteColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Background Image Section
            if (screenWidth > 768)
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: double.infinity,
                  child: SvgPicture.asset(
                    "assets/svgs/auth/login_background.svg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String name;

  const UserAvatar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircleAvatar(radius: 40),
        const SizedBox(height: 16),
        CustomText(text: name),
      ],
    );
  }
}
