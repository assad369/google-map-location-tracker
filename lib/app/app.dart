import 'package:flutter/material.dart';
import 'package:google_map_location_tracker/ui/screens/map_screens.dart';
import 'package:provider/provider.dart';

import '../provider/location_provider.dart';

class GoogleMapLocatorApp extends StatelessWidget {
  const GoogleMapLocatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: MaterialApp(
        title: 'Google Map Location Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MapScreen(),
      ),
    );
  }
}
