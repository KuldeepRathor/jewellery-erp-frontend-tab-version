import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:jewellery_erp_frontend_tab_version/base/logging/talker_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_dio_client.dart';
import 'package:jewellery_erp_frontend_tab_version/base/controllers/token_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/base/controllers/user_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/auth/view/login_screen.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/home_page.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_theme.dart';
import 'package:jewellery_erp_frontend_tab_version/res/getx_loclization/languages.dart';
// import 'package:jewellery_erp_frontend_tab_version/base/talker_controller.dart';
// import 'package:jewellery_erp_frontend_tab_version/services/remote_config_service.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:toastification/toastification.dart';
import 'utils/role_based_permission/rbac_controller.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() {
  runZonedGuarded(
    () async {
      // WidgetsFlutterBinding.ensureInitialized();

      // Initialize MediaKit
      MediaKit.ensureInitialized();

      // Initialize Talker and controllers
      final talker = TalkerFlutter.init();
      Get.put(TalkerController(talker));
      Get.put(HttpDioClient());
      Get.put(TokenController());
      Get.put(RBACController());
      Get.put(UserController());

      // Load saved token
      await Get.find<TokenController>().loadSavedToken();
      // await Firebase.initializeApp(
      //   options: DefaultFirebaseOptions.currentPlatform,
      // );

      // Initialize Remote Config
      // await RemoteConfigService.instance.initialize();

      runApp(MyApp(talker: talker));
    },
    (error, stack) {
      // Now TalkerController is guaranteed to exist
      try {
        final talkerController = Get.find<TalkerController>();
        talkerController.talker.handle(error, stack, 'Uncaught app exception');
      } catch (e) {
        // Fallback if TalkerController is somehow not available
        log('Critical error: $error\n$stack');
      }
    },
  );
}

class MyApp extends StatelessWidget {
  final Talker talker;
  const MyApp({super.key, required this.talker});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        title: 'Zivoro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        translations: Languages(),
        locale: const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        // localizationsDelegates: const [
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        //   FlutterQuillLocalizations.delegate,
        // ],
        supportedLocales: const [
          Locale('en', 'US'),
          // Add more locales as needed
        ],
        home: const SplashScreen(),
        builder: (context, child) {
          return TalkerWrapper(
            talker: talker,
            options: const TalkerWrapperOptions(enableErrorAlerts: true),
            child: child!,
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _handleAuthCheck(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Future<void> _handleAuthCheck() async {
    final tokenController = Get.find<TokenController>();

    await Future.delayed(const Duration(milliseconds: 500));

    final token = tokenController.token;

    if (token != null && token.isNotEmpty) {
      try {
        // RBACController is already registered in main()
        // Wait for permissions to be loaded
        await Get.find<RBACController>().extractPermissionsFromToken();
        Get.offAll(() => const HomePage());
      } catch (e) {
        // Log the error
        Get.find<TalkerController>().handleError(
          'Auth check failed',
          e,
          StackTrace.current,
        );
        await tokenController.clearToken();
        Get.offAll(() => const LoginScreen());
      }
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }
}
