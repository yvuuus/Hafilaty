// ignore_for_file: use_build_context_synchronously, sort_child_properties_last

import "dart:async";
import "package:bus_tracking_app/Assistants/assistants_methods.dart";
import "package:bus_tracking_app/Assistants/geofire_assistant.dart";
import "package:bus_tracking_app/global/global.dart";
import "package:bus_tracking_app/global/map_key.dart";
import "package:bus_tracking_app/infoHandler/app_info.dart";
import "package:bus_tracking_app/models/active_nearby_available_drivers.dart";
import "package:bus_tracking_app/models/directions.dart";
import "package:bus_tracking_app/screens/drawer_screen.dart";
import "package:bus_tracking_app/screens/precise_pickup_location.dart";
import "package:bus_tracking_app/screens/search_places_screen.dart";
import "package:bus_tracking_app/widgets/progress_dialog.dart";
import "package:flutter/material.dart";
import "package:flutter_geofire/flutter_geofire.dart";
import "package:geolocator/geolocator.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import 'package:location/location.dart' as loc;
import 'package:geocoder2/geocoder2.dart';
import "package:provider/provider.dart";
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  LatLng? pickLocation;
  loc.Location location = loc.Location();
  bool openNavigationDrawer = false; // Ajouter ceci au début de votre classe

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15,
  );
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  GoogleMapController? newGoogleMapController;

  double bottomPaddingOfMap = 0;
  Position? userCurrentPosition;
  bool locationServiceEnabled = false;
  LocationPermission? locationPermission;

  Set<Marker> markerset = {};
  Set<Circle> circleset = {};
  Set<Polyline> polyLineSet = {};
  List<LatLng> pLineCoordinatedList = [];

  bool activeNearbyDriverKeysLoaded = false;
  bool requestPositionInfo = true;
  BitmapDescriptor? activeNearbyIcon;

  String? _address;

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

  Future<void> drawPolylineFromOriginToDestination() async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatlng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);

    var destinationLatlng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "please wait ...",
            ));

    var directionDetailsInfo =
        await AssistantsMethods.obtainOriginToDestinationDirectionDetails(
            originLatlng, destinationLatlng);

    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });
    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();

    List<PointLatLng> decodePolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo.e_points!);

    pLineCoordinatedList.clear();

    if (decodePolyLinePointsResultList.isNotEmpty) {
      decodePolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoordinatedList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.blue,
        polylineId: PolylineId("PolylineId"),
        jointType: JointType.round,
        points: pLineCoordinatedList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        width: 5,
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;

    if (originLatlng.latitude > destinationLatlng.latitude &&
        originLatlng.longitude > destinationLatlng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatlng, northeast: originLatlng);
    } else if (originLatlng.longitude > destinationLatlng.longitude) {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(originLatlng.latitude, destinationLatlng.longitude),
          northeast:
              LatLng(destinationLatlng.latitude, originLatlng.longitude));
    } else if (originLatlng.latitude > destinationLatlng.latitude) {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(destinationLatlng.latitude, originLatlng.longitude),
          northeast:
              LatLng(originLatlng.latitude, destinationLatlng.longitude));
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatlng, northeast: destinationLatlng);
    }

    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker destinationMarker = Marker(
      markerId: MarkerId("destinationId"),
      infoWindow: InfoWindow(
          title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatlng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    Marker originMarker = Marker(
      markerId: MarkerId("originId"),
      infoWindow:
          InfoWindow(title: originPosition.locationName, snippet: "Origin"),
      position: originLatlng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markerset.add(originMarker);
      markerset.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: CircleId("originId"),
      fillColor: Colors.blue,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatlng,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId("destinationId"),
      fillColor: Colors.blue,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatlng,
    );

    setState(() {
      circleset.add(originCircle);
      circleset.add(destinationCircle);
    });
  }

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
    initializeGeoFireListener();
  }

  void initializeGeoFireListener() {
    Geofire.initialize("activeDrivers");

    double radiusInKm = 70.0; // Rayon en kilomètres

    // Affiche les coordonnées de l'utilisateur pour vérifier
    print(
        "User Current Position: ${userCurrentPosition!.latitude}, ${userCurrentPosition!.longitude}");

    Geofire.queryAtLocation(userCurrentPosition!.latitude,
            userCurrentPosition!.longitude, radiusInKm)!
        .listen((map) {
      print("GeoFire query result: $map");

      if (map != null) {
        var callBack = map["callBack"];
        print("Callback: $callBack");

        switch (callBack) {
          case Geofire.onKeyEntered:
            // Accède directement à l'attribut "l" qui contient le tableau de latitude et longitude
            var driverData = map["l"];

            // Vérifie si les données existent et sont un tableau valide
            if (driverData != null &&
                driverData is List &&
                driverData.length >= 2) {
              double latitude = driverData[0];
              double longitude = driverData[1];
              ActiveNearbyAvailableDrivers activeNearbyAvailableDrivers =
                  ActiveNearbyAvailableDrivers();

              // Assigne les coordonnées
              activeNearbyAvailableDrivers.locationLatitude = latitude;
              activeNearbyAvailableDrivers.locationLongitude = longitude;
              activeNearbyAvailableDrivers.driverId = map["key"];

              print(
                  "Driver ${map["key"]} found at location: Latitude = $latitude, Longitude = $longitude");

              GeofireAssistant.activeNearByAvailableDriversList
                  .add(activeNearbyAvailableDrivers);

              if (activeNearbyDriverKeysLoaded == true) {
                displayActiveDriversOnUsersMap();
              }
            } else {
              print("Error: Driver location data is missing or invalid");
            }
            break;

          case Geofire.onKeyExited:
            GeofireAssistant.deleteOffLineDriversFRomList(map["key"]);
            displayActiveDriversOnUsersMap();
            break;

          case Geofire.onKeyMoved:
            var driverData = map["l"];
            if (driverData != null &&
                driverData is List &&
                driverData.length >= 2) {
              double latitude = driverData[0];
              double longitude = driverData[1];
              ActiveNearbyAvailableDrivers activeNearbyAvailableDrivers =
                  ActiveNearbyAvailableDrivers();

              // Assigne les coordonnées mises à jour
              activeNearbyAvailableDrivers.locationLatitude = latitude;
              activeNearbyAvailableDrivers.locationLongitude = longitude;
              activeNearbyAvailableDrivers.driverId = map["key"];

              print(
                  "Driver ${map["key"]} moved to new location: Latitude = $latitude, Longitude = $longitude");

              GeofireAssistant.updateActiveNearByAvailableDriverLocation(
                  activeNearbyAvailableDrivers);

              displayActiveDriversOnUsersMap();
            } else {
              print("Error: Moved driver location data is missing or invalid");
            }
            break;

          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeysLoaded = true;
            print("Geo query is ready, no more updates expected");
            displayActiveDriversOnUsersMap();
            break;
        }
      }

      setState(() {});
    });
  }

  displayActiveDriversOnUsersMap() {
    setState(() {
      markerset.clear();
      circleset.clear();
      Set<Marker> driversMarkerSet = Set<Marker>();
      for (ActiveNearbyAvailableDrivers eachDriver
          in GeofireAssistant.activeNearByAvailableDriversList) {
        LatLng eachDriveActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId(" driver 1"),
          position: eachDriveActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        driversMarkerSet.add(marker);
      }
      setState(() {
        markerset = driversMarkerSet;
      });
    });
  }

  createActiveNearByDriverIconMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car.png")
          .then((value) {
        activeNearbyIcon = value;
      });
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
    createActiveNearByDriverIconMarker();
    return Scaffold(
      //key: _scaffoldState,
      //drawer: DrawerScreen(),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 138, 17, 194),
        title: Text(
          'Map Screen',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
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
            myLocationEnabled: true, // Désactive le marqueur par défaut
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            markers: markerset,
            circles: circleset,
            polylines: polyLineSet,
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),

            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 200;
              });
              _getUserLocation();
            },

            //onCameraMove: (CameraPosition? position) {
            // if (pickLocation != position!.target) {
            //  setState(() {
            //   pickLocation = position.target;
            // });
            //}
            //},
            /* onCameraIdle: () {
              getAddressFromLatlng(); // Récupérer l'adresse après chaque mouvement de la caméra
            },*/
          ),
          // Afficher un indicateur de position lorsque la position est en cours de récupération
          if (userCurrentPosition == null)
            Center(
              child: CircularProgressIndicator(),
            ),
          // Custom profile button for drawer
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) =>
                              DrawerScreen())); // Naviguer vers la page du profil
                },
                child: CircleAvatar(
                  backgroundColor: Color.fromARGB(
                      255, 138, 17, 194), // Couleur de fond du profil
                  radius: 25, // Taille de l'avatar
                  child: Icon(
                    Icons.account_circle, // Icône de profil
                    color: Colors.white, // Couleur de l'icône
                    size: 30, // Taille de l'icône
                  ),
                ),
              ),
            ),
          ),

          //Ui for searching location
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Color.fromARGB(255, 138, 17, 194),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "from ",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 138, 17, 194),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                            Provider.of<AppInfo>(context)
                                                        .userPickUpLocation !=
                                                    null
                                                ? Provider.of<AppInfo>(context)
                                                        .userPickUpLocation!
                                                        .locationName!
                                                        .substring(0, 24) +
                                                    "..."
                                                : "No Address found",
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                height: 1,
                                thickness: 2,
                                color: Color.fromARGB(255, 138, 17, 194),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () async {
                                    //go to search places screen
                                    var responseFromSearchScreen =
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (c) =>
                                                    SearchPlacesScreen()));
                                    if (responseFromSearchScreen ==
                                        "obtainedDropoff ") {
                                      setState(() {
                                        openNavigationDrawer = false;
                                      });
                                    }

                                    await drawPolylineFromOriginToDestination();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color:
                                            Color.fromARGB(255, 138, 17, 194),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "To",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 138, 17, 194),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            Provider.of<AppInfo>(context)
                                                        .userDropOffLocation !=
                                                    null
                                                ? Provider.of<AppInfo>(context)
                                                    .userDropOffLocation!
                                                    .locationName!
                                                : "Where to?",
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 14),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            PrecisePickupLocation()));
                              },
                              child: Text(
                                "Change PickUp",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 138, 17, 194),
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
          //Positioned(
          // top: 40,
          //right: 20,
          //left: 20,
          //child: Container(
          // decoration: BoxDecoration(
          //  border: Border.all(color: Colors.black),
          //  color: const Color.fromARGB(255, 252, 249, 249),
          //),
          //padding: EdgeInsets.all(20),
          //child: Text(
          // _address != null
          //   ? (_address!.length > 24
          //       ? _address!.substring(0, 24) + "..."
          //      : _address!)
          // : "Not Getting Address ",
          // overflow: TextOverflow.visible,
          // softWrap: true,
          //style: TextStyle(
          //    fontSize: 16,
          //    fontWeight: FontWeight.bold,
          //    color: Color.fromARGB(255, 19, 15, 15)),
          // ),
          //),
          // ),
        ],
      ),
    );
  }
}
