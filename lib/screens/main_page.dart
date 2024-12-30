import "dart:async";
import "package:bus_tracking_app/Assistants/assistants_methods.dart";
import "package:bus_tracking_app/global/map_key.dart";
import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import 'package:location/location.dart' as loc;
import 'package:geocoder2/geocoder2.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  LatLng? pickLocation;
  loc.Location location = loc.Location();
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15,
  );

  GoogleMapController? newGoogleMapController;

  double bottomPaddingOfMap = 0;
  Position? userCurrentPosition;
  bool locationServiceEnabled = false;
  LocationPermission? locationPermission;

  Set<Marker> markerset = {};
  Set<Circle> circleset = {};
  Set<Polyline> polylineset = {};

  String? _address = "";

  @override
  void initState() {
    super.initState();
    _checkLocationPermissions();
  }

  // Vérifier si les permissions de localisation sont accordées
  Future<void> _checkLocationPermissions() async {
    locationServiceEnabled = await location.serviceEnabled();
    if (!locationServiceEnabled) {
      locationServiceEnabled = await location.requestService();
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }

    if (locationPermission == LocationPermission.deniedForever) {
      // Demander à l'utilisateur d'activer la localisation
      _showLocationPermissionDialog();
    } else {
      _getUserLocation();
    }
  }

  // Récupérer la position actuelle de l'utilisateur
  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userCurrentPosition = position;
      pickLocation = LatLng(position.latitude, position.longitude);
    });

    print("User position: ${position.latitude}, ${position.longitude}");

    // Déplacer la caméra
    GoogleMapController controller = await _controllerGoogleMap.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.0,
    )));

    // Récupérer l'adresse
    String humanReadableAddress =
        await AssistantsMethods.searchAddressForGeographicCordinates(
            position, context);

    setState(() {
      _address =
          humanReadableAddress; // Mise à jour de l'adresse pour l'affichage
    });

    print("this is our address = $humanReadableAddress");
  }

  //fonction pour l'adresse
  Future<void> getAddressFromLatlng() async {
    if (userCurrentPosition != null) {
      try {
        // Utilisation de l'API géocode de Google pour obtenir l'adresse la plus complète
        String humanReadableAddress =
            await AssistantsMethods.searchAddressForGeographicCordinates(
                userCurrentPosition!,
                context); // Utiliser userCurrentPosition ici

        setState(() {
          _address = humanReadableAddress;
        });

        print("Fetched address: $_address"); // Afficher dans les logs
      } catch (e) {
        print("Error fetching address: $e");
      }
    } else {
      print("User position is null.");
    }
  }

  // Afficher une boîte de dialogue pour demander l'activation de la localisation
  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission de localisation nécessaire'),
          content: Text(
              'Veuillez activer la localisation dans les paramètres de votre appareil pour utiliser cette fonctionnalité.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE1BEE7),
        title: Text('Map Screen'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) async {
              await Future.delayed(Duration(milliseconds: 300));
              _controllerGoogleMap.complete(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            markers: markerset,
            circles: circleset,
            polylines: polylineset,
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            onCameraMove: (CameraPosition position) {},
            onCameraIdle: () {
              getAddressFromLatlng(); // Récupérer l'adresse après chaque mouvement de caméra
            },
          ),
          // Afficher un indicateur de position lorsque la position est en cours de récupération
          if (userCurrentPosition == null)
            Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            top: 40,
            right: 20,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromARGB(255, 252, 249, 249),
              ),
              padding: EdgeInsets.all(20),
              child: Text(
                _address ?? "Set your pickuplocation",
                overflow: TextOverflow.visible,
                softWrap: true,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 19, 15, 15)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
