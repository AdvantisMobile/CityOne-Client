
import 'dart:async';

import 'package:cityone_driver/const/route_names.dart';
import 'package:cityone_driver/repository/settings_repository.dart' as settingRepo;
import 'package:cityone_driver/repository/user_repository.dart' as userRepo;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController{
  ValueNotifier<Map<String, double>> progress = new ValueNotifier(new Map());
  GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void onInit() {
    settingRepo.setting.addListener(() {
      if (settingRepo.setting.value.appName != null && settingRepo.setting.value.appName != '' && settingRepo.setting.value.mainColor != null) {
        progress.value["Setting"] = 70;
        progress?.notifyListeners();
      }
    });
    userRepo.currentUser.addListener(() {
      if (userRepo.currentUser.value.auth != null) {
        progress.value["User"] = 30;
        progress?.notifyListeners();
      }
    });
    userRepo.getCurrentUser();
    Timer(Duration(seconds: 20), () {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text('No hay conexión de internet'),
      ));
    });
    super.onInit();
  }


  @override
  void onClose() {
    super.onClose();

    print('dispose');
    settingRepo.setting.removeListener(() { });
    userRepo.currentUser.removeListener(() { });
    progress.removeListener(() { });
  }

  @override
  void onReady() {
    print('ready');
    loadData();
    super.onReady();
  }
  @override
  void onStart() {
    print('start');
    progress.value = {"Setting": 0, "User": 0, "DeliveryAddress": 0};
    super.onStart();
  }


  void loadData() {
    progress.addListener(() {
      double progressState = 0;
      progress.value.values.forEach((_progress) {
        print(_progress);
        progressState += _progress;
      });
      if (progressState == 100) {
        try {
          if (userRepo.currentUser.value.apiToken == null) {
            Get.offNamed(LoginViewRoute);
          } else {
            Get.offNamed(ConductorPagesViewRoute, arguments: 1);
          }
        } catch (e) {}
      }
    });
  }



}