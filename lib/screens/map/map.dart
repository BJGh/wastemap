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

class MapScreen extends StatefulWidget {
  @override
  _MapScreen createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("openstreetmap Flutter"),
      ),
      body: Container(
        child: FlutterMap(
          options:
              MapOptions(center: LatLng(-12.069783, -77.034057), zoom: 13.0),
          children: [
            TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
            MarkerLayer(markers: [
              Marker(
                  width: 30.0,
                  height: 30.0,
                  point: LatLng(-12.069783, -77.034057),
                  builder: (ctx) => Container(
                          child: Container(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blueAccent,
                          size: 40,
                        ),
                      )))
            ])
          ],
        ),
      ),
    );
  }
}
