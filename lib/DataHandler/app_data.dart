


import 'package:flutter/cupertino.dart';
import 'package:flutter_taxi/Models/address_location.dart';

class AppData extends ChangeNotifier{

  Address pickUpLocation;


void updatePickUpLocationAddress(Address pickUpAddress){
  pickUpLocation = pickUpAddress;
  notifyListeners();
}
}