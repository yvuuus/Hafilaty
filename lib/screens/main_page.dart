import 'dart:async';
import 'package:bus_tracking_app/Assistants/assistants_methods.dart';
import 'package:bus_tracking_app/Assistants/geofire_assistant.dart';
import 'package:bus_tracking_app/global/global.dart';
import 'package:bus_tracking_app/global/map_key.dart';
import 'package:bus_tracking_app/infoHandler/app_info.dart';
import 'package:bus_tracking_app/models/active_nearby_available_drivers.dart';
import 'package:bus_tracking_app/models/directions.dart';
import 'package:bus_tracking_app/screens/drawer_screen.dart';
import 'package:bus_tracking_app/screens/precise_pickup_location.dart';
import 'package:bus_tracking_app/screens/search_places_screen.dart';
import 'package:bus_tracking_app/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoder2/geocoder2.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  LatLng? pickLocation;
  loc.Location location = loc.Location();
  bool openNavigationDrawer = false;

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

    if (newGoogleMapController != null) {
      newGoogleMapController!
          .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));
    }

    // Add markers for origin and destination
    Marker originMarker = Marker(
      markerId: MarkerId("originId"),
      infoWindow: InfoWindow(title: "Origin", snippet: "Origin Location"),
      position: originLatlng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId("destinationId"),
      infoWindow:
          InfoWindow(title: "Destination", snippet: "Destination Location"),
      position: destinationLatlng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markerset.add(originMarker);
      markerset.add(destinationMarker);
    });

    // Update the UI to show the trip duration
    setState(() {
      tripDuration = directionDetailsInfo.duration_text!;
    });
  }

  String tripDuration = "";

  Future<void> _getUserLocation() async {
    userCurrentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 16);

    if (newGoogleMapController != null) {
      newGoogleMapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    } else {
      print("newGoogleMapController is null");
      Fluttertoast.showToast(msg: "Map controller is not initialized.");
    }

    String humanReadableAddress =
        await AssistantsMethods.searchAddressForGeographicCordinates(
            userCurrentPosition!, context);
    initializeGeoFireListener();
  }

  void initializeGeoFireListener() {
    Geofire.initialize("activeDrivers");

    double radiusInKm = 70.0;

    print(
        "User Current Position: ${userCurrentPosition!.latitude}, ${userCurrentPosition!.longitude}");

    Geofire.queryAtLocation(userCurrentPosition!.latitude,
            userCurrentPosition!.longitude, radiusInKm)!
        .listen((map) async {
      print("GeoFire query result: $map");

      if (map != null) {
        var callBack = map["callBack"];
        print("Callback: $callBack");

        switch (callBack) {
          case Geofire.onKeyEntered:
          case Geofire.onKeyMoved:
            String? driverKey = map["key"];
            if (driverKey != null) {
              DatabaseReference driverRef = FirebaseDatabase.instance
                  .ref()
                  .child("activeDrivers")
                  .child(driverKey);

              driverRef.once().then((DatabaseEvent event) async {
                if (event.snapshot.value != null) {
                  var driverData = event.snapshot.value as Map;
                  if (driverData.containsKey("l")) {
                    var location = driverData["l"];
                    if (location is List && location.length >= 2) {
                      double latitude = location[0];
                      double longitude = location[1];
                      ActiveNearbyAvailableDrivers
                          activeNearbyAvailableDrivers =
                          ActiveNearbyAvailableDrivers();

                      activeNearbyAvailableDrivers.locationLatitude = latitude;
                      activeNearbyAvailableDrivers.locationLongitude =
                          longitude;
                      activeNearbyAvailableDrivers.driverId = driverKey;

                      if (callBack == Geofire.onKeyEntered) {
                        print(
                            "Driver $driverKey found at location: Latitude = $latitude, Longitude = $longitude");
                        GeofireAssistant.activeNearByAvailableDriversList
                            .add(activeNearbyAvailableDrivers);
                      } else {
                        print(
                            "Driver $driverKey moved to new location: Latitude = $latitude, Longitude = $longitude");
                        GeofireAssistant
                            .updateActiveNearByAvailableDriverLocation(
                                activeNearbyAvailableDrivers);
                      }

                      if (activeNearbyDriverKeysLoaded == true) {
                        displayActiveDriversOnUsersMap();
                      }

                      // Draw polyline from driver to origin
                      await drawPolylineFromDriverToOrigin(
                          LatLng(latitude, longitude));
                    } else {
                      print(
                          "Error: Driver location data is missing or invalid");
                    }
                  } else {
                    print("Error: Location key is missing in driver data");
                  }
                } else {
                  print("Error: Driver data snapshot is null");
                }
              }).catchError((error) {
                print("Error fetching driver data: $error");
              });
            }
            break;

          case Geofire.onKeyExited:
            GeofireAssistant.deleteOffLineDriversFRomList(map["key"]);
            displayActiveDriversOnUsersMap();
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

  void displayActiveDriversOnUsersMap() {
    setState(() {
      markerset.clear();
      circleset.clear();
      Set<Marker> driversMarkerSet = Set<Marker>();
      for (ActiveNearbyAvailableDrivers eachDriver
          in GeofireAssistant.activeNearByAvailableDriversList) {
        LatLng eachDriveActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId("driver_${eachDriver.driverId}"),
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

  void createActiveNearByDriverIconMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car.png")
          .then((value) {
        activeNearbyIcon = value;
      });
    }
  }

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

  Future<void> drawPolylineFromDriverToOrigin(LatLng driverLatLng) async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;

    var originLatlng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);

    var directionDetailsInfo =
        await AssistantsMethods.obtainOriginToDestinationDirectionDetails(
            driverLatLng, originLatlng);

    setState(() {
      driverToOriginDuration = directionDetailsInfo.duration_text!;
    });
  }

  String driverToOriginDuration = "";

  @override
  Widget build(BuildContext context) {
    createActiveNearByDriverIconMarker();
    return Scaffold(
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
            myLocationEnabled: true,
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
          ),
          if (userCurrentPosition == null)
            Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => DrawerScreen()));
                },
                child: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 138, 17, 194),
                  radius: 25,
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Temps de trajet : $tripDuration",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 138, 17, 194),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Temps de trajet conducteur à origine : $driverToOriginDuration",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 138, 17, 194),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
        ],
      ),
    );
  }
}
