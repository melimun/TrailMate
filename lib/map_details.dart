import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'event.dart';
import 'dart:developer';

class MapDetails extends StatefulWidget {
  const MapDetails({Key? key}) : super(key: key);

  @override
  State<MapDetails> createState() => _MapDetailsState();
}

class _MapDetailsState extends State<MapDetails> {
  final Completer<GoogleMapController> _controller = Completer();
  LocationData? currentLocation;

  LatLng sourceLocation = const LatLng(43.4691, 79.7000);
  final TextEditingController _source = TextEditingController();
  final TextEditingController _destination = TextEditingController();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void placeMarkersTap(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());

    Marker _marker = Marker(
        markerId: markerId,
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        onTap: () => _create());

    setState(() {
      markers[markerId] = _marker;
    });
  }

  void getCurrentLocation() async {
    Location location = Location();
    location
        .getLocation()
        .then((location) => setState(() => currentLocation = location));
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen((newLoc) async {
      currentLocation = newLoc;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(newLoc.latitude!, newLoc.longitude!), zoom: 16)));

      /* this is specifically for the current location marker*/
      markers.remove(const MarkerId("current"));
      markers[const MarkerId("current")] = Marker(
          markerId: const MarkerId("current"),
          position: LatLng(newLoc.latitude!, newLoc.longitude!),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          infoWindow: const InfoWindow(title: 'hello!'));

      setState(() {});
    });
  }

  void getMarkersFromFireStore() {
    FirebaseFirestore.instance.collection("markers").get().then((docs) {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; ++i) {
          initMarker(docs.docs[i].data(), docs.docs[i].id);
        }
      }
    });
  }

  void initMarker(doc, docId) async {
    log('initMarker called');
    var markerIdVal = docId;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(doc['location'].latitude, doc['location'].longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getMarkersFromFireStore();

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
            ? const Center(child: Text("Loading... Please wait!"))
            : GoogleMap(
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                  zoom: 13.5,
                ),
                onTap: (tapped) async {
                  placeMarkersTap(tapped.latitude, tapped.longitude);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PinEvent()),
                  );

                  //ToDo:THIS IS WHAT'S BEING PUSHED TO DATABASE ON TAP
                  await FirebaseFirestore.instance.collection('markers').add({
                    'location': GeoPoint(tapped.latitude, tapped.longitude),
                    'iconHue': 'hueCyan',
                  });
                },
                markers: Set<Marker>.of(markers.values),
                onMapCreated: (mapController) {
                  //change map camera position according to the location change
                  _controller.complete(mapController);
                },
              ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 10.0, bottom: 110.0),
          child: FloatingActionButton(
            onPressed: () => _create(),
            backgroundColor: const Color(0xff79a666),
            child: _getCustomPin(),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniEndFloat);
  }

  Widget _getCustomPin() {
    return const Center(
      child: SizedBox(
        width: 150,
        child: Icon(
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
                  Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.asset(
                    //ToDo: REPLACE THIS IMAGE WITH USER URL
                    'assets/images/test.jpeg',
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Center(
                      child: Text(
                        //ToDo:REPLACE THIS WITH PIN TITLE
                        //ToDo: LIMIT CHARACTERS
                        'Pin Title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      ),
                      SizedBox(height: 8),
                      //ToDo: Pin type here; we can change colour corresponding to theme
                      //ToDo: remove this if too complicated
                      Text('Pin type:${1010101}'),
                      SizedBox(height: 8),
                      Text('Description:${101010}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ]
          ),
          );
        }
    );
  }
}
