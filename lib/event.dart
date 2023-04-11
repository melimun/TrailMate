import 'package:flutter/material.dart';
import 'package:trailmate/camera.dart';

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';



class PinEvent extends StatelessWidget {
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
        TextButton(
        child: const Text('Go back'),
        onPressed: () {
          Navigator.pop(context);
        },),
            FloatingActionButton(
              child: const Text('Go To Camera'),
              onPressed: () {
                MaterialPageRoute(
                  builder: (context) => TakePictureScreen(camera: camera),
                ),
              },),
          ],



        ),
      ),


    );



  }



}
