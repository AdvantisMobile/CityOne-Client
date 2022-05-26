import 'package:cityone_driver/repository/user_repository.dart'
    as userRepository;
import 'package:cityone_driver/models/order.dart';
import 'package:cityone_driver/services/firestore_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../locator.dart';

class TransactionController extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  Order _trip;
  Order get trip => _trip;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    listenToTrip();
  }

  void listenToTrip() {
    _firestoreService.listenToTripIdRealTime(Get.arguments).listen((tripData) {
      Order updatedTrips = tripData;
      if (updatedTrips != null) {
        _trip = updatedTrips;
        update();
      }
    });
  }

  Future changeStatus(String status) async {
    await updateTrip({'status': status}, _trip.id);
  }

  Future finishTrip(String status) async {
    await _firestoreService.updateUser({'busy': true}, _trip.professionalId);
    await updateTrip({'status': status}, _trip.id);
  }

  Future updateTrip(Map<String, dynamic> data, String id) async {
    try {
      return await _firestoreService.updateOrder(data, id);
    } catch (e) {
      if (e is PlatformException) {
        print(e);
        return e.message;
      }

      return e.toString();
    }
  }

  void goFromLocation() {
    print(_trip.pickLocation.toJson());

    MapsLauncher.launchCoordinates(
        _trip.pickLocation.lat, _trip.pickLocation.lng);
  }

  void goToLocation() {
    MapsLauncher.launchCoordinates(
        _trip.dropLocation.lat, _trip.dropLocation.lng);
  }
}
