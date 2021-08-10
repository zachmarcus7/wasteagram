import 'package:flutter/material.dart';
import 'package:wasteagram/models/screen_waste_post.dart';


class Details extends StatefulWidget {

  ScreenWastePost post;

  Details({required this.post});

  @override
  _DetailsState createState() => _DetailsState();

}

class _DetailsState extends State<Details> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wasteagram'),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget> [
            Container(
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 60),
              child: Text('${widget.post.date}', style: TextStyle(fontSize: 30)),
            ),
            Container(
              height: 300,
              child: Image.network('${widget.post.imageURL}')
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 50, 0, 50),
              child: Text('${widget.post.quantity} items', style: TextStyle(fontSize: 30))
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Text('Location: (${widget.post.latitude}, ${widget.post.longitude})')
            )
          ]
        )
      )
    );
  }

}