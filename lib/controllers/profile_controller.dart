


import 'package:cityone_driver/const/route_names.dart';
import 'package:cityone_driver/locator.dart';
import 'package:cityone_driver/models/user.dart';
import 'package:cityone_driver/repository/user_repository.dart' as repository;
import 'package:cityone_driver/services/background_locator_services.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController{
  final BackgroundLocatorServices _backgroundLocatorServices =
  locator<BackgroundLocatorServices>();


  User _user = new User();
  User get user => _user;
  @override
  void onInit() {
    refreshProfile();
    super.onInit();
  }

  void listenForUser() {
    repository.getCurrentUser().then((userV) {
        _user = userV;
        update();
    });
  }


  Future<void> refreshProfile() async {
    _user = new User();
    listenForUser();
  }

  Future salir() async{
    await _backgroundLocatorServices.stopLocator();
    await repository.logout();
    Get.offNamed(LoginViewRoute);
  }

}