import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/res/routes/routes_name.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/home_page.dart';

class AppRoutes {
  static appRoutes() => [
    GetPage(
      name: RouteName.homePage,
      page: () => const HomePage(),
      transitionDuration: const Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
  ];
}
