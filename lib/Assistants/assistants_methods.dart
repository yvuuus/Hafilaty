import "package:bus_tracking_app/Assistants/request_assistant.dart";
import "package:bus_tracking_app/global/map_key.dart";
import "package:bus_tracking_app/models/directions.dart";
import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import 'package:location/location.dart' as loc;

class AssistantsMethods {
  static Future<String> searchAddressForGeographicCordinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?Latlng=${position.latitude},${position.longitude}&key=$mapkey";

    String humanReadableAddress = "";
    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "error occured , failed no response") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongititude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;
    }

    return humanReadableAddress;
  }
}
