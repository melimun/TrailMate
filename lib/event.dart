import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trailmate/camera.dart';
import 'package:trailmate/gallery_access.dart';
import 'package:trailmate/map_details.dart';



class PinEvent extends StatelessWidget {

  TextEditingController typeOfEventsController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();


// Obtain a list of the available cameras on the device.







// Get a specific camera from the list of available cameras.
// inputs, type of events, name of event, description and photo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.eco_outlined),
        title: const Text(
          'Event Pin',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff79a666),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 300,
              child: TextField(decoration: const InputDecoration(labelText: "name of event", contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 5)) ,
                controller: nameController,
              ),
            ),
            SizedBox(
              width: 300,
              child: TextField(decoration: const InputDecoration(labelText: "type of event", contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 5)),
                controller: typeOfEventsController,
                //onChanged: (event) => typeOfEventsController.text = event,
              ),
            ),
            SizedBox(
              width: 300,
              child: TextField(decoration: const InputDecoration(labelText: "description", contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 5),),
                controller: descriptionController,
                // onChanged: (description) => descriptionController.text = description,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15.0),
            ),

            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(8.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Add Photo'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const GalleryAccess()));
              },),

            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(8.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Go Back'),
              onPressed: () {
                Navigator.pop(context);
              },),

            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(8.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Save Info'),
              onPressed: () async {
                await FirebaseFirestore.instance.collection('events').add({
                  'eventName': nameController.text,
                  'eventType': typeOfEventsController.text,
                  'eventDescription': descriptionController.text,
                });
              },)
          ],
        ),
      ),
    );
  }
}
