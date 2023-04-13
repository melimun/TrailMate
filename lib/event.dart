import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trailmate/camera.dart';
import 'package:camera/camera.dart';

import 'dart:async';
import 'dart:io';

import 'package:trailmate/gallery_access.dart';



class PinEvent extends StatelessWidget {
  PinEvent(this.camera);

  final CameraDescription camera;


  TextEditingController typeOfEventsController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();


// Obtain a list of the available cameras on the device.

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    typeOfEventsController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    //super.dispose();
  }


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
              child: TextField(decoration: const InputDecoration(labelText: "name of event") ,
                controller: nameController,
              ),
            ),
            SizedBox(
              width: 300,
              child: TextField(decoration: const InputDecoration(labelText: "type of event", contentPadding: EdgeInsets.symmetric(vertical: 40),),
                controller: typeOfEventsController,
              ),
            ),
            SizedBox(
              width: 300,
              child: TextField(decoration: const InputDecoration(labelText: "description", contentPadding: EdgeInsets.symmetric(vertical: 40),),
                controller: descriptionController,
              ),
            ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.all(8.0),
            textStyle: const TextStyle(fontSize: 20),
          ),
        child: const Text('Go back'),
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
              child: const Text('Go To Camera'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => TakePictureScreen(camera: camera),)
                );
              },),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(8.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Save Info'),
              onPressed: () {
              },),

          ],
        ),
      ),
    );
  }
}
