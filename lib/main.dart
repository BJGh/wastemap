import 'package:calory_calc/models/food_track_task.dart';
import 'package:calory_calc/firebase_options.dart';
import 'package:calory_calc/screens/day_view/day_view.dart';
import 'package:calory_calc/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'screens/history/history_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:calory_calc/providers/theme_notifier.dart';
import 'package:calory_calc/services/shared_preference_services.dart';
import 'package:calory_calc/helpers/theme.dart';
import 'package:calory_calc/routers/router.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:calory_calc/screens/map/map.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesService().init();
  runApp(CalorieTrackerApp());
}

class CalorieTrackerApp extends StatefulWidget {
  @override
  _CalorieTrackerAppState createState() => _CalorieTrackerAppState();
}

class _CalorieTrackerAppState extends State<CalorieTrackerApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  late Widget homeWidget;
  late bool signedIn;
  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  void checkFirstSeen() {
    Homepage();
    final bool _firstLaunch = true;
    if (_firstLaunch) {
      homeWidget = Homepage();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DarkThemeProvider>(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder:
            (BuildContext context, DarkThemeProvider value, Widget? child) {
          return GestureDetector(
              onTap: () => hideKeyboard(context),
              child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  builder: (_, Widget? child) => ScrollConfiguration(
                      behavior: MyBehavior(), child: child!),
                  theme: themeChangeProvider.darkTheme ? darkTheme : lightTheme,
                  home: homeWidget,
                  onGenerateRoute: RoutePage.generateRoute));
        },
      ),
    );
  }

  void hideKeyboard(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Center(
        child: TextButton(
          onPressed: () {
            // Navigate back to homepage
          },
          child: const Text('Go Back!'),
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _Homepage();
  }
}

class _Homepage extends State<Homepage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  void onClickHistoryScreenButton(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HistoryScreen()));
  }

  void onClickSettingsScreenButton(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SettingsScreen()));
  }

  void onClickDayViewScreenButton(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => DayViewScreen()));
  }

  void onClickMapScreenButton(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MapScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle =
        IconButton.styleFrom(foregroundColor: Colors.green);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Flutter WasteMap ",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: new Column(
          children: <Widget>[
            new ListTile(
                leading: const Icon(Icons.food_bank),
                title: new Text("Welcome To WasteMap!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            new ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.greenAccent,
                    minimumSize: Size(100, 40)),
                onPressed: () {
                  onClickDayViewScreenButton(context);
                },
                child: Row(children: [
                  Text("Day View Screen"),
                  Icon(Icons.sunny, size: 24.0)
                ], mainAxisSize: MainAxisSize.min)),
            new SizedBox(height: 30),
            new ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.greenAccent,
                    minimumSize: Size(100, 40)),
                onPressed: () {
                  onClickHistoryScreenButton(context);
                },
                child: Row(children: [
                  Text("History Screen"),
                  Icon(Icons.auto_graph, size: 24.0)
                ], mainAxisSize: MainAxisSize.min)),
            new SizedBox(height: 30),
            new ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.greenAccent,
                    minimumSize: Size(100, 40)),
                onPressed: () {
                  onClickSettingsScreenButton(context);
                },
                child: Row(children: [
                  Text("Settings Screen"),
                  Icon(Icons.settings, size: 24.0),
                ], mainAxisSize: MainAxisSize.min)),
            new SizedBox(height: 30),
            new ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.greenAccent,
                    minimumSize: Size(100, 40)),
                onPressed: () {
                  onClickMapScreenButton(context);
                },
                child: Row(
                  children: [Text("Map"), Icon(Icons.map, size: 24.0)],
                  mainAxisSize: MainAxisSize.min,
                ))
          ],
        ));
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
