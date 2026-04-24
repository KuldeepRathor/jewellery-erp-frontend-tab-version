import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/auth/view/debug_server_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/auth/view_model/login_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:svg_flutter/svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = Get.put(LoginViewModel());

    double screenWidth = MediaQuery.of(context).size.width;
    double formWidth =
        screenWidth < 1200 ? screenWidth * 0.8 : screenWidth * 0.3;
    double contentWidth = formWidth * 0.55;

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
      floatingActionButton: const DebugServerFab(),
      body: Focus(
        autofocus: true,
        onKeyEvent: (node, event) => onNormalKeyEvent(node, event),
        child: SizedBox(
          width: screenWidth,
          height: MediaQuery.of(context).size.height,
          child: Row(
            children: [
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
                          minHeight: MediaQuery.of(context).size.height,
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
                                  const Center(
                                    child: CustomText(
                                      text: "Login",
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Center(
                                    child: Form(
                                      key: loginViewModel.loginFormKey,
                                      child: SizedBox(
                                        width: contentWidth,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomTextField(
                                              height: 46,
                                              name: "Shop ID",
                                              width: contentWidth,
                                              nameColor: primaryColor,
                                              controller:
                                                  loginViewModel
                                                      .shopIdController,
                                              fillColor: Colors.white,
                                              filled: true,
                                              focusNode:
                                                  loginViewModel.shopIdFocus,
                                              validator:
                                                  loginViewModel.validateShopId,
                                              onChanged: (value) {
                                                final capitalizedValue =
                                                    value.toUpperCase();
                                                final currentCursorPosition =
                                                    loginViewModel
                                                        .shopIdController
                                                        .selection
                                                        .baseOffset;
                                                loginViewModel
                                                    .shopIdController
                                                    .value = TextEditingValue(
                                                  text: capitalizedValue,
                                                  selection:
                                                      TextSelection.collapsed(
                                                        offset:
                                                            currentCursorPosition,
                                                      ),
                                                );
                                              },
                                              onEditingComplete:
                                                  () =>
                                                      loginViewModel.userIdFocus
                                                          .requestFocus(),
                                            ),
                                            const SizedBox(height: 24),
                                            CustomTextField(
                                              name: "User ID",
                                              height: 46,
                                              width: contentWidth,
                                              nameColor: primaryColor,
                                              controller:
                                                  loginViewModel
                                                      .userIdController,
                                              fillColor: Colors.white,
                                              filled: true,
                                              focusNode:
                                                  loginViewModel.userIdFocus,
                                              validator:
                                                  loginViewModel.validateUserId,
                                              obscureText: false,
                                              onChanged: (value) {
                                                final capitalizedValue =
                                                    value.toUpperCase();
                                                final currentCursorPosition =
                                                    loginViewModel
                                                        .userIdController
                                                        .selection
                                                        .baseOffset;
                                                loginViewModel
                                                    .userIdController
                                                    .value = TextEditingValue(
                                                  text: capitalizedValue,
                                                  selection:
                                                      TextSelection.collapsed(
                                                        offset:
                                                            currentCursorPosition,
                                                      ),
                                                );
                                              },
                                              onEditingComplete:
                                                  () =>
                                                      loginViewModel.pinFocus
                                                          .requestFocus(),
                                            ),
                                            const SizedBox(height: 24),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const CustomText(
                                                  text: "Enter Pin",
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
                                                              .pinController,
                                                      focusNode:
                                                          loginViewModel
                                                              .pinFocus,
                                                      defaultPinTheme:
                                                          defaultPinTheme,
                                                      focusedPinTheme:
                                                          focusedPinTheme,
                                                      submittedPinTheme:
                                                          submittedPinTheme,
                                                      validator:
                                                          loginViewModel
                                                              .validatePin,
                                                      pinputAutovalidateMode:
                                                          PinputAutovalidateMode
                                                              .onSubmit,
                                                      showCursor: true,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      onCompleted: (pin) {
                                                        if (loginViewModel
                                                            .loginFormKey
                                                            .currentState!
                                                            .validate()) {
                                                          loginViewModel
                                                              .pinController
                                                              .text = pin;
                                                          loginViewModel
                                                              .loginButtonFocus
                                                              .requestFocus();
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 30),
                                            Focus(
                                              focusNode:
                                                  loginViewModel
                                                      .loginButtonFocus,
                                              child: CustomInkButton(
                                                onPressed:
                                                    () =>
                                                        loginViewModel.login(),
                                                text: "Log in",
                                                width: contentWidth,
                                                height: 46,
                                                onKeyEvent: (event) {
                                                  if (event is KeyDownEvent &&
                                                      event.logicalKey ==
                                                          LogicalKeyboardKey
                                                              .enter) {
                                                    loginViewModel.login();
                                                    return KeyEventResult
                                                        .handled;
                                                  }
                                                  return KeyEventResult.ignored;
                                                },
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
      ),
    );
  }
}
