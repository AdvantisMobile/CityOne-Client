
import 'package:cityone_driver/const/route_names.dart';
import 'package:cityone_driver/ui/views/conductor_pages.dart';
import 'package:cityone_driver/ui/views/login_view.dart';
import 'package:cityone_driver/ui/views/register_view.dart';
import 'package:cityone_driver/ui/views/splash_view.dart';
import 'package:cityone_driver/ui/views/transaction_view.dart';
import 'package:get/route_manager.dart';


class RoutePages {
  RoutePages._(); //this is to prevent anyone from instantiating this object
  static final routes = [
    GetPage(name: LoginViewRoute, page: () => LoginView()),
    GetPage(name: SplashViewRoute, page: () => SplashView()),
    GetPage(name: RegisterViewRoute, page: () => RegisterView()),
    GetPage(name: ConductorPagesViewRoute, page: () => ConductorPages()),
    GetPage(name: TransactionViewRoute, page: () => TransactionView()),

  ];
}