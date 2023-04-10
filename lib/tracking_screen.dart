import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart' as lo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:trailmate/.env.dart';


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
  List<LatLng> polylineCoordinates = [];
  bool isBool = false; //This is for when the user is first loaded; they're not anywhere yet.

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

  //show polyline from source to destination
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
            (PointLatLng point) => polylineCoordinates.add(
          LatLng(
            point.latitude,
            point.longitude,
          ),
        ),
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentLocation();
    getPolyPoints();
    //setCustomMarkerIcon();
    super.initState();
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
        body:
            currentLocation == null
            ? const Center(child: Text("Loading"))
            : GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          //tiltGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
            target: sourceLocation,
            zoom: 13.5,
          ),
          polylines: {
            //it is for polyline on your source to destination
            Polyline(
              polylineId: const PolylineId("route"),
              points: polylineCoordinates,
              color: primaryColor,
              width: 6,
            )
          },
          markers: {
            Marker(
              // icon:
              markerId: const MarkerId("source"),
              position: sourceLocation,
            ),
            Marker(
              //icon: currentLocationIcon,
                markerId: const MarkerId("currentLocation"),
                position: LatLng(currentLocation!.latitude!,
                    currentLocation!.longitude!)),
          },
          onMapCreated: (mapController) {
            //change map camera position according to the location change
            _controller.complete(mapController);
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right:10.0, bottom:110.0),
          child: FloatingActionButton(
          onPressed: () => _create(),
          child: _getCustomPin(),
            backgroundColor: const Color(0xff79a666),
        ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat);
  }

  Widget _getCustomPin() {
    return Center(
      child: Container(
        width: 150,
        child: const Icon(
          Icons.location_on_rounded,
          color: Colors.white,
          size:30.0,
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
                        isBool = true; //After set place. it is true
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