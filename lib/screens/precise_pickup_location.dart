import 'dart:async';

import 'package:bus_tracking_app/Assistants/assistants_methods.dart';
import 'package:bus_tracking_app/global/map_key.dart';
import 'package:bus_tracking_app/infoHandler/app_info.dart';
import 'package:bus_tracking_app/models/directions.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';

class PrecisePickupLocation extends StatefulWidget {
  const PrecisePickupLocation({super.key});

  @override
  State<PrecisePickupLocation> createState() => _PrecisePickupLocationState();
}

class _PrecisePickupLocationState extends State<PrecisePickupLocation> {
  LatLng? pickLocation;
  loc.Location location = loc.Location();
  bool openNavigationDrawer = false; // Ajouter ceci au début de votre classe
  String _address = "";

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  Position? userCurrentPosition;
  double bottomPaddingOfMap = 0;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15,
  );

  // Récupérer la position actuelle de l'utilisateur
  Future<void> _getUserLocation() async {
    userCurrentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 16);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    //userName = currentUserInfo!.name!;
    String humanReadableAddress =
        await AssistantsMethods.searchAddressForGeographicCordinates(
            userCurrentPosition!, context);
  }

  // Fonction pour récupérer l'adresse en fonction des coordonnées lat/long
  Future<void> getAddressFromLatlng() async {
    if (userCurrentPosition != null) {
      try {
        GeoData data = await Geocoder2.getDataFromCoordinates(
            latitude: pickLocation!.latitude,
            longitude: pickLocation!.longitude,
            googleMapApiKey: mapkey);

        setState(() {
          Directions userPickUpAddress = Directions();
          userPickUpAddress.locationLatitude = pickLocation!.latitude;
          userPickUpAddress.locationLongitude = pickLocation!.longitude;
          userPickUpAddress.locationName = data.address;

          Provider.of<AppInfo>(context, listen: false)
              .updatePickUpLocationAddress(userPickUpAddress);
          // _address = humanReadableAddress;
        });

        print("Fetched address: $_address"); // Afficher dans les logs
      } catch (e) {
        print("Error fetching address: $e");
      }
    } else {
      print("User position is null.");
    }
  }

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true, // Désactive le marqueur par défaut
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),

            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 100;
              });
              _getUserLocation();
            },

            onCameraMove: (CameraPosition? position) {
              if (pickLocation != position!.target) {
                setState(() {
                  pickLocation = position.target;
                });
              }
            },

            onCameraIdle: () {
              getAddressFromLatlng(); // Récupérer l'adresse après chaque mouvement de la caméra
            },
          ),
          // Afficher un indicateur de position lorsque la position est en cours de récupération
          if (userCurrentPosition == null)
            Center(
              child: CircularProgressIndicator(),
            ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
              child: Image.asset(
                "images/pick.png",
                height: 45,
                width: 45,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black), // Bordure noire
                color: Colors.white, // Couleur de fond blanche
              ),
              padding: EdgeInsets.all(20),
              child: Text(
                Provider.of<AppInfo>(context).userPickUpLocation != null
                    ? (Provider.of<AppInfo>(context)
                        .userPickUpLocation!
                        .locationName!)
                    : "Not Getting Address",
                style: TextStyle(
                  color: Colors.black, // Texte noir
                  fontSize: 16, // Optionnel : taille du texte
                ),
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 138, 17, 194),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    )),
                child: Text(
                  "Set Current Location",
                  style: TextStyle(
                    color: Colors.white, // Définit la couleur du texte en blanc
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
