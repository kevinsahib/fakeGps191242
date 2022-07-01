import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? latitude;
  String? longitude;
  bool? isMock;
  bool showText = false;

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  void getLcoation() async {
    try {
      TrustLocation.onChange.listen((result) {
        latitude = result.latitude;
        longitude = result.longitude;
        isMock = result.isMockLocation;
        if (latitude == null && longitude == null) {
          latitude = " - - - ";
          longitude = " - - - ";
        }
        showText = true;
      });
    } catch (e) {
      print("Error:");
      // ignore: avoid_print
      print(e);
    }
  }

  void requestPermission() async {
    final permission = await Permission.location.request();

    if (permission == PermissionStatus.granted) {
      TrustLocation.start(10);
      getLcoation();
    } else if (permission == PermissionStatus.denied) {
      await Permission.location.request();
      getLcoation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(showText
            ? "Lat: $latitude\nLong: $longitude\nisMock: $isMock"
            : "Lat: $latitude\nLong: $longitude\nisMock: $isMock"),
      ),
    );
  }
}
