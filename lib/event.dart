import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trailmate/camera.dart';
import 'package:camera/camera.dart';

import 'dart:async';
import 'dart:io';

import 'package:trailmate/gallery_access.dart';
import 'package:trailmate/main.dart';
import 'package:trailmate/map_details.dart';



class PinEvent extends StatelessWidget {
  PinEvent();


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
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.all(8.0),
              textStyle: const TextStyle(fontSize: 20),
            ),
            child: const Text('Go back'),
            onPressed: () {
              // Navigator.pop(context);
              Navigator.of(context).pop(MaterialPageRoute(
                  builder: (BuildContext context) => MapDetails()));
            },),
        ),

            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(8.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('View Gallery'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => GalleryAccess()));
              },),
          ],
        ),
      ),
    );
  }
}
