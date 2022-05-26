

import 'package:cityone_driver/locator.dart';
import 'package:cityone_driver/models/user.dart';
import 'package:cityone_driver/services/firestore_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cityone_driver/repository/user_repository.dart' as repository;

class LoginController extends GetxController{
  User user = new User();
  final FirestoreService _firestoreService =
  locator<FirestoreService>();

  RxBool hidePassword = true.obs;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging _firebaseMessaging;

  @override
  void onStart() {
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      user.deviceToken = _deviceToken;
    });
    update();
    super.onStart();
  }


  void login() async {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      repository.login(user).then((value) async {
        //print(value.apiToken);
        await _firestoreService.updateUser(value.toMapFirebase(), value.id);
        if (value != null && value.apiToken != null) {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text('bienvenido' + value.name),
          ));
          Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Pages', arguments: 1);
        } else {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text('Verifique su usuario o contraseña'),
          ));
        }
      });
    }
  }


  void changeHidePassword() {
    hidePassword.value = !hidePassword.value;
  }
}