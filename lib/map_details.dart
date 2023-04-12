import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as geoCo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'event.dart';
import 'firebase_options.dart';
import 'dart:developer';
import 'dart:ui' as ui;



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

  Map<MarkerId, Marker> markers = <MarkerId,Marker>{};


  void placeMarkers(double lat, double long){
    MarkerId markerId = MarkerId(lat.toString() + long.toString());

    Marker _marker = Marker(
        markerId: markerId,
        position: LatLng(lat,long),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueCyan
        ),
        infoWindow: const InfoWindow(title:'Address')
    );

    setState((){
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
      // Remove any existing 'current' marker from the map
      markers.remove(const MarkerId("current"));
      // Add the new 'current' marker to the map

      markers[const MarkerId("current")] = Marker(
        markerId: const MarkerId("current"),
        position: LatLng(newLoc.latitude!, newLoc.longitude!),
          icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            'assets/images/main.png',
          ),
        infoWindow:
          const InfoWindow(title: 'hello!')
      );

      setState(() {});
    });
  }

  populateClients() {
    FirebaseFirestore.instance.collection("markers").get().then((docs) {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; ++i) {
          initMarker(docs.docs[i].data(), docs.docs[i].id);
        }
      }
    });
  }

  void initMarker(doc, docId) async{
    log('initMarker called');
    var markerIdVal = docId;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
          doc['location'].latitude, doc['location'].longitude
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueCyan
      ),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  void initState(){
    super.initState();
    getCurrentLocation();
    populateClients();
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
            target: LatLng(currentLocation!.latitude!,
                currentLocation!.longitude!),
            zoom: 13.5,
          ),
          onTap: (tapped) async{
            placeMarkers(tapped.latitude, tapped.longitude);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PinEvent()),
            );

            await FirebaseFirestore.instance
                .collection('markers')
                .add({
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
                      List<geoCo.Location> locations1 =
                      await geoCo.locationFromAddress(_source.text);
                      List<geoCo.Location> locations2 =
                      await geoCo.locationFromAddress(_destination.text);
                      setState(() {
                          sourceLocation = LatLng(
                              locations1[0].latitude, locations1[0].longitude);
                          // destination = LatLng(
                        //       locations2[0].latitude, locations2[0].longitude);
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
