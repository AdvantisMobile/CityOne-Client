


import 'package:cityone_driver/const/route_names.dart';
import 'package:cityone_driver/models/user.dart';
import 'package:cityone_driver/models/vehicle.dart';
import 'package:cityone_driver/repository/vehicles_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cityone_driver/repository/user_repository.dart' as repository;

class RegisterController extends GetxController{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseMessaging _firebaseMessaging;

  GlobalKey<FormState> registerFormKey = GlobalKey();
  User user = new User();
  RxBool hidePassword = true.obs;
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Vehicle> vehicles = [];


  @override
  void onStart() {
   user.role = 'uber';
   listenForVehicles('uber');
   _firebaseMessaging = FirebaseMessaging();
   _firebaseMessaging.getToken().then((String _deviceToken) {
     user.deviceToken = _deviceToken;
   });

   update();
    super.onStart();
  }


  void changeHidePassword() {
    hidePassword.value = !hidePassword.value;
  }

  Future<void> listenForVehicles(String role) async {
    vehicles = [];
    final Stream<Vehicle> stream = await getVehicles();
    stream.listen((Vehicle _vehicle) {
      if (_vehicle.role == role) {
        vehicles.add(_vehicle);
        print(_vehicle);
        update();
      }
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }



  void register() async {
    if (registerFormKey.currentState.validate() && user.role != null && user.typeId != null) {
      registerFormKey.currentState.save();
      repository.register(user).then((value) {
        if (value != null && value.apiToken != null) {
          _db.collection('users').doc(value.id).set(value.toMapFirebase()).then((val) {
            Get.snackbar('Bienvenido', value.name);
            Get.offAndToNamed(ConductorPagesViewRoute, arguments: 1);
          });
        } else {
          Get.snackbar('Error', 'Error de usuario y contraseña');
        }
      });
    }
  }


  void changeRole(String role){
    user.role = role;
    user.typeId = null;
    listenForVehicles(role);
    update();
  }


  void changeVehicle(int value) {
    user.typeId = value;
    update();
  }
}