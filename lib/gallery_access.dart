import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trailmate/event.dart';

import 'map_details.dart';

class GalleryAccess extends StatefulWidget {
  const GalleryAccess({super.key});

  @override
  State<GalleryAccess> createState() => _GalleryAccessState();
}

class _GalleryAccessState extends State<GalleryAccess> {
  File? galleryFile;
  final picker = ImagePicker();
  final _storage = FirebaseStorage.instance;
  PickedFile? image;

  @override
  Widget build(BuildContext context) {
    //display image selected from gallery

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery and Camera Access'),
        backgroundColor: Colors.green,
        actions: const [],
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  child: const Text('Select Image from Gallery or Camera'),
                  onPressed: () {
                    _showPicker(context: context);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 200.0,
                  width: 300.0,
                  child: galleryFile == null
                      ? const Center(child: Text('Sorry nothing selected!!'))
                      : Center(child: Image.file(galleryFile!)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0),
                  child: Text(
                    "Nice Picture!",
                    textScaleFactor: 3,
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    child: const Text('Go Back'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () async {
                  image = await picker.getImage(source: ImageSource.gallery);
                  setState(() {
                    galleryFile = File(image!.path);
                  });
                  var file = File(image!.path);
                  //Upload to Firebase
                  var snapshot = await _storage
                      .ref()
                      .child('folderName/imageName')
                      .putFile(file);

                  var downloadUrl = await snapshot.ref.getDownloadURL();

                  await FirebaseFirestore.instance.collection('image').add({
                    'imageURL': downloadUrl
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  image = await picker.getImage(source: ImageSource.camera);
                  var file = File(image!.path);
                  setState(() {
                    galleryFile = File(image!.path);
                  });
                  //Upload to Firebase
                  var snapshot = await _storage
                      .ref()
                      .child('folderName/dog')
                      .putFile(file);

                  var downloadUrl = await snapshot.ref.getDownloadURL();

                  await FirebaseFirestore.instance.collection('image').add({
                    'imageURL': downloadUrl
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
