import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calory_calc/models/food_track_task.dart';
import 'package:calory_calc/component/iconpicker/icon_picker_builder.dart';
import 'package:calory_calc/utils/charts/datetime_series_chart.dart';
import 'package:calory_calc/screens/day_view/calory-stats.dart';
import 'package:provider/provider.dart';
import 'package:calory_calc/services/database.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'dart:math';
import 'dart:async';
import 'package:calory_calc/utils/theme_colors.dart';
import 'package:calory_calc/utils/constants.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _currentPosition;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('openstreetmap Flutter'),
      ),
      body: Container(
        child: FlutterMap(
            options:
                MapOptions(center: LatLng(-12.069783, -77.034057), zoom: 13.0),
            children: <Widget>[
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              if (_currentPosition != null)
                MarkerLayer(markers: [
                  Marker(
                    point: LatLng(_currentPosition?.latitude ?? 0,
                        _currentPosition?.longitude ?? 0),
                    builder: (ctx) =>
                        Icon(Icons.location_on, color: Colors.red),
                  ),
                ]),
            ]),
      ),
    );
  }
}
