import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../provider/location_provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Google Map Location Tracker',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: locationProvider.currentLocation,
          zoom: 14.0,
        ),
        markers: locationProvider.markers,
        polylines: locationProvider.polylines,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          _animateToUserLocation(locationProvider.currentLocation);
        },
        onTap: (LatLng tappedLocation) {
          locationProvider.addMarker(tappedLocation);
        },
      ),
    );
  }

  void _animateToUserLocation(LatLng location) {
    _controller?.animateCamera(
      CameraUpdate.newLatLng(location),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    locationProvider.addListener(() {
      _animateToUserLocation(locationProvider.currentLocation);
    });
  }
}
