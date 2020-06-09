import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rastreimy/models/user_model.dart';
import 'package:rastreimy/util/correios.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class OrderDetailScreen extends StatefulWidget {
  final DocumentSnapshot orderData;
  @override
  _OrderDetailScreen createState() => _OrderDetailScreen();
  OrderDetailScreen({Key key, this.orderData}) : super(key: key);
}

class _OrderDetailScreen extends State<OrderDetailScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<TimelineModel> items = [
      TimelineModel(
          Container(
            color: Colors.white,
            child: ListTile(
              title: Text("Text"),
              
            ),
          ),
          position: TimelineItemPosition.random,
          iconBackground: Colors.blue,
          icon: Icon(Icons.blur_circular)),
      TimelineModel(Placeholder(),
          position: TimelineItemPosition.random,
          iconBackground: Colors.blue,
          icon: Icon(Icons.blur_circular)),
    ];
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Color.fromARGB(255, 22, 98, 187)),
          elevation: 0.0,
          title: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: 30,
              width: 30,
              child: Image.asset(
                'assets/images/title.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.isLoading)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Timeline(children: items, position: TimelinePosition.Center);
        }));
  }
}
