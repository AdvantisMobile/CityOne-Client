
import 'package:cityone_driver/locator.dart';
import 'package:cityone_driver/models/order.dart';
import 'package:cityone_driver/models/user.dart';
import 'package:cityone_driver/repository/user_repository.dart' as userRepository;
import 'package:cityone_driver/services/background_locator_services.dart';
import 'package:cityone_driver/services/firestore_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:location_permissions/location_permissions.dart';

class OrdersConductorController extends GetxController{

  final FirestoreService _firestoreService =
  locator<FirestoreService>();


  final BackgroundLocatorServices _backgroundLocatorServices =
  locator<BackgroundLocatorServices>();



  Rx<User> userFirebase = new User().obs;

  List<Order> _orders;
  List<Order> get orders => _orders;


  @override
  void onStart() {
    listenUser();
    listenToTrips();
    super.onStart();
  }


  void listenUser() {
    _firestoreService.getUserStream(userRepository.currentUser.value.id).listen((userData)  {
      User updateUser = userData;
      if(updateUser != null){
        userFirebase.value = updateUser;
      }
    });
  }

  void listenToTrips() {
    _firestoreService.listenToOrdersRealTime(userRepository.currentUser.value.id).listen((orderData)  {
      List<Order> updateOrder = orderData;
      if(updateOrder != null && updateOrder.length > 0){
        updateOrder.forEach((element) {
          if(element.status == 'Initial' ||
              element.status == 'PaymentDriveSuccess' ||
              element.status == 'PaymentDriveFailed' ||
              element.status == 'Come' ||
              element.status == 'InDrive'
          ){
            _orders = updateOrder;
          }
        });
        update(['listOrder'])
        ;
      }
    });
  }


  Future<void> changeTurn() async{
    if(userFirebase.value.turn){
      await updateProfile({
        'turn' : false
      });
      _backgroundLocatorServices.stopLocator();

    }else{
      PermissionStatus permissionStatus = await LocationPermissions().checkPermissionStatus();
      if(permissionStatus == PermissionStatus.granted){
        _backgroundLocatorServices.startLocationService();
        await updateProfile({
          'turn' : true
        });
      }else{
        PermissionStatus permission = await LocationPermissions().requestPermissions();

        if(permission != PermissionStatus.granted){
          Get.snackbar('Error', 'Necesitas habilitar los permisos de ubicación');
        }else{
          _backgroundLocatorServices.startLocationService();
          await updateProfile({
            'turn' : true
          });
        }
      }
    }
  }



  Future updateProfile(Map<String, dynamic> data) async {
    try {
      return await _firestoreService.updateUser(data, userRepository.currentUser.value.id);
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

}