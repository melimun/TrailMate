import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart' as lo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:trailmate/.env.dart';
import 'package:trailmate/event.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng sourceLocation = LatLng(23.847879799999998, 90.2575646);
  LatLng destination = LatLng(23.7932126, 90.2713349);
  final TextEditingController _source = TextEditingController();
  final TextEditingController _destination = TextEditingController();

  List<Marker> myMarker = [];

  //get current location
  Location location = Location();

  LocationData? currentLocation;
  void getCurrentLocation() async {
    //location.enableBackgroundMode(enable: true);
    location.getLocation().then((location) {
      setState(() {
        currentLocation = location;
        sourceLocation = LatLng(location!.latitude!, location!.longitude!);
        destination = LatLng(location!.latitude!, location!.longitude!);
      });
    });
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen((newLoc) {
      //change camera position according to the camera position change
      currentLocation = newLoc;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 18,
              target: LatLng(newLoc!.latitude!, newLoc!.longitude!))));
      setState(() {});
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    //setCustomMarkerIcon();
    super.initState();
  }

  _handleTap(LatLng point) {
    print('HANDLE TAP IS CALLED');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PinEvent(),
      ),
    );
    setState(() {
      myMarker.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: const InfoWindow(
          title: 'Marker Title Variable',
          snippet: '<a href="">Edit Pin Maybe</a>',
        ),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.eco_outlined),
          title: const Text(
            'Trail Mate',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xff79a666),
        ),
        body: currentLocation == null
            ? const Center(child: Text("Loading"))
            : GoogleMap(
                zoomGesturesEnabled: false,
                tiltGesturesEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: sourceLocation,
                  zoom: 13.5,
                ),
                onTap: _handleTap,
                markers: Set.from(myMarker),
                //Marker(
                //       markerId: const MarkerId("currentLocation"),
                //       position: LatLng(currentLocation!.latitude!,
                //           currentLocation!.longitude!)),
                // ),
                onMapCreated: (mapController) {
                  //change map camera position according to the location change
                  _controller.complete(mapController);
                },
              ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 10.0, bottom: 110.0),
          child: FloatingActionButton(
            onPressed: () => _create(),
            child: _getCustomPin(),
            backgroundColor: const Color(0xff79a666),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniEndFloat);
  }

  Widget _getCustomPin() {
    return Center(
      child: Container(
        width: 150,
        child: const Icon(
          Icons.person,
          color: Colors.white,
          size: 30.0,
        ),
      ),
    );
  }

  Future<void> _create() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _source,
                  decoration: const InputDecoration(labelText: 'Your Location'),
                ),
                TextField(
                  // keyboardType:
                  //     const TextInputType.text,
                  controller: _destination,
                  decoration: const InputDecoration(
                    labelText: 'Destination',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    child: const Text('Create'),
                    onPressed: () async {
                      List<lo.Location> locations1 =
                          await lo.locationFromAddress(_source.text);
                      List<lo.Location> locations2 =
                          await lo.locationFromAddress(_destination.text);
                      setState(() {
                        sourceLocation = LatLng(
                            locations1[0].latitude, locations1[0].longitude);
                        destination = LatLng(
                            locations2[0].latitude, locations2[0].longitude);
                      });
                      _source.clear();
                      _destination.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}
