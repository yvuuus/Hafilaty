import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Ajout de la dépendance geocoding

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentLocation;
  late MapController _mapController;
  bool _isLocationReady = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permission denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission permanently denied')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _isLocationReady = true;
    });

    if (_currentLocation != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(
            _currentLocation!, 15.0); // Centre et zoom sur la position
      });
    }
  }

  // Fonction pour rechercher un endroit et centrer la carte sur cet endroit
  Future<void> _searchLocation() async {
    String address = _searchController.text;
    if (address.isNotEmpty) {
      try {
        // Utilisation de l'API Geocoding pour obtenir les coordonnées
        List<Location> locations = await locationFromAddress(address);
        if (locations.isNotEmpty) {
          // On obtient la première correspondance
          LatLng newLocation =
              LatLng(locations[0].latitude, locations[0].longitude);
          setState(() {
            _currentLocation = newLocation;
            _mapController.move(newLocation, 15.0); // Centrer la carte
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Address not found')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Location Map'),
        backgroundColor: const Color.fromARGB(255, 239, 238, 240),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a location',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchLocation,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: !_isLocationReady
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLocation ?? LatLng(0.0, 0.0),
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/mapbox/outdoors-v11/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiaGFmaWxhdHktcHJvamVjdCIsImEiOiJjbTU5bHNma3owd3BxMmxyNzY4d21yODJsIn0.-hI5FcSLnLC8FVxyny3UTA",
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1IjoiaGFmaWxhdHktcHJvamVjdCIsImEiOiJjbTU5bHNma3owd3BxMmxyNzY4d21yODJsIn0.-hI5FcSLnLC8FVxyny3UTA',
                  },
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      width: 80.0,
                      height: 80.0,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
