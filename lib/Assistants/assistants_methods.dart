import 'package:bus_tracking_app/Assistants/request_assistant.dart';
import 'package:bus_tracking_app/global/map_key.dart';
import 'package:bus_tracking_app/infoHandler/app_info.dart';
import 'package:bus_tracking_app/models/directions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class AssistantsMethods {
  static Future<String> searchAddressForGeographicCordinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";

    String humanReadableAddress = "";
    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "error occured , failed no response" &&
        requestResponse["results"] != null &&
        requestResponse["results"].isNotEmpty) {
      // Récupérer l'adresse complète si disponible
      var addressComponents =
          requestResponse["results"][0]["address_components"];

      if (addressComponents != null && addressComponents.isNotEmpty) {
        humanReadableAddress = addressComponents
            .map((component) => component["long_name"])
            .join(", ");
      } else {
        humanReadableAddress =
            requestResponse["results"][0]["formatted_address"];
      }

      print("Address found: $humanReadableAddress");

      // Créer un objet Directions
      Directions userPickUpAddress = Directions(
        locationLatitude: position.latitude,
        locationLongitude: position.longitude,
        locationName: humanReadableAddress,
      );

      // Mettre à jour l'adresse de ramassage
      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    } else {
      print("No results found in the API response.");
      humanReadableAddress = "Address not found";
    }

    return humanReadableAddress;
  }
}
