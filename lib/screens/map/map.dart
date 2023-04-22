import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _currentPosition;
  MapController _mapController = MapController();
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  _showLocationInputDialog(BuildContext context) {
    TextEditingController customLocationController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add custom location'),
          content: TextField(
            controller: customLocationController,
            decoration: InputDecoration(hintText: "Enter location..."),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String customLocation = customLocationController.text;
                _addMarker(customLocation);
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  List<Marker> _markers = [];
  void _addMarker(String location) async {
    String apiKey =
        "49c51d4f6b6f449fafb52110c5f2c6ee"; // replace with your actual API key
    String url = "https://api.opencagedata.com/geocode/v1/json?q=" +
        Uri.encodeQueryComponent(location) +
        "&key=" +
        apiKey +
        "&language=en&pretty=1";

    // Make the HTTP request
    http.Response response = await http.get(Uri.parse(url));

    // Parse the JSON response
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    List<dynamic> results = jsonResponse['results'];
    if (results.length > 0) {
      Map<String, dynamic> firstResult = results[0];
      Map<String, dynamic> geometry = firstResult['geometry'];
      LatLng latLng = LatLng(geometry['lat'], geometry['lng']);
      setState(() {
        _markers.add(
          Marker(
            width: 50.0,
            height: 50.0,
            point: latLng,
            builder: (ctx) => Container(
              child: Icon(
                Icons.location_on,
                color: Colors.blue,
              ),
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('openstreetmap Flutter'),
      ),
      body: Container(
        child: FlutterMap(
          options: MapOptions(
            center: _currentPosition == null
                ? LatLng(-12.069783, -77.034057)
                : LatLng(
                    _currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 13.0,
          ),
          children: <Widget>[
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: _markers,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showLocationInputDialog(context);
        },
        child: Icon(Icons.add_location),
      ),
    );
  }
}
