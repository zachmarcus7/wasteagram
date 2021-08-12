  
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';


class NewPost extends StatefulWidget {

  @override
  _NewPostState createState() => _NewPostState();

}

class _NewPostState extends State<NewPost> {

  File? image;
  final picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  var amount;
  String? url;

  @override
  void initState() {
    super.initState();
    getImage();
  }
  
  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('New Post'),
          centerTitle: true,
        ),
        body: Center(child: CircularProgressIndicator())
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('New Post'),
          centerTitle: true
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    height: 270,
                    width: MediaQuery.of(context).size.width,
                    child: Semantics(
                      label: 'Picture of the wasted food.',
                      child: Image.network('${url}')
                    )
                  ),
                  Semantics(
                    label: 'Number of wasted food items.',
                    child: Form(
                      key: formKey,
                      child: Container(
                        height: 200,
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: TextFormField(
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          initialValue: 'Number of Wasted Items',
                          keyboardType: TextInputType.numberWithOptions(decimal: false),
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                          validator: (value) {
                            final intValue = num.tryParse(value as String);
                            if (intValue == null){
                              return 'Please enter amount';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {amount = value;}
                        )
                      )
                    ),
                  )
                ]
              ),
              SizedBox(),
              Semantics(
                label: 'Upload the food waste data.',
                child: GestureDetector(
                  onTap: uploadData,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
                    color: Colors.blue,
                    child: Icon(Icons.cloud_upload, size: 65)
                  )
                )
              )
            ]
          )
        )
      );
    }
  }

  void uploadData() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // retrieve the latitude and longitude of the device
      LocationData? locationData;
      var locationService = Location();
      locationData = await retrieveLocation(locationService, locationData);

      FirebaseFirestore.instance
        .collection('posts')
        .add({'date': DateFormat.yMMMMd('en_US').format(DateTime.now()).toString(), 
              'imageURL': url, 
              'quantity': amount,
              'latitude': '${locationData.latitude}',
              'longitude': '${locationData.longitude}',
              'timestamp': DateTime.now().millisecondsSinceEpoch
            });
      
      // get the original quantity sum
      dynamic totalQuantity = 0;
      await FirebaseFirestore.instance
        .collection('total_posts')
        .doc('OZU7KnZ5GaamaUiT29zW')
        .get()
        .then((DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            try {
                totalQuantity = snapshot.get(FieldPath(['total_quantity']));
            } on StateError catch(e) {
              print('Field doesn\'t exist.');
            }
          }
        });

        // update the quantity sum
        totalQuantity = totalQuantity + int.tryParse(amount);
        FirebaseFirestore.instance.collection('total_posts')
          .doc('OZU7KnZ5GaamaUiT29zW')
          .update({'total_quantity': totalQuantity})
          .then((value) => print('Updated quantity'))
          .catchError((error) => print('Failed to update quantity: $error'));

      Navigator.of(context).pop();
    }
  }

  Future<LocationData> retrieveLocation(Location locationService, LocationData? locationData) async {
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          print('Failed to enable service. Returning');

          // return an empty, placeholder LocationData object
          Location emptyLocation = Location();
          return await emptyLocation.getLocation();
        }
      }

      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location service permission not granted. Returning.');
        }
      }

      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }
    locationData = await locationService.getLocation();
    return locationData;
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    image = File(pickedFile!.path);

    var fileName = DateTime.now().toString() + '.jpg';
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(image!);
    await uploadTask;
    url = await storageReference.getDownloadURL();
    setState(() {});
  }


}