


import 'dart:async';

import 'package:cityone_driver/models/order.dart';
import 'package:cityone_driver/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FirestoreService{




  final CollectionReference _usersCollectionReference =
  FirebaseFirestore.instance.collection('users');


  final StreamController<User> _myUserController =
  StreamController<User>.broadcast();



  final CollectionReference _ordersCollectionReference =
  FirebaseFirestore.instance.collection('trips');

  final StreamController<Order> _tripUniqueController =
  StreamController<Order>.broadcast();

  final StreamController<List<Order>> _orderController =
  StreamController<List<Order>>.broadcast();



  Future createUser(User user) async {
    try {
      await _usersCollectionReference.doc(user.id).set(user.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future updateUser(Map<String, dynamic> data, String id) async {
    try {
      await _usersCollectionReference.doc(id).update(data);
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future updateOrder(Map<String, dynamic> data, String id) async {
    try {
      await _ordersCollectionReference.doc(id).update(data);
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();
      return User.fromJSON(userData.data());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Stream getUserStream(String id) {
    _usersCollectionReference.doc(id).snapshots().listen((userSnapshot) {
      if (userSnapshot.exists) {
        var user = User.fromJSON(userSnapshot.data());
        _myUserController.add(user);
      }
    });
    return _myUserController.stream;
  }

  Stream listenToOrdersRealTime(String id) {
    _ordersCollectionReference.where('professionalId', isEqualTo: id).snapshots().listen((ordersSnapshot) {
      if (ordersSnapshot.docs.isNotEmpty) {
        var orders = ordersSnapshot.docs
            .map((snapshot) => Order.fromJson(snapshot.data(), snapshot.id))
            .toList();
        _orderController.add(orders);
      }
    });
    return _orderController.stream;
  }


  Stream listenToTripIdRealTime(String id) {
    _ordersCollectionReference.doc(id).snapshots().listen((userSnapshot) {
      if (userSnapshot.exists) {
        var user = Order.fromJson(userSnapshot.data(), userSnapshot.id);
        _tripUniqueController.add(user);
      }
    });
    return _tripUniqueController.stream;
  }

}

