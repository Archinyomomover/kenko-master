import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class FreeMapScreen extends StatefulWidget {
  const FreeMapScreen({super.key});

  @override
  State<FreeMapScreen> createState() => _FreeMapScreenState();
}

class _FreeMapScreenState extends State<FreeMapScreen> {
  LatLng? userLocation;

  final Map<String, Map<String, LatLng>> placesByCategory = {
    'Gym': {
      'Gym 1': LatLng(1.3000, 103.8000),
      'Gym 2': LatLng(1.3010, 103.8010),
      'Gym 3': LatLng(1.3020, 103.8020),
    },
    'Supermarket': {
      'Supermarket 1': LatLng(1.3050, 103.8100),
      'Supermarket 2': LatLng(1.3060, 103.8110),
      'Supermarket 3': LatLng(1.3070, 103.8120),
    },
    '7-Eleven': {
      '7-Eleven 1': LatLng(1.2990, 103.8020),
      '7-Eleven 2': LatLng(1.2980, 103.8030),
      '7-Eleven 3': LatLng(1.2970, 103.8040),
    },
  };

  String selectedCategory = 'Gym';

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      userLocation = LatLng(pos.latitude, pos.longitude);
    });
  }

  void _launchDirections(LatLng target) async {
    if (userLocation == null) return;

    final Uri url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=${userLocation!.latitude},${userLocation!.longitude}'
      '&destination=${target.latitude},${target.longitude}'
      '&travelmode=driving',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch directions.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPlaces = placesByCategory[selectedCategory]!;

    return Scaffold(
      appBar: AppBar(title: const Text("Find Nearby Places")),
      body: userLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    isExpanded: true,
                    items: placesByCategory.keys
                        .map((cat) =>
                            DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          selectedCategory = val;
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: userLocation!,
                      initialZoom: 15,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          // User location marker
                          Marker(
                            point: userLocation!,
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.person_pin_circle,
                              size: 40,
                              color: Colors.blue,
                            ),
                          ),
                          // All places in category
                          for (var entry in currentPlaces.entries)
                            Marker(
                              point: entry.value,
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () => _launchDirections(entry.value),
                                child: const Icon(
                                  Icons.place,
                                  size: 40,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    'Tap on a red marker to get directions',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
    );
  }
}
