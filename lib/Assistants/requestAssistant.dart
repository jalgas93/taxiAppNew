import 'package:flutter/material.dart';
import 'package:flutter_taxi/Assistants/request_assistants.dart';
import 'package:flutter_taxi/Models/address_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../DataHandler/app_data.dart';
import '../config_maps.dart';

class AssistantMethods {

  static Future<String> searchCoordinatAddress(Position position, context) async {
    String placeAddress = "";
    String  st2, st3, st4;
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyCH8zo6SwEW8W8sMNBUxcYRaF2Q9UQSh70';

    var responce = await RequestAssistants.getRequest(url);

    if (responce != 'failes') {

     // placeAddress = responce["results"][0]["address_components"];

      st2 = responce["results"][0]["address_components"][2]["long_name"];
     st3 = responce["results"][0]["address_components"][3]["long_name"];
     st4 = responce["results"][0]["address_components"][4]["long_name"];
     //st4 = responce["results"][0]["address_components"][5]["long_name"];
     placeAddress =  st3 + "," + st2 ;

      print('jalgasAddress:${placeAddress}');

      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }
}
