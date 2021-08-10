import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasteagram/models/screen_waste_post.dart';
import 'package:wasteagram/screens/details.dart';
import 'package:wasteagram/screens/new_post.dart';


class Entries extends StatefulWidget {
  @override
  _EntriesState createState() => _EntriesState();
}

class _EntriesState extends State<Entries> {

  ScreenWastePost? screenWastePost;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wastegram'),
        centerTitle: true
      ),
      body: StreamBuilder(
        stream:
          FirebaseFirestore.instance
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData &&
              snapshot.data!.docs != null &&
              snapshot.data!.docs.length > 0) { 
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var post = snapshot.data!.docs[index];
                  var postDTO = ScreenWastePost.fromSnapshot(post);
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Details(
                          post: postDTO
                        ))
                      );
                    },
                    child: ListTile(
                      title: Text(post['date']),
                      trailing: Text(post['quantity'])
                    ),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
      floatingActionButton: Semantics(
        label: 'Select picture for the new post.',
        child: FloatingActionButton(
          child: Icon(Icons.camera_alt),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NewPost()
              )
            );  
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}