import 'package:calory_calc/models/food_track_task.dart';
import 'package:flutter/cupertino.dart';
import 'router_constants.dart';
import 'package:calory_calc/main.dart';
import 'package:calory_calc/views/undefined_view.dart';

class RoutePage {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstant.ROOT:
        return PageRouteBuilder<dynamic>(
            settings: settings,
            pageBuilder: (_, __, ___) => Homepage(),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));
      default:
        return PageRouteBuilder<dynamic>(
            settings: settings,
            pageBuilder: (_, __, ___) => UndefinedView(
                  routeName: settings.name!,
                ),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));
    }
  }
}
