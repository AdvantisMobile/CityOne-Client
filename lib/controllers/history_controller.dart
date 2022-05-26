


import 'package:cityone_driver/locator.dart';
import 'package:cityone_driver/models/order.dart';
import 'package:cityone_driver/repository/user_repository.dart' as userRepository;
import 'package:cityone_driver/services/firestore_service.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController{

  final FirestoreService _firestoreService =
  locator<FirestoreService>();

  List<Order> _orders;
  List<Order> get orders => _orders;


  @override
  void onStart() {
    listenToTrips();
    super.onStart();
  }

  void listenToTrips() {
    _firestoreService.listenToOrdersRealTime(userRepository.currentUser.value.id).listen((orderData)  {
      List<Order> updateOrder = orderData;
      if(updateOrder != null && updateOrder.length > 0){
        _orders = updateOrder;
        update(['listHistory'])
        ;
      }
    });
  }

}