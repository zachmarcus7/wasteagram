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
        centerTitle: true,
        title: StreamBuilder(
          stream:
            FirebaseFirestore.instance
              .collection('total_posts')
              .snapshots(),
          builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData &&
                  snapshot.data!.docs != null &&
                  snapshot.data!.docs.length > 0) {
                    int totalQuantity = snapshot.data!.docs[0]['total_quantity'];
                    return Text('Wasteagram - ${totalQuantity}');
                  } else {
                    return Text('Wasteagram - 0');
                  }
            }
        ),
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
                    child: Semantics(
                      container: true,
                      onTapHint: 'Leads to details page.',
                      child: ListTile(
                        title: Text(post['date']),
                        trailing: Text(post['quantity'])
                      )
                    ),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
      floatingActionButton: Semantics(
        container: true,
        button: true,
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