import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

class LocationProvider with ChangeNotifier {
  final Location _location = Location();
  LatLng _currentLocation = const LatLng(0, 0);
  List<LatLng> _polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Marker? _currentLocationMarker;
  Marker? _selectedLocationMarker;
  BitmapDescriptor? _customCurrentLocationIcon;
  Timer? _timer;

  LatLng get currentLocation => _currentLocation;
  Set<Polyline> get polylines => _polylines;

  Set<Marker> get markers {
    final markers = <Marker>{};
    if (_currentLocationMarker != null) markers.add(_currentLocationMarker!);
    if (_selectedLocationMarker != null) markers.add(_selectedLocationMarker!);
    return markers;
  }

  LocationProvider() {
    _initializeCustomMarkerIcon();
    _initializeLocationUpdates();
  }

  void _initializeCustomMarkerIcon() async {
    _customCurrentLocationIcon = await BitmapDescriptor.asset(
      height: 60,
      width: 60,
      const ImageConfiguration(size: Size(60, 60)),
      'assets/icons/current_location_icon.png',
    );
  }

  void _initializeLocationUpdates() async {
    final initialLocation = await _location.getLocation();
    _updateLocation(initialLocation);

    _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
      final updatedLocation = await _location.getLocation();
      _updateLocation(updatedLocation);
    });
  }

  void _updateLocation(LocationData currentLocation) {
    LatLng newPosition = LatLng(
      currentLocation.latitude ?? 0.0,
      currentLocation.longitude ?? 0.0,
    );

    _currentLocation = newPosition;
    _polylineCoordinates.add(_currentLocation);

    _currentLocationMarker = Marker(
      markerId: const MarkerId('currentLocation'),
      position: _currentLocation,
      icon: _customCurrentLocationIcon ?? BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: 'My Current Location',
        snippet: '${_currentLocation.latitude}, ${_currentLocation.longitude}',
      ),
    );

    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: _polylineCoordinates,
        color: Colors.blue,
        width: 5,
      ),
    };

    notifyListeners();
  }

  void addMarker(LatLng position) {
    _selectedLocationMarker = Marker(
      markerId: const MarkerId('selectedLocation'),
      position: position,
      infoWindow: InfoWindow(
        title: 'Selected Location',
        snippet: '${position.latitude}, ${position.longitude}',
      ),
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
