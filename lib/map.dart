import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:trailmate/tracking_screen.dart';
import 'package:camera/camera.dart';

Future<void> main() async {
  //try bringing camera from map, tracking screen, event then camera
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  final firstCamera = cameras.first;

  runApp(MyApp(firstCamera));
}

class MyApp extends StatefulWidget {
  MyApp(this.camera);
  final CameraDescription camera;


  @override
  State<StatefulWidget> createState() {
    return _MyAppState(camera);
  }
}

class _MyAppState extends State<MyApp> {
  _MyAppState(this.camera);
  final CameraDescription camera;

  Location location = Location();
  LocationData? currentLocation;
  void getCurrentLocation() {
    //location.enableBackgroundMode(enable: true);

    location.getLocation().then((location) {
      setState(() {
        currentLocation = location;
        // sourceLocation =
        //     LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
        // destination =
        //     LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: TrackingScreen(camera),
    );
  }
}