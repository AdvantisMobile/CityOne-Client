import 'package:cityone_driver/models/user.dart';

enum StatusOrder {
  Initial,
  PaymentDriveSuccess,
  PaymentDriveFailed,
  Come,
  InDrive,
  Arrive,
  Cancel,
  CancelProfessional,
  ExpireTime
}


class Order {
  String id;
  double total;
  String professionalId;
  double kilometres;
  String type;
  double amountProduct;
  String product;
  String description;
  AddressesTrip pickLocation;
  AddressesTrip dropLocation;
  User user;
  String status;
  dynamic createdAt;

  Order(
      {this.id,
        this.total,
        this.professionalId,
        this.kilometres,
        this.type,
        this.amountProduct,
        this.product,
        this.description,
        this.pickLocation,
        this.dropLocation,
        this.user,
        this.status,
        this.createdAt,
      });

  Order.fromJson(Map<String, dynamic> json, String uid) {
    id = uid ?? '';
    total = json['total'];
    professionalId = json['professionalId'];
    kilometres = json['kilometres'];
    type = json['type'];
    amountProduct = json['amount_product'];
    product = json['product'];
    description = json['description'];
    status = json['status'];
    pickLocation = json['pick_location'] != null
        ? new AddressesTrip.fromJson(json['pick_location'])
        : null;
    dropLocation = json['drop_location'] != null
        ? new AddressesTrip.fromJson(json['drop_location'])
        : null;
    user = json['user'] != null
        ? new User.fromJSON(json['user'])
        : null;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
   // data['id'] = this.id;
    data['total'] = this.total;
    data['professionalId'] = this.professionalId;
    data['kilometres'] = this.kilometres;
    data['type'] = this.type;
    data['amount_product'] = this.amountProduct;
    data['product'] = this.product;
    data['description'] = this.description;
    if (this.pickLocation != null) {
      data['pick_location'] = this.pickLocation.toJson();
    }
    if (this.dropLocation != null) {
      data['drop_location'] = this.dropLocation.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.toMapFirebase();
    }
    data['createdAt'] = this.createdAt;

    return data;
  }
}

class PickLocation {
  double latitude;
  double longitude;

  PickLocation({this.latitude, this.longitude});

  PickLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class AddressesTrip {
  String address;
  double lat;
  double lng;

  AddressesTrip({this.address, this.lat, this.lng});

  AddressesTrip.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}